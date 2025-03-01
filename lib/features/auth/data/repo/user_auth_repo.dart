import 'dart:developer';

import 'package:bhawani_tech_task/features/auth/data/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';



// UserAuthRepo class to handle user authentication related operations like register, login, logout
class UserAuthRepo {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // Function to register a new user with email, password, name and role
  Future<UserModel> register({
    required String email,
    required String password,
    required String name,
    required String role,
  }) async {
    try {
      // Create user in Firebase Auth
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

// create user model

      UserModel userModel = UserModel(
        uid: userCredential.user!.uid,
        email: email,
        role: role,
        name: name,
      );
      // log(userModel.toMap().toString());

      // Save user in Firestore
      await _firestore.collection('users').doc(userModel.uid).set(
            userModel.toMap(),
          );
      // log('User added to databse');
      return userModel;
    } catch (e) {
      // log(e.toString());
      throw Exception('Failed to register');
    }
  }

  // Function to login a user with email and password and return the user data

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // get user data from firestore
      DocumentSnapshot documentSnapshot = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      UserModel userModel =
          UserModel.fromMap(documentSnapshot.data() as Map<String, dynamic>);
      return userModel;
    } catch (e) {
      // log(e.toString());
      throw Exception('Failed to login');
    }
  }

  // Function to logout the user

  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      // log(e.toString());
      throw Exception('Failed to logout');
    }
    // Call API to logout
  }
}
