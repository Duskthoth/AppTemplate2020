import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shark_stuff/Screens/authenticate/autenticate.dart';
import 'package:shark_stuff/Screens/home/home.dart';
import 'package:shark_stuff/models/user.dart';


class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);
   
        
    //return either home or authenticate widget
    if(user == null){
      return Authenticate();
    } else{
      return Home();
    }
  }
}