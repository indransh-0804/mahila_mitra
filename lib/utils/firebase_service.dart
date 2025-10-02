import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseServices {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Sign In
  static Future<User?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return cred.user;
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(code: e.code, message: e.message);
    } catch (e) {
      throw Exception("SignIn Error: $e");
    }
  }

  /// Sign Up
  static Future<User?> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      await _db.collection("users").doc(cred.user!.uid).set({
        "email": email.trim(),
        "createdAt": FieldValue.serverTimestamp(),
      });

      return cred.user;
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(code: e.code, message: e.message);
    } catch (e) {
      throw Exception("SignUp Error: $e");
    }
  }

  /// Save General Info
  static Future<void> saveUserInfo({
    required String firstName,
    required String lastName,
    DateTime? dob,
    String? gender,
  }) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception("No authenticated user found");

    final userData = {
      "firstName": firstName.trim(),
      "lastName": lastName.trim(),
      "gender": gender ?? "",
      "dob": dob?.toIso8601String(),
      "updatedAt": FieldValue.serverTimestamp(),
    };

    await _db.collection("users").doc(uid).set(userData, SetOptions(merge: true));
  }

  /// Save Medical Info
  static Future<void> saveMedInfo({
    required String personalContact,
    required String emergencyContact,
    String? areaCode,
    String? bloodGroup,
  }) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception("No authenticated user found");
    final medData = {
      "personalContact": personalContact.trim(),
      "emergencyContact": emergencyContact.trim(),
      "areaCode": areaCode ?? "",
      "bloodGroup": bloodGroup ?? "",
      "updatedAt": FieldValue.serverTimestamp(),
    };
    await _db.collection("users").doc(uid).set(medData, SetOptions(merge: true));
  }

  /// Fetch data
  static Future<Map<String, dynamic>?> getUserData() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception("No authenticated user found");

    final doc = await _db.collection('users').doc(uid).get();
    if (!doc.exists) return null;

    return doc.data();
  }

  /// Sign Out
  static Future<void> signOut() async {
    await _auth.signOut();
  }

  // Delete User
  static Future<void> deleteUser() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("No authenticated user found");
    await _db.collection("users").doc(user.uid).delete();
    await user.delete();
  }

}
