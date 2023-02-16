import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:weight_tracker_firestore/utils/utils.dart';
import 'package:weight_tracker_firestore/view/add_weight_screen.dart';
import 'package:weight_tracker_firestore/widget/round_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<
      FormState>(); // this is used to check email empty and to use Form
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _loading = false;
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void login() async{
    setState(() {
      _loading = true;
    });
    User? user = (await _auth.signInAnonymously()).user;
        if(user!=null && user.isAnonymous == true) {
      setState(() {
        _loading = false;
      });
      Utils().toastMessage('Login successful');
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => AddWeightScreen()));
    }else{
      //debugPrint(error.toString());
      Utils().toastMessage('Error while sign in');
      setState(() {
        _loading = false;
      });
    };
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      //android buttons
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Center(child: Text('Login')),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      decoration: const InputDecoration(
                        hintText: 'Email',
                        //helperText: 'e.g: abc@gmail.com',
                        prefixIcon: Icon(Icons.alternate_email),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter email';
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintText: 'Password',
                        prefixIcon: Icon(Icons.lock_open_sharp),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter password';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              RoundButton(
                loading: _loading,
                title: 'Login',
                onTap: () {
                  if (formKey.currentState!.validate()) {
                    login();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
