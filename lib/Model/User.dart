//User Model
class UserModel {


  final String name;
  final String email;
  final String number;
  final String password;
  final String role;

  UserModel( {
    required this.name,
    required this.email,
    required this.number,
    required this.password,
     required this.role,});
  Map<String, dynamic> toJson() =>
      { "name": name,"email": email, "number":number, "password": password,"role":role};

}