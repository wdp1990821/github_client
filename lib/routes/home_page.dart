import 'package:flutter/material.dart';
import 'package:github_client/common/change_notifier_provider.dart';
import 'package:github_client/common/git.dart';
import 'package:github_client/models/index.dart';
import 'package:github_client/routes/repo_item.dart';
import 'package:provider/provider.dart';

class HomeRoute extends StatefulWidget {
  const HomeRoute({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomeRouteState();
  }
}

class _HomeRouteState extends State<HomeRoute> {
  static const loadingTag = "##loading##"; // 表尾标记
  var _items = <Repo>[Repo()..name = loadingTag];
  bool hasMore = true; // 是否还有数据
  int page = 1; // 当前请求的是第几页

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Localizations.localeOf(context).toString()),
      ),
      body: _buildBody(), // 构建主页面
      drawer: MyDrawer(), // 抽屉菜单
    );
  }

  Widget _buildBody() {
    UserModel userModel = Provider.of<UserModel>(context);
    if (!userModel.isLogin) {
      // 用户未登录，显示登录按钮
      return Center(
        child: ElevatedButton(
          onPressed: () => Navigator.of(context).pushNamed("login"),
          child: const Text("登录"),
        ),
      );
    } else {
      // 已登录，则显示项目列表
      return ListView.separated(
        itemBuilder: (context, index) {
          // 如果到了表尾
          if (_items[index].name == loadingTag) {
            //不足100条，继续获取数据
            if (hasMore) {
              _retrieveData();
              return Container(
                padding: const EdgeInsets.all(16),
                alignment: Alignment.center,
                child: const SizedBox(
                  width: 24.0,
                  height: 24.0,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                  ),
                ),
              );
            } else {
              // 已经加载了100条数据，不再获取数据
              return Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(16),
                child: const Text(
                  '没有更多了',
                  style: TextStyle(color: Colors.grey),
                ),
              );
            }
          }
          return RepoItem(_items[index]);
        },
        separatorBuilder: (context, index) => const Divider(
          height: .0,
        ),
        itemCount: _items.length,
      );
    }
  }

  void _retrieveData() async {
    var data = await Git(context).getRepos(
      queryParameters: {
        'page': page,
        'page_size': 20,
      },
    );
    // 如果返回的数据小于指定的条数，则表示没有更多数据，
    hasMore = data.isNotEmpty && data.length % 20 == 0;
    // 把请求到的新数据添加到items中
    setState(() {
      _items.insertAll(_items.length - 1, data);
      page++;
    });
  }
}

/// 抽屉布局
class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
