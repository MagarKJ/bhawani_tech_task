// this is the model class for the user data that is fetched from the firestore and used throughout the app
class UserModel {
  final String uid;
  final String email;
  final String name;
  final String role; // role of the user (admin, manager, employee.)

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.role,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'role': role,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      name: map['name'],
      role: map['role'],
    );
  }
}
