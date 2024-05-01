import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  Future signUpWithEmailAndPasswordForMarketUser(String email, String password,
      String name, String position, String phoneNumber, String category) async {
    // List<String> daysOfWork,
    // TimeOfDay startOfWork,
    // TimeOfDay endOfWork,
    // List<String> arrayOfImages,
    // List<String> arrayOfComments
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
          // 'daysOfWork': daysOfWork,
          // 'startOfWorkHour':
          //     '${startOfWork.hour}:${startOfWork.minute}', // Store as string
          // 'endOfWorkHour':
          //     '${endOfWork.hour}:${endOfWork.minute}', // Store as string
          // 'arrayOfImages': arrayOfImages,
          // 'arrayOfComments': arrayOfComments,
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

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print('Error signing in: $e');
      return null;
    }
  }

  Future signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Error signing out: $e');
    }
  }
}
