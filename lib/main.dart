import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shark_stuff/Screens/wrapper.dart';
import 'package:shark_stuff/Service/auth.dart';
import 'package:shark_stuff/models/user.dart';
import 'package:shark_stuff/notifier/SharkNotifier.dart';

void main() => runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => SharkNotifier(),
        ),
      ],
      child: MyApp(),
    ));

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        home: Wrapper(),
      ),
    );
  }
}
