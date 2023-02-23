//User Model
class UserModel {
  final String name;
  final String email;
  final String number;
  final String password;
  final String role;
  final bool activation ;

  UserModel({
    required this.name,
    required this.email,
    required this.number,
    required this.password,
    required this.role,
    required this.activation,
  });
  Map<String, dynamic> toJson() =>
      { "name": name,"email": email, "number":number, "password": password,"role":role,"activation":activation};

}