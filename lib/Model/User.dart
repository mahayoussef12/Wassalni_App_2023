//User Model
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  late String name;
  late String email;
  late String number;
  late String password;
  late String role;
  late bool activation;
  late double latitude;
  late double longitude;
  late String image;
  late String pushToken;
  late String id;
  late bool isOnline;
  late String lastActive;


  UserModel({
    required this.name,
    required this.email,
    required this.number,
    required this.password,
    required this.role,
    required this.activation,
    required this.latitude, required this.longitude,
    required this.image,  required this.id,
    required this.pushToken,required this.isOnline,required this.lastActive,
  });
  UserModel.fromJson(Map<String, dynamic> json) {
    id=json['id'] ?? '';
    name=json['name'] ?? '';
    number=json['number'] ?? '';
    password=json['password'] ?? '';
    role=json['role'] ?? '';
    activation=json['activation'] ?? '';
    latitude=json['latitude'] ?? '';
    longitude=json['longitude'] ?? '';
    image = json['image'] ?? '';
    name = json['name'] ?? '';
    id = json['id'] ?? '';
    email = json['email'] ?? '';
    pushToken = json['pushToken'] ?? '';
    isOnline = json['isOnline'] ?? '';
    lastActive=json['lastActive'] ?? '';
  }
  Map<String, dynamic> toJson() =>
      { "name": name,"email": email, "number":number, "password": password,"role":role,"activation":activation,"latitude":latitude,"longitude":longitude,"id":id,"image":image,"pushToken":pushToken,"isOnline":isOnline,"lastActive":lastActive};

  factory UserModel.fromSnapshot(DocumentSnapshot<Map<String,dynamic>> document){
    final data = document.data()!;
    return UserModel(
      id : document.id,
      name : data["name"],
      number : data["number"],
      password : data["password"],
      role: data['role'],
      activation: data['activation'],
      latitude: data['latitude'],
      longitude: data['longitude'],
      image : data['image'],
      email : data['email'],
      pushToken : data['pushToken'],
      isOnline : data['isOnline'],
      lastActive: data['lastActive'],
    );
  }
}