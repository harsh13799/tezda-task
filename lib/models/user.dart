import 'package:cloud_firestore/cloud_firestore.dart';

class CustomUser {
  final String uid;
  final String email;
  final String name;
  final String? userName;

  CustomUser({required this.uid, required this.email, required this.name, this.userName});

  factory CustomUser.fromJson(Map<String, dynamic> json) {
    return CustomUser(
      uid: json['uid'],
      email: json['email'],
      name: json['name'],
      userName: json['userName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'userName': userName,
    };
  }

  factory CustomUser.fromFirestore(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;
    return CustomUser(
      uid: snapshot.id,
      email: data['email'] ?? '',
      name: data['username'] ?? '',
    );
  }
}
