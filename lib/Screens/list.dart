import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shark_stuff/Screens/profile.dart';
import 'package:shark_stuff/models/getter.dart';
import 'package:shark_stuff/notifier/SharkNotifier.dart';

import 'detail.dart';

class Lista extends StatefulWidget {
  @override
  _ListaState createState() => _ListaState();
}

class _ListaState extends State<Lista> {
  @override
  void initState() {
    SharkNotifier sharkNotifier =
        Provider.of<SharkNotifier>(context, listen: false);
    getSharks(sharkNotifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SharkNotifier sharkNotifier = Provider.of<SharkNotifier>(context);

    Future<void> _refreshList() async {
      getSharks(sharkNotifier);
    }

    var customColor = Color.fromRGBO(48, 134, 161, 0.9);
    var blueGrey = Colors.blueGrey[800];

    return Scaffold(
      appBar: AppBar(title:Text('Shark List',style: TextStyle(color:Colors.white),),backgroundColor: blueGrey,centerTitle: true,),
      body:Column(
        children: <Widget>[
          Expanded(
              //flex: 3,
              child: Container(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                //Padding(padding: EdgeInsets.only(top: 10)),
                Expanded(
                  child: Container(
                    //width: 300,
                    child: RefreshIndicator(
                      child: ListView.builder(
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            decoration: BoxDecoration(
                                color: customColor,
                                //borderRadius:
                                 //   BorderRadius.all(Radius.circular(100))
                                 ),
                            child: Stack(
                              children: <Widget>[
                                new Image(
                                  image: NetworkImage(
                                      sharkNotifier.sharkList[index].image),
                                  fit: BoxFit.cover,                                  
                                  colorBlendMode: BlendMode.darken,
                                ),
                                Positioned(
                                  bottom: 5,
                                  right: 5,
                                  child: OutlineButton(
                                    child: Text('Info'),                                 
                                    textColor: Colors.teal[800],
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                    ),
                                    highlightedBorderColor: Colors.blueAccent,
                                    onPressed: () {
                                      sharkNotifier.currentShark =
                                          sharkNotifier.sharkList[index];
                                      Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context) {
                                        return SharkDetail();
                                      }));
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        itemCount: sharkNotifier.sharkList.length,
                      ),
                      onRefresh: _refreshList,
                    ),
                  ),
                ),
               // Padding(padding: EdgeInsets.only(top: 10))
              ],
            ),
          )),
        ],
      ),
      backgroundColor: customColor,
    );
  }
}
