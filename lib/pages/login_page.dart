import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_list_app/constants.dart';
import 'package:to_do_list_app/routes/routes.dart';
import 'package:to_do_list_app/services/auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final Constants _constants = Constants();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          "Login",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ),
        backgroundColor: _constants.primaryColor,
        foregroundColor: Colors.black,
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(-0.3, 0.3), // near the top right
            radius: 1,
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
                    labelText: "email",
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
                    labelText: "password",
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
                      backgroundColor: _constants.primaryColor,
                      foregroundColor: Colors.black,
                    ),
                    onPressed: () async {
                      FocusScope.of(context).unfocus();
                      setState(() {
                        isLoading = true;
                      });

                      try {
                        final value = await auth.handleSignInEmail(
                          _emailController.text,
                          _passwordController.text,
                        );
                        final SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        await prefs.setString('userId', value!.uid);
                        await prefs.setBool("isLogin", true);

                        Navigator.popAndPushNamed(
                          context,
                          RouteManager.taskPage,
                          arguments: value.uid,
                        );
                      } on FirebaseAuthException catch (e) {
                        String msg = "Login Failed";

                        if (e.code == 'user-not-found') {
                          msg = "user not registered";
                        } else if (e.code == 'wrong-password') {
                          msg = "email or password is incorrect";
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
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(e.toString()),
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
                    child: Text("Login", style: TextStyle(fontSize: 20)),
                  ),
              TextButton(
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  Navigator.pushNamed(context, RouteManager.registerPage);
                },
                child: Text("Don't have an account?"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
