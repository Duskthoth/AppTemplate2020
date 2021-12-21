import 'package:flutter/material.dart';
import 'package:shark_stuff/Service/auth.dart';
import 'package:shark_stuff/shared/loading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  //text field state
  String email = '';
  String password = '';

  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
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
                FlutterLogo(size: 100),
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
                              decoration:
                                  new InputDecoration(labelText: "E-mail"),
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
                            new Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new MaterialButton(
                                  height: 30.0,
                                  minWidth: 80.0,
                                  color: Colors.blueGrey,
                                  textColor: Colors.white,
                                  child: Row(
                                    children: <Widget>[
                                      Icon(FontAwesomeIcons.signInAlt),
                                      Padding(
                                          padding: const EdgeInsets.only(
                                              right: 5.0)),
                                      Text("Login"),
                                    ],
                                  ),
                                  onPressed: () async {
                                    if (_formKey.currentState.validate()) {
                                      setState(() => loading = true);
                                      dynamic result = await _auth
                                          .signInWithEmailAndPassword(
                                              email, password);
                                      if (result == null) {
                                        setState(() {
                                          error = 'Nao foi possivel realizar o login';
                                          loading = false;
                                          });
                                      }
                                    }
                                  },
                                  splashColor: Colors.lightBlueAccent,
                                ),
                                Padding(padding: const EdgeInsets.all(5.0)),
                                new MaterialButton(
                                  height: 30.0,
                                  minWidth: 80.0,
                                  color: Colors.blueGrey,
                                  textColor: Colors.white,
                                  splashColor: Colors.greenAccent,
                                  child: Row(
                                    children: <Widget>[
                                      Icon(FontAwesomeIcons.userPlus),
                                      Padding(
                                          padding: const EdgeInsets.only(
                                              right: 10.0)),
                                      Text("Sign up"),
                                    ],
                                  ),
                                  onPressed: () {
                                    widget.toggleView();
                                  },
                                ),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new MaterialButton(
                                  height: 30.0,
                                  minWidth: 220.0,
                                  color: Colors.blueGrey,
                                  textColor: Colors.white,
                                  splashColor: Colors.greenAccent,
                                  child: Row(children:<Widget>[Icon(FontAwesomeIcons.keycdn),Padding(
                                          padding: const EdgeInsets.only(
                                              right: 5.0)),Text("Recuperar senha")], ),
                                  onPressed: () async {
                                    dynamic result = await _auth.resetPassword(email);
                                    if (result == null) {
                                      setState(() => error = 'E-mail enviado com sucesso');
                                    } else {
                                      setState(() => error = 'Não foi possivel mandar o e-mail');
                                      print(result);
                                    }

                                  },
                                ),
                                //Padding(padding: const EdgeInsets.all(5.0)),
                                
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[new MaterialButton(
                                  height: 30.0,
                                  minWidth: 220.0,
                                  color: Colors.blueGrey,
                                  textColor: Colors.white,
                                  splashColor: Colors.greenAccent,
                                  child: Row(children:<Widget>[Icon(FontAwesomeIcons.userSecret),Padding(padding: const EdgeInsets.only(right:5.0)),Text("Convidado")],),
                                  onPressed: () async {
                                    dynamic result = await _auth.signInAnon();
                                    if (result == null) {
                                      print("error signing in");
                                    } else {
                                      print("sign in");
                                      print(result.uid);
                                    }
                                  },
                                ),],
                            ),
                            Text(
                              error,
                              style:
                                  TextStyle(color: Colors.red, fontSize: 14.0),
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
