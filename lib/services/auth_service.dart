import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tezda_task/models/user.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<User?> get user {
    return auth.authStateChanges();
  }

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await auth.signInWithEmailAndPassword(email: email, password: password);
      return result.user;
    } on FirebaseAuthException catch (error) {
      print(error.message);
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      return await auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future<RegistrationResult> registerWithEmailAndPassword(String username, String email, String password) async {
    try {
      UserCredential result = await auth.createUserWithEmailAndPassword(email: email, password: password);
      if (result.user!.uid.isNotEmpty) {
        await firestore.collection('users').doc(result.user!.uid).set({
          'username': username,
          'email': email,
        });
      }
      return RegistrationResult(user: result.user, error: null);
    } on FirebaseAuthException catch (error) {
      print(error.toString());
      return RegistrationResult(user: null, error: error.message);
    }
  }

  Future<List<String>> fetchFavorites(String userId) async {
    if (userId.isNotEmpty) {
      QuerySnapshot snapshot = await firestore.collection('users').doc(userId).collection('favorites').get();

      return snapshot.docs.map((doc) => doc.id).toList() as List<String>;
    } else {
      return [];
    }
  }

  Future<CustomUser> loadUserData(String userId) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('users').doc(userId).get();

      if (snapshot.exists) {
        return CustomUser.fromFirestore(snapshot);
      } else {
        throw Exception('User with ID $userId not found');
      }
    } catch (e) {
      throw Exception('Error fetching user data: $e');
    }
  }
}

class RegistrationResult {
  final User? user;
  final String? error;

  RegistrationResult({this.user, this.error});
}
