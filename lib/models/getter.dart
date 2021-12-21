import 'dart:io';

import 'sharks.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shark_stuff/notifier/SharkNotifier.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';


 getSharks(SharkNotifier sharkNotifier) async{
    QuerySnapshot snapshot = await Firestore.instance.collection("Sharks").getDocuments(); 
    
    List<Shark> _sharkList = [];
    

    snapshot.documents.forEach((document){
      Shark shark = Shark.fromMap(document.data);
      _sharkList.add(shark);
    });

    sharkNotifier.sharkList = _sharkList;
    }


  
uploadSharkAndImage(Shark shark, bool isUpdating, File localFile, Function sharkUploaded) async {
  if (localFile != null) {
    print("uploading image");

    var fileExtension = path.extension(localFile.path);
    print(fileExtension);

    var uuid = Uuid().v4();

    final StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('Sharks/$uuid$fileExtension');

    await firebaseStorageRef.putFile(localFile).onComplete.catchError((onError) {
      print(onError);
      return false;
    });

    String url = await firebaseStorageRef.getDownloadURL();
    print("download url: $url");
    _uploadShark(shark, isUpdating, sharkUploaded, imageUrl: url);
  } else {
    print('...skipping image upload');
    _uploadShark(shark, isUpdating, sharkUploaded);
  }
}

_uploadShark(Shark shark, bool isUpdating, Function sharkUploaded, {String imageUrl}) async {
  CollectionReference sharkRef = Firestore.instance.collection('Sharks');

  if (imageUrl != null) {
    shark.image = imageUrl;
  }

  if (isUpdating) {
    shark.updatedAt = Timestamp.now();

    await sharkRef.document(shark.id).updateData(shark.toMap());

    sharkUploaded(shark);
    print('updated shark with id: ${shark.id}');
  } else {
    shark.createdAt = Timestamp.now();

    DocumentReference documentRef = await sharkRef.add(shark.toMap());

    shark.id = documentRef.documentID;

    print('uploaded shark successfully: ${shark.toString()}');

    await documentRef.setData(shark.toMap(), merge: true);

    sharkUploaded(shark);
  }
}

deleteShark(Shark shark, Function sharkDeleted) async {
  if (shark.image != null) {
    StorageReference storageReference =
        await FirebaseStorage.instance.getReferenceFromUrl(shark.image);

    print(storageReference.path);

    await storageReference.delete();

    print('image deleted');
  }

  await Firestore.instance.collection('Sharks').document(shark.id).delete();
  sharkDeleted(shark);
  }