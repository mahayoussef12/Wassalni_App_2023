//User Model
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String name;
  final String email;
  final String number;
  final String password;
  final String role;
  final bool activation;
  final double latitude;
  final double longitude;

  UserModel({
    required this.name,
    required this.email,
    required this.number,
    required this.password,
    required this.role,
    required this.activation,
    required this.latitude, required this.longitude,
  });
  Map<String, dynamic> toJson() =>
      { "name": name,"email": email, "number":number, "password": password,"role":role,"activation":activation,"latitude":latitude,"longitude":longitude};
  factory UserModel.fromSnapshot(DocumentSnapshot<Map<String,dynamic>> document){
    final data = document.data()!;
    return UserModel(
      name : data["name"],
      number : data["number"],
      password : data["password"],
      role: data['role'],
      activation: data['activation'],
      latitude: data['latitude'],
      longitude: data['longitude'],
      email : data['email'],
    );
  }
}