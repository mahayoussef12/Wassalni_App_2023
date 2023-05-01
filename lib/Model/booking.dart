
import 'package:cloud_firestore/cloud_firestore.dart';

class booking{
  late String id;
  late String Song;
  late String age;
late DateTime dateTime;
late String gender;
late String Things ;
late String destination;
late String idDriver;
late bool acceptation;

booking({
  required this.Song,
  required this.age,
  required this.id,
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
      dateTime : data["dateTime"],
      Things: data["Things"],
      destination: data["destination"],
      idDriver: data["idDriver"], acceptation: data["acceptation"], gender: data["gender"], id: data['id'],
    Song: data["Song"], age: data["age"],);

}}
