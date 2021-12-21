
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shark_stuff/Screens/profile.dart';
import 'package:shark_stuff/models/getter.dart';
import 'package:shark_stuff/models/sharks.dart';
import 'package:shark_stuff/notifier/SharkNotifier.dart';
import 'shark_form.dart';

class SharkDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SharkNotifier sharkNotifier = Provider.of<SharkNotifier>(context);

    _onSharkDeleted(Shark shark) {
      Navigator.pop(context);
      sharkNotifier.deleteShark(shark);
    }

    return Scaffold(
      appBar: AppBar(backgroundColor: blueGrey,title: Text('Detalhes'),centerTitle: true,),
      backgroundColor: customColor,
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            child: Column(
              children: <Widget>[
                Image.network(
                  sharkNotifier.currentShark.image != null
                      ? sharkNotifier.currentShark.image
                      : 'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg',
                  width: MediaQuery.of(context).size.width,
                  height: 250,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 24),
                Text(
                  sharkNotifier.currentShark.especie,
                  style: TextStyle(
                    fontSize: 40,color: Colors.white,
                  ),
                ),
                Text(
                  'Nome Cientifico: ${sharkNotifier.currentShark.nomeCientifico}',
                  style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic,color: Colors.white),
                ),
                SizedBox(height: 20),
                Text(
                  "Atributos",
                  style: TextStyle(fontSize: 18, decoration: TextDecoration.underline,color: Colors.white),
                ),
                SizedBox(height: 16),
                GridView.count(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  padding: EdgeInsets.all(8),
                  crossAxisCount: 3,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                  children: sharkNotifier.currentShark.atributos
                      .map(
                        (ingredient) => Card(
                          color: Colors.white,
                          child: Center(
                            child: Text(
                              ingredient,
                              style: TextStyle(color: Colors.teal, fontSize: 16),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            heroTag: 'button1',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (BuildContext context) {
                  return SharkForm(
                    isUpdating: true,
                    preenchido: true,
                  );
                }),
              );
            },
            child: Icon(FontAwesomeIcons.edit),
            foregroundColor: Colors.teal,
            backgroundColor: Colors.white
          ),
          SizedBox(height: 20),
          FloatingActionButton(
            heroTag: 'button2',
            onPressed: () => deleteShark(sharkNotifier.currentShark, _onSharkDeleted),
            child: Icon(Icons.delete),
            backgroundColor: Colors.white,
            foregroundColor: Colors.red[800],
          ),
        ],
      ),
    );
  }
}