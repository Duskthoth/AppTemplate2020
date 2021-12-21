import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shark_stuff/Service/auth.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:shark_stuff/models/Info_card.dart';

var customColor = Color.fromRGBO(48, 134, 161, 0.9);
var blueGrey = Colors.blueGrey[800];

class ProfileScreen extends StatefulWidget {
  ProfileScreen();
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _auth = AuthService();

  FirebaseUser currentUser;
  String nome;
  String email;
  File _image;
  String _uploadedFileURL;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  String _getEmail() {
    if (currentUser.email != null) {
      setState(() {
        this.email = currentUser.email;
      });
    } else {
      setState(() {
        this.email = 'Sem E-mail';
      });
    }
  }

  String _getUsername() {
    if (currentUser.email != null) {
      List<String> aux;
      this.nome = currentUser.email;
      aux = this.nome.split('@');
      this.nome = aux[0];
      this.nome =
          this.nome.replaceFirst(this.nome[0], this.nome[0].toUpperCase());
    } else {
      setState(() {
        this.nome = 'Anônimo';
      });
    }
  }

  void _loadCurrentUser() {
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      setState(() {
        // call setState to rebuild the view
        this.currentUser = user;
        _getEmail();
        _getUsername();
        // var userUpdateInfo = UserUpdateInfo();
        // userUpdateInfo.displayName = null;

        // currentUser.updateProfile(userUpdateInfo);
      });
    });
  }

  Future chooseFile() async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
      setState(() {
        _image = image;
      });
    });
  }

  Future getImage(context) async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = image;
      print('Image Path $_image');
    });

    uploadPic(context);
  }

  Future uploadPic(BuildContext context) async {
    String fileName = currentUser.email;
    print(fileName);
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('ProfilePicture/$fileName');
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    setState(() {
      print("Profile Picture uploaded");
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('Profile Picture Uploaded')));
    });
  }

  @override
  Widget build(BuildContext context) {
    // _getEmail();
    // _getUsername();
    String _url;
    _getProfilePicture() async {
      String user = currentUser.email;
      try {
        if (FirebaseStorage.instance.ref().child('ProfilePicture/$user') ==
            null) {
          // _url = "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQ4NlejSq0Mh1D7xtBnqqvtTwbNQJ0dqdkwJv4bqmCZ0n23Ibqz&usqp=CAU";
        } else {
          _url = await FirebaseStorage.instance
              .ref()
              .child('ProfilePicture/$user')
              .getDownloadURL();
        }
      } catch (e) {
        print(e.toString());
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
        backgroundColor: blueGrey,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 20,
                width: 200,
              ),
              CircleAvatar(
                radius: 50,
                child: ClipOval(
                  child: new SizedBox(
                    width: 180.0,
                    height: 180.0,
                    child: FutureBuilder(
                      future: _getProfilePicture(),
                      builder: (BuildContext context, Widget) {
                        if (_url != null) {
                          return Image.network(
                            _url,
                            fit: BoxFit.fill,
                          );
                        } else {
                          if (_image == null) {
                            return Image.network(
                              "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQ4NlejSq0Mh1D7xtBnqqvtTwbNQJ0dqdkwJv4bqmCZ0n23Ibqz&usqp=CAU",
                              fit: BoxFit.fill,
                            );
                          }
                        }
                      },
                    ),
                  ),
                ),
              ),
              Text(
                this.nome,
                style: TextStyle(
                  fontSize: 40.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Pacifico',
                ),
              ),
              SizedBox(
                height: 20,
                width: 200,
                child: Divider(
                  color: blueGrey,
                ),
              ),
              InfoCard(
                text: 'Mudar Avatar',
                icon: FontAwesomeIcons.user,
                onPressed: () async {
                  getImage(context);
                },
              ),
              InfoCard(
                text: this.email,
                icon: FontAwesomeIcons.envelope,
                onPressed: () async {},
              ),
              InfoCard(
                text: 'Mudar senha',
                icon: FontAwesomeIcons.keycdn,
                onPressed: () {
                  _auth.resetPassword(this.email);
                },
              ),
              InfoCard(
                text: 'Logout',
                icon: FontAwesomeIcons.signOutAlt,
                onPressed: () {
                  _auth.signOut();
                },
              )
            ],
          ),
        ),
      ),
      backgroundColor: customColor,
    );
  }
}
