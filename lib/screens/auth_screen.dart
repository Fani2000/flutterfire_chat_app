import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/auth/auth_form.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;

  void _submitAuthForm(String email, String password, String username,
      bool isLogin, BuildContext ctx) async {
    try {
      setState(() {
        _isLoading = true;
      });
      UserCredential? authCredential;
      if (isLogin) {
        authCredential = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        authCredential = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(authCredential.user!.uid)
          .set(
        {
          'username': username,
          'email': email,
        },
      );
    } on FirebaseAuthException catch (e) {
      String? message = "An error occured, please check your credintials!";

      if (e.message != null) {
        message = e.message;
      }

      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message!),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(submitFN: _submitAuthForm, isLoading: _isLoading),
    );
  }
}
