import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shark_stuff/Screens/detail.dart';

import 'package:shark_stuff/Screens/profile.dart';
import 'package:shark_stuff/Screens/shark_form.dart';
import 'package:shark_stuff/Service/auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shark_stuff/models/getter.dart';
import 'package:shark_stuff/models/sharks.dart';
import 'package:shark_stuff/notifier/SharkNotifier.dart';

import '../list.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();

  int _selectedIndex = 0;

  @override
  void initState() {
    SharkNotifier sharkNotifier =
        Provider.of<SharkNotifier>(context, listen: false);
    getSharks(sharkNotifier);
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    print(index);
    print(_selectedIndex);
  }

  List<Widget> _widgetOptions = <Widget>[
      Lista(),
      SharkForm(
        isUpdating: false,
        preenchido: false,
      ),
      ProfileScreen(),
    ];

  @override
  Widget build(BuildContext context) {
    

    var customColor = Color.fromRGBO(48, 134, 161, 0.9);
    var blueGrey = Colors.blueGrey[800];
    

    return Scaffold(
      backgroundColor: customColor,
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          unselectedItemColor: Colors.white38,
          backgroundColor: blueGrey,
          selectedItemColor: customColor,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.home), title: Text('Home')),
            BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.plus), title: Text('Add Shark')),
            BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.idBadge), title: Text('Perfil')),
          ]),
    );
  }
}
