import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';

class AuthController {
  User? get currentUser => _firebaseAuth.currentUser;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  String? usernameError;
  String? passwordError;
  String? emailError;
  String? confirmPasswordError;
  String? currentPasswordError;
  String? newPasswordError;
  final TextEditingController username = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();
  final TextEditingController currentPassword = TextEditingController();
  final TextEditingController newPassword = TextEditingController();

  bool isManager = false;

  Future<void> signUp(
      {required Function(String?) onUsernameError,
      required Function(String?) onEmailError,
      required Function(String?) onPasswordError,
      required Function(String?) onConfirmPasswordError,
      required Function() onSuccess,
      required BuildContext context}) async {
    emailError = null;
    confirmPasswordError = null;
    passwordError = null;
    usernameError = null;
    if (username.text.isEmpty) {
      onUsernameError(Locales.string(context, 'signup_error1'));
      return;
    }
    if (email.text.isEmpty) {
      onEmailError(Locales.string(context, 'signup_error2'));
      return;
    }
    if (password.text.isEmpty) {
      onPasswordError(Locales.string(context, 'signup_error3'));
      return;
    }
    if (confirmPassword.text.isEmpty) {
      onConfirmPasswordError(Locales.string(context, 'signup_error4'));
      return;
    }
    if (password.text != confirmPassword.text) {
      onConfirmPasswordError(Locales.string(context, 'signup_error5'));
      return;
    }
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: email.text, password: password.text)
          .then((value) {
        FirebaseFirestore.instance
            .collection('Users')
            .doc(value.user?.uid)
            .set({
          'username': username.text,
          'email': email.text,
        });
        onSuccess();
      });
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'weak-password':
          onPasswordError(Locales.string(context, 'signup_error6'));
          break;
        case 'email-is-already-in-use':
          onEmailError(Locales.string(context, 'signup_error7'));
          break;
        case 'invalid-email':
          onEmailError(Locales.string(context, 'signup_error8'));
          break;
      }
    }
  }

  Future<void> logIn(
      {required Function(String?) onEmailError,
      required Function(String?) onPasswordError,
      required Function() onSuccess,
      required BuildContext context}) async {
    emailError = null;
    passwordError = null;

    if (email.text.isEmpty) {
      onEmailError(Locales.string(context, 'signup_error2'));

      return;
    }
    if (password.text.isEmpty) {
      onPasswordError(Locales.string(context, 'signup_error3'));

      return;
    }
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.text, password: password.text);
      onSuccess();
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          onEmailError(Locales.string(context, 'signup_error8'));
          break;
        case 'wrong-password':
          onPasswordError(Locales.string(context, 'login_error4'));
          break;
        case 'user-not-found':
          onEmailError(Locales.string(context, 'login_error5'));
          break;
        case 'user-disabled':
          onEmailError(Locales.string(context, 'login_error6'));
          break;
        default:
          onPasswordError(Locales.string(context, 'login_error7'));
          break;
      }
    }
  }

  Future<void> changePassword(
      {required Function(String?) onCurrentPasswordError,
      required Function(String?) onConfirmPasswordError,
      required Function(String?) onNewPasswordError,
      required Function() onSuccess,
      required BuildContext context}) async {
    confirmPasswordError = null;
    currentPasswordError = null;
    newPasswordError = null;

    User user = FirebaseAuth.instance.currentUser!;

    if (currentPassword.text.isEmpty) {
      onCurrentPasswordError(Locales.string(context, 'change_password_error1'));
      return;
    }
    if (newPassword.text.isEmpty) {
      onNewPasswordError(Locales.string(context, 'change_password_error2'));
      return;
    }
    if (newPassword.text == currentPassword.text) {
      onNewPasswordError(Locales.string(context, 'change_password_error3'));
      return;
    }
    if (confirmPassword.text.isEmpty) {
      onConfirmPasswordError(Locales.string(context, 'change_password_error4'));
      return;
    }
    if (newPassword.text.length < 6) {
      onNewPasswordError(Locales.string(context, 'signup_error6'));
      return;
    }
    if (newPassword.text != confirmPassword.text) {
      onConfirmPasswordError(Locales.string(context, 'signup_error5'));
      return;
    }

    try {
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword.text,
      );
      await user.reauthenticateWithCredential(credential).then((value) {
        user.updatePassword(newPassword.text).then((value) {
          onSuccess();
        });
      });
    } on FirebaseAuthException {
      onCurrentPasswordError(Locales.string(context, 'login_error4'));
    }
  }

  Future<void> forgotPassword(
      {required Function(String?) onEmailError,
      required Function() onSuccess,
      required BuildContext context}) async {
    if (email.text.isEmpty) {
      onEmailError(Locales.string(context, 'signup_error2'));
      return;
    }
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: email.text.trim())
          .then((value) {
        onSuccess();
      });
    } on FirebaseAuthException catch (e) {
      onEmailError(e.message.toString());
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<void> checkIsManager({required String id}) async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('Managers').doc(id).get();
      if (querySnapshot.exists) {
        isManager = true;
      } else {
        isManager = false;
      }
    } catch (error) {
      print("Error checking manager: $error");
    }
  }
}
