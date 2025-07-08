import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list_app/constants.dart';
import 'package:to_do_list_app/models/app_user.dart';
import 'package:to_do_list_app/routes/routes.dart';
import 'package:to_do_list_app/services/auth.dart';
import 'package:to_do_list_app/services/user_services.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final Constants _constants = Constants();
  final _userController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);
    final fireStore = Provider.of<FirestoreService>(context);

    var currentUid;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Register",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ),
        foregroundColor: Colors.black,
        backgroundColor: _constants.primaryColor,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0.3, 0.3), // near the top right
            radius: 1.1,
            colors: <Color>[
              Colors.white, // yellow sun
              _constants.primaryColor, // blue sky
            ],
            stops: <double>[0.9, 0.7],
          ),
        ),

        child: Form(
          key: _formkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(30.0, 0, 30.0, 10.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: "Username",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusColor: _constants.secondaryColor,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "username is required !";
                    }
                    return null;
                  },
                  controller: _userController,
                  style: TextStyle(color: Colors.black),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(30.0, 0, 30.0, 10.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusColor: _constants.secondaryColor,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "email is required";
                    }
                    return null;
                  },
                  controller: _emailController,
                  style: TextStyle(color: Colors.black),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
                child: TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusColor: _constants.secondaryColor,
                  ),
                  controller: _passwordController,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Password is required";
                    } else if (value.length < 8) {
                      return "password should be at least 8 characters";
                    }
                    return null;
                  },
                  style: TextStyle(color: Colors.black),
                ),
              ),

              isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: _constants.primaryColor,
                    ),
                    onPressed: () async {
                      FocusScope.of(context).unfocus();
                      setState(() {
                        isLoading = true;
                      });

                      try {
                        final value = await auth.handleSignUp(
                          _emailController.text,
                          _passwordController.text,
                        );
                        currentUid = value?.uid;

                        fireStore.setUser(
                          AppUser(
                            id: currentUid,
                            name: _userController.text,
                            email: _emailController.text,
                          ),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Verification email sent! Please check your inbox.",
                              style: TextStyle(color: Colors.black),
                            ),
                            backgroundColor: _constants.primaryColor,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );

                        Navigator.popAndPushNamed(
                          context,
                          RouteManager.loginPage,
                        );
                      } on FirebaseAuthException catch (e) {
                        String msg = "registration failed";
                        if (e.code == 'email-already-in-use') {
                          msg = "Email is already in use";
                        } else if (e.code == 'invalid-email') {
                          msg = "Invalid email format";
                        } else {
                          msg = e.message ?? msg;
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(msg),
                            backgroundColor: _constants.red2,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      } finally {
                        if (mounted) {
                          setState(() {
                            isLoading = false;
                          });
                        }
                      }
                    },
                    child: Text("connect", style: TextStyle(fontSize: 20)),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
