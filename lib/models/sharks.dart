import 'package:cloud_firestore/cloud_firestore.dart';


class Shark{
  String id;
  String especie;
  String nomeCientifico;
  String image;
  List atributos;  
  Timestamp createdAt;
  Timestamp updatedAt;

  Shark();

  Shark.fromMap(Map<String, dynamic> data){
    id = data['id'];
    especie = data['especie'];
    nomeCientifico = data['nomeCientifico'];
    image = data['image'];
    atributos = data['atributos'];    
    createdAt = data['createdAt'];
    updatedAt = data['updatedAt'];



  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'especie': especie,
      'nomeCientifico': nomeCientifico,
      'image': image,
      'atributos': atributos,
      'createdAt': createdAt,
      'updatedAt': updatedAt
    };
  }
}