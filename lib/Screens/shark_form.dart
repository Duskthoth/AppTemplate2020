import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shark_stuff/Screens/profile.dart';
import 'package:shark_stuff/models/getter.dart';
import 'package:shark_stuff/models/sharks.dart';
import 'package:shark_stuff/notifier/SharkNotifier.dart';
import 'home/home.dart';

class SharkForm extends StatefulWidget {
  final bool isUpdating;
  final bool preenchido;

  SharkForm({@required this.isUpdating, @required this.preenchido});

  @override
  _SharkFormState createState() => _SharkFormState();
}

class _SharkFormState extends State<SharkForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List _atributos = [];
  Shark _currentShark;
  String _imageUrl;
  File _imageFile;
  TextEditingController atributosController = new TextEditingController();
  var white = Colors.white;

  @override
  void initState() {
    super.initState();
    SharkNotifier sharkNotifier =
        Provider.of<SharkNotifier>(context, listen: false);

    if (sharkNotifier.currentShark != null && widget.preenchido) {
      _currentShark = sharkNotifier.currentShark;
      _atributos.addAll(_currentShark.atributos);
      _imageUrl = _currentShark.image;
    } else {
      _currentShark = new Shark();
    }

    //
  }

  _showImage() {
    if (_imageFile == null && _imageUrl == null) {
      return Text(
        "image placeholder",
        style: TextStyle(color: white),
      );
    } else if (_imageFile != null) {
      print('showing image from local file');

      return Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          Image.file(
            _imageFile,
            fit: BoxFit.cover,
            height: 250,
          ),
          FlatButton(
            padding: EdgeInsets.all(16),
            color: Colors.black54,
            child: Text(
              'Mudar Imagem',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w400),
            ),
            onPressed: () => _getLocalImage(),
          )
        ],
      );
    } else if (_imageUrl != null) {
      print('showing image from url');

      return Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          Image.network(
            _imageUrl,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
            height: 250,
          ),
          FlatButton(
            padding: EdgeInsets.all(16),
            color: Colors.black54,
            child: Text(
              'Change Image',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w400),
            ),
            onPressed: () => _getLocalImage(),
          )
        ],
      );
    }
  }

  _getLocalImage() async {
    File imageFile = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50,// maxWidth: 400
        );

    if (imageFile != null) {
      setState(() {
        _imageFile = imageFile;
      });
    }
  }

  Widget _buildEspecieField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Espécie',
        labelStyle: TextStyle(
          color: white,
        ),
        counterStyle: TextStyle(color: white),
        errorStyle: TextStyle(color: Colors.red[800]),
      ),
      initialValue: _currentShark.especie,
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 20, color: white),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Nome é necessário';
        }

        if (value.length < 3 || value.length > 20) {
          return 'Name must be more than 3 and less than 20';
        }

        return null;
      },
      onSaved: (String value) {
        _currentShark.especie = value;
      },
    );
  }

  Widget _buildNomeCientificoField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Nome Científico',
        labelStyle: TextStyle(
          color: white,
        ),
        counterStyle: TextStyle(color: white),
        errorStyle: TextStyle(color: Colors.red[800]),
      ),
      initialValue: _currentShark.nomeCientifico,
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 20, color: white),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Nome is required';
        }

        if (value.length < 3 || value.length > 20) {
          return 'Category must be more than 3 and less than 20';
        }

        return null;
      },
      onSaved: (String value) {
        _currentShark.nomeCientifico = value;
      },
    );
  }

  _buildAtributoField() {
    return SizedBox(
      width: 190,
      child: TextField(
        controller: atributosController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          labelText: 'Atributo',
          labelStyle: TextStyle(
            color: white,
          ),
          counterStyle: TextStyle(color: white),
          errorStyle: TextStyle(color: Colors.red[800]),
        ),
        style: TextStyle(fontSize: 20),
      ),
    );
  }

  _onSharkUploaded(Shark shark) {
    SharkNotifier sharkNotifier =
        Provider.of<SharkNotifier>(context, listen: false);
    sharkNotifier.addShark(shark);
    _mudancaPagina(context);

    //Navigator.pop(context);
  }

  _alertaFinal(context) async {
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
         AlertDialog alert = AlertDialog(
            title: Text('Exito'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                    widget.isUpdating
                        ? "Cadastro editado com sucesso"
                        : "Cadastro efetuado com sucesso",
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
          return alert;
          
        });
  }

  _addAtributos(String text) {
    if (text.isNotEmpty) {
      setState(() {
        _atributos.add(text);
      });
      atributosController.clear();
    }
  }

  _saveShark() {
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();

    print('form saved');

    _currentShark.atributos = _atributos;

    uploadSharkAndImage(
        _currentShark, widget.isUpdating, _imageFile, _onSharkUploaded);

    print("Especie: ${_currentShark.especie}");
    print("Nome Cientifico: ${_currentShark.nomeCientifico}");
    print("atributos: ${_currentShark.atributos.toString()}");
    print("_imageFile ${_imageFile.toString()}");
    print("_imageUrl $_imageUrl");
  }

  _mudancaPagina(context) async =>
      widget.isUpdating ? Navigator.of(context).pop() : print('success');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          widget.isUpdating ? "Editar" : "Criar",
          textAlign: TextAlign.center,
          style: TextStyle(color: white),
        ),
        centerTitle: true,
        backgroundColor: blueGrey,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(32),
        child: Form(
          key: _formKey,
          autovalidate: true,
          child: Column(children: <Widget>[
            _showImage(),
            SizedBox(height: 16),
            SizedBox(height: 16),
            _imageFile == null && _imageUrl == null
                ? ButtonTheme(
                    child: RaisedButton(
                      color: white,
                      onPressed: () => _getLocalImage(),
                      child: Text(
                        'Add Image',
                        style: TextStyle(color: Colors.teal),
                      ),
                    ),
                  )
                : SizedBox(height: 0),
            _buildEspecieField(),
            _buildNomeCientificoField(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _buildAtributoField(),
                ButtonTheme(
                   minWidth: 20,
                  child: RaisedButton(
                    color: white,                    
                    child:Icon(FontAwesomeIcons.plus,color: Colors.teal,), 
                    //Text('Add', style: TextStyle(color: Colors.teal)),
                    onPressed: () => _addAtributos(atributosController.text),
                  ),
                )
              ],
            ),
            SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              padding: EdgeInsets.all(8),
              crossAxisCount: 3,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
              children: _atributos
                  .map(
                    (ingredient) => Card(
                      color: Colors.white,
                      child: Center(
                        child: Text(
                          ingredient,
                          style: TextStyle(color: Colors.teal, fontSize: 14),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            )
          ]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: white,
        onPressed: () {
          //FocusScope.of(context).requestFocus(new FocusNode());
          _saveShark();
          _alertaFinal(context);

         
        },
        child: Icon(FontAwesomeIcons.save),
        foregroundColor: Colors.teal,
      ),
      backgroundColor: customColor,
    );
  }
}
