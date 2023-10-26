  // ignore_for_file: use_build_context_synchronously

  import 'package:flutter/material.dart';
  import 'package:provider/provider.dart';
  import 'package:easy_wash_v1/userSetup/AuthProvider.dart';
  import 'package:easy_wash_v1/userSetup/registration_screen.dart';
  import 'package:fluttertoast/fluttertoast.dart';

  class LoginPage extends StatelessWidget {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Login Page'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  final email = emailController.text;
                  final password = passwordController.text;
                  final authProvider =
                  Provider.of<AuthProvider>(context, listen: false);

                  await authProvider.login(email, password);

                  if (authProvider.isLoggedIn) {
                    Navigator.pop(context);
                    // Return true if logged in
                  } else {
                    Fluttertoast.showToast(
                      msg: 'Authorization failed, try again or Register',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.grey,
                      textColor: Colors.white,
                    );
                  }
                },
                child: Text('Login'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Navigate to the registration screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegistrationScreen()),
                  );
                },
                child: Text('Register New User'),
              ),
            ],
          ),
        ),
      );
    }
  }