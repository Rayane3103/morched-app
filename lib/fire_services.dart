import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future signUpWithEmailAndPasswordForNormalUser(
    String email,
    String password,
    String fullName,
    String phoneNumber,
  ) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        await _firestore
            .collection('normal_users')
            .doc(userCredential.user!.uid)
            .set({
          'name': fullName,
          'email': email,
          'phoneNumber': phoneNumber,
        });

        return userCredential.user;
      } else {
        print('Error: User is null');
        return null;
      }
    } catch (e) {
      print('Error signing up: $e');
      return null;
    }
  }

  Future signUpWithEmailAndPasswordForMarketUser(
    String email,
    String password,
    String name,
    String position,
    String phoneNumber,
    String category,
    TimeOfDay startOfWork,
    TimeOfDay endOfWork,
    List<String> daysOfWork,
  ) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        await _firestore
            .collection('normal_users')
            .doc(userCredential.user!.uid)
            .set({
          'name': name,
          'email': email,
          'phoneNumber': phoneNumber,

          // 'image': image,
          // 'banner': banner,
          'position': position,
          'category': category,
          'daysOfWork': daysOfWork,
          'startOfWorkHour':
              '${startOfWork.hour}:${startOfWork.minute}', // Store as string
          'endOfWorkHour':
              '${endOfWork.hour}:${endOfWork.minute}', // Store as string
        });

        return userCredential.user;
      } else {
        print('Error: User is null');
        return null;
      }
    } catch (e) {
      print('Error signing up: $e');
      return null;
    }
  }

  Future<String?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return null; // Return null if sign-in is successful
    } catch (e) {
      print('Error signing in: $e');
      String errorMessage = 'Failed to login.';

      // Parse the error code and provide custom error messages
      switch ((e as FirebaseAuthException).code) {
        case 'user-not-found':
          errorMessage = 'Email not found.';
          break;
        case 'wrong-password':
          errorMessage = 'Incorrect password.';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email format.';
          break;
        default:
          errorMessage = 'An error occurred. Please try again later.';
      }

      return errorMessage; // Return custom error message
    }
  }

  Future<void> signOut() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    try {
      await FirebaseAppCheck.instance.getToken(); // Refresh the App Check token
      await auth.signOut();
      print('User successfully signed out');
    } catch (e) {
      print('Error signing out: $e');
    }
  }
}
