
import 'package:cloud_firestore/cloud_firestore.dart';

class booking{
  late String id;
  late String idUser;
  late String Song;
  late String age;
late Timestamp dateTime;
late String gender;
late String Things ;
late String destination;
late String idDriver;
late bool acceptation;

booking({
  required this.id,
  required this.Song,
  required this.age,
  required this.idUser,
  required this.dateTime,
  required this.Things,
  required this.destination,
  required this.idDriver,
  required this.acceptation,
  required this.gender,
});
factory booking.fromSnapshot(DocumentSnapshot<Map<String,dynamic>> document){
  final data = document.data()!;
  return booking(
    id:document.id,
      dateTime : data["dateTime"],
      Things: data["Things"],
      destination: data["destination"],
      idDriver: data["idDriver"], acceptation: data["acceptation"], gender: data["gender"], idUser: data['idUser'],
    Song: data["Song"], age: data["age"],);

}
  booking.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    dateTime=json['dateTime'] ?? '';
    Things=json['Things'] ?? '';
    destination=json['destination'] ?? '';
    idDriver=json['idDriver'] ?? '';
    acceptation=json['acceptation'] ?? '';
    gender=json['gender'] ?? '';
    idUser=json['idUser'] ?? '';
    age=json['age'] ?? '';
    Song=json['song'] ?? '';




  }
}
