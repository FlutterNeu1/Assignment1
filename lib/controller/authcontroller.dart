import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String _prefsKey = 'user_uid';

  Rx<User?> user = Rx<User?>(null);

  AuthController() {
    _loadUserFromPrefs();
    _auth.authStateChanges().listen((newUser) {
      if (newUser != null) {
        user.value = newUser;
        _saveUserToPrefs(newUser.uid);
      } else {
        user.value = null;
        _removeUserFromPrefs();
      }
    });
  }

  Future<void> _loadUserFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userUid = prefs.getString(_prefsKey);
    if (userUid != null && userUid.isNotEmpty) {
      user.value = _auth.currentUser;
    }
  }

  Future<void> _saveUserToPrefs(String uid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, uid);
  }

  Future<void> _removeUserFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefsKey);
  }

  Future<void> signUp(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      Get.offAllNamed('/home');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> logIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Get.offAllNamed('/home');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> logOut() async {
    try {
      await _auth.signOut();
      Get.offAllNamed('/login');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
}
