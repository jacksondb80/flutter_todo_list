import 'package:flutter/material.dart';
import 'package:todo_list/app/core/database/sqlite_adm_connection.dart';
import 'package:todo_list/app/core/ui/todo_list_ui_config.dart';
import 'package:todo_list/app/modules/auth/auth_module.dart';
import 'package:todo_list/app/modules/splash/splash_page.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({Key? key}) : super(key: key);

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  final sqliteAdminConnection = SqliteAdmConnection();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(sqliteAdminConnection);
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(sqliteAdminConnection);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo List',
      theme: TodoListUiConfig.theme,
      initialRoute: '/login',
      home: SplashPage(),
      routes: {...AuthModule().routers},
    );
  }
}
