import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

  Future<void> signUp({
    required Function(String?) onUsernameError,
    required Function(String?) onEmailError,
    required Function(String?) onPasswordError,
    required Function(String?) onConfirmPasswordError,
    required Function() onSuccess,
  }) async {
    emailError = null;
    confirmPasswordError = null;
    passwordError = null;
    usernameError = null;
    if (username.text.isEmpty) {
      onUsernameError("Please enter your Username!");
      return;
    }
    if (email.text.isEmpty) {
      onEmailError("Please enter your Email Address!");
      return;
    }
    if (password.text.isEmpty) {
      onPasswordError("Please enter your Password!");
      return;
    }
    if (confirmPassword.text.isEmpty) {
      onConfirmPasswordError("Please enter your Password again!");
      return;
    }
    if (password.text != confirmPassword.text) {
      onConfirmPasswordError("The passwords you entered do not match!");
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
          onPasswordError('Password should be at least 6 characters');
          break;
        case 'email-is-already-in-use':
          onEmailError('The Email has already been registered!');
          break;
        case 'invalid-email':
          onEmailError('Your Email Address is invalid!');
          break;
      }
    }
  }

  Future<void> logIn({
    required Function(String?) onEmailError,
    required Function(String?) onPasswordError,
    required Function() onSuccess,
  }) async {
    emailError = null;
    passwordError = null;

    if (email.text.isEmpty) {
      onEmailError("Please enter your Email Address!");

      return;
    }
    if (password.text.isEmpty) {
      onPasswordError("Please enter your Password!");

      return;
    }
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.text, password: password.text);
      onSuccess();
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          onEmailError('Your Email Address is invalid!');
          break;
        case 'wrong-password':
          onPasswordError('Your password is invalid, please try again!');
          break;
        case 'user-not-found':
          onEmailError('No user corresponding to the given email!');
          break;
        case 'user-disabled':
          onEmailError(
              'The user corresponding to the given email has been disabled!');
          break;
        default:
          onPasswordError('The mail or password you entered is wrong!');
          break;
      }
    }
  }

  Future<void> changePassword({
    required Function(String?) onCurrentPasswordError,
    required Function(String?) onConfirmPasswordError,
    required Function(String?) onNewPasswordError,
    required Function() onSuccess,
  }) async {
    confirmPasswordError = null;
    currentPasswordError = null;
    newPasswordError = null;

    User user = FirebaseAuth.instance.currentUser!;

    if (currentPassword.text.isEmpty) {
      onCurrentPasswordError("Please enter your current password!");
      return;
    }
    if (newPassword.text.isEmpty) {
      onNewPasswordError("Please enter your new password!");
      return;
    }
    if (newPassword.text == currentPassword.text) {
      onNewPasswordError("You are already use this password!");
      return;
    }
    if (confirmPassword.text.isEmpty) {
      onConfirmPasswordError("Please enter your new password again!");
      return;
    }
    if (newPassword.text.length < 6) {
      onNewPasswordError("Password must be at least 6 characters!");
      return;
    }
    if (newPassword.text != confirmPassword.text) {
      onConfirmPasswordError("The passwords you entered do not match!");
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
      onCurrentPasswordError('Your password is invalid, please try again!');
    }
  }

  Future<void> forgotPassword({
    required Function(String?) onEmailError,
    required Function() onSuccess,
  }) async {
    if (email.text.isEmpty) {
      onEmailError("Please enter your Email Address!");
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
}
