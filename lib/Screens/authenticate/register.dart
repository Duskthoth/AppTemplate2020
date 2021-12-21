import 'package:flutter/material.dart';
import 'package:shark_stuff/Service/auth.dart';
import 'package:shark_stuff/shared/loading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  String email = '';
  String confEmail = '';
  String password = '';
  String confirmPassword = '';
  String username = '';

  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : new Scaffold(
            backgroundColor: Colors.black54,
            body: new Stack(
              fit: StackFit.expand,
              children: <Widget>[
                new Image(
                  image: new AssetImage("assets/shark2.jpg"),
                  fit: BoxFit.cover,
                  color: Colors.black54,
                  colorBlendMode: BlendMode.darken,
                ),
                SingleChildScrollView(
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(padding: const EdgeInsets.only(top: 70)),
                      new Form(
                        child: new Theme(
                          data: new ThemeData(
                              brightness: Brightness.dark,
                              primarySwatch: Colors.blueGrey,
                              inputDecorationTheme: new InputDecorationTheme(
                                  labelStyle: new TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 20.0,
                              ))),
                          child: new Container(
                            padding: const EdgeInsets.all(40.0),
                            child: Form(
                              key: _formKey,
                              child: new Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  new TextFormField(
                                    validator: (val) =>
                                        val.isEmpty ? 'Enter an email' : null,
                                    onChanged: (val) {
                                      setState(() => email = val);
                                    },
                                    decoration: new InputDecoration(
                                        labelText: "E-mail"),
                                    keyboardType: TextInputType.emailAddress,
                                  ),
                                  new TextFormField(
                                    validator: (val) => val == email
                                        ? null
                                        : 'Emails não são iguais',
                                    onChanged: (val) {
                                      setState(() => confEmail = val);
                                    },
                                    decoration: new InputDecoration(
                                        labelText: "Confirmar E-mail"),
                                    keyboardType: TextInputType.emailAddress,
                                  ),
                                  new TextFormField(
                                    validator: (val) => val.length < 6
                                        ? 'Enter a password 6 plus chars long'
                                        : null,
                                    onChanged: (val) {
                                      setState(() => password = val);
                                    },
                                    decoration:
                                        new InputDecoration(labelText: "Senha"),
                                    keyboardType: TextInputType.text,
                                    obscureText: true,
                                  ),
                                  new TextFormField(
                                    validator: (val) => val == password
                                        ? null
                                        : 'Senhas nao conferem',
                                    onChanged: (val) {
                                      setState(() => confirmPassword = val);
                                    },
                                    decoration: new InputDecoration(
                                        labelText: "Confirmar Senha"),
                                    keyboardType: TextInputType.text,
                                    obscureText: true,
                                  ),
                                  /*  new TextFormField(
                              validator: (val) => val.isNotEmpty
                                  ? null
                                  : 'Nome de usuario faltando',
                              onChanged: (val) {
                                setState(() => username = val);
                              },
                              decoration:
                                  new InputDecoration(labelText: "Usuario"),
                              keyboardType: TextInputType.text,
                            ),
                            */
                                  new Padding(
                                    padding: const EdgeInsets.only(top: 20.0),
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      new FlatButton.icon(
                                        //height: 30.0,
                                        //minWidth: 80.0,
                                        icon: Icon(FontAwesomeIcons.undo),
                                        label: Text("Voltar"),
                                        color: Colors.blueGrey,
                                        textColor: Colors.white,
                                        //child: new Icon(Icons.navigate_before),
                                        onPressed: () {
                                          widget.toggleView();
                                        },
                                        splashColor: Colors.redAccent,
                                      ),
                                      Padding(
                                          padding: const EdgeInsets.all(5.0)),
                                      new FlatButton.icon(
                                        //height: 30.0,
                                        //minWidth: 80.0,
                                        icon:
                                            Icon(FontAwesomeIcons.checkSquare),
                                        label: Text("Confirmar"),
                                        color: Colors.blueGrey,
                                        textColor: Colors.white,
                                        splashColor: Colors.greenAccent,
                                        //child: Icon(Icons.check),
                                        onPressed: () async {
                                          if (_formKey.currentState
                                              .validate()) {
                                            setState(() => loading = true);
                                            dynamic result = await _auth
                                                .registerWithEmailAndPassword(
                                                    email, password, username);
                                            if (result == null) {
                                              setState(() {
                                                error =
                                                    'Por favor digite um e-mail valido';
                                                loading = false;
                                              });
                                            }
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                  Text(
                                    error,
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 14.0),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
  }
}
