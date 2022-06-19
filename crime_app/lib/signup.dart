import 'package:crime_app/authentication.dart';
import 'package:crime_app/home.dart';
import 'package:crime_app/imagepicker.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class Signup extends StatelessWidget {
  const Signup({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.2),
            // padding:
            //     EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.3),
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: ExactAssetImage('assets/images/justice1.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
                child: Container(
                    decoration:
                        BoxDecoration(color: Colors.white.withOpacity(0.0)),
                    child: ListView(
                        padding: const EdgeInsets.all(8.0),
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 6.0, vertical: 0.0),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 26.0, vertical: 30.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: const Color.fromARGB(174, 110, 87, 87),
                            ),
                            child: Column(
                              children: [
                                const SignupForm(),
                                const SizedBox(height: 20),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        const Padding(
                                          padding: EdgeInsets.only(right: 8.0),
                                          child: Text(
                                              'Already have an account?',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20)),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Login',
                                              style: TextStyle(
                                                decoration:
                                                    TextDecoration.underline,
                                                fontSize: 20,
                                                color: Colors.white,
                                              )),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          )
                        ])))));
  }

  // Container buildLogo() {
  //   return Container(
  //     height: 80,
  //     width: 80,
  //     decoration: const BoxDecoration(
  //         borderRadius: BorderRadius.all(Radius.circular(10)),
  //         color: Colors.blue),
  //     child: const Center(
  //       child: Text(
  //         "T",
  //         style: TextStyle(color: Colors.white, fontSize: 60.0),
  //       ),
  //     ),
  //   );
  // }
}

class SignupForm extends StatefulWidget {
  const SignupForm({Key? key}) : super(key: key);

  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();

  String? email;
  String? password;
  String? name;
  bool _obscureText = false;

  bool agree = false;

  final pass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var border = const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
      borderRadius: BorderRadius.all(
        Radius.circular(100.0),
      ),
    );

    var space = const SizedBox(height: 10);
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          // email
          TextFormField(
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelStyle: const TextStyle(color: Colors.white),
              prefixIcon: const Icon(
                Icons.email_outlined,
                color: Colors.white,
              ),
              labelText: 'Email',
              border: border,
              enabledBorder: border,
              focusedBorder: border,
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
            onSaved: (val) {
              email = val;
            },
            keyboardType: TextInputType.emailAddress,
          ),

          space,
          TextFormField(
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelStyle: const TextStyle(color: Colors.white),
              labelText: 'Full name',
              prefixIcon: const Icon(
                Icons.account_circle,
                color: Colors.white,
              ),
              border: border,
              enabledBorder: border,
              focusedBorder: border,
            ),
            onSaved: (val) {
              name = val;
            },
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter some name';
              }
              return null;
            },
          ),
          space,

          // password
          TextFormField(
            style: const TextStyle(color: Colors.white),
            controller: pass,
            decoration: InputDecoration(
              labelStyle: const TextStyle(color: Colors.white),
              labelText: 'Password',
              prefixIcon: const Icon(
                Icons.lock_outline,
                color: Colors.white,
              ),
              border: border,
              enabledBorder: border,
              focusedBorder: border,
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                child: Icon(
                  color: Colors.white,
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                ),
              ),
            ),
            onSaved: (val) {
              password = val;
            },
            obscureText: !_obscureText,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          space,
          // confirm passwords
          TextFormField(
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelStyle: const TextStyle(color: Colors.white),
              labelText: 'Confirm Password',
              prefixIcon: const Icon(
                Icons.lock_outline,
                color: Colors.white,
              ),
              border: border,
              enabledBorder: border,
              focusedBorder: border,
            ),
            obscureText: true,
            validator: (value) {
              if (value != pass.text) {
                return 'password not match';
              }
              return null;
            },
          ),
          space,
          // name

          Row(
            children: <Widget>[
              Theme(
                data: Theme.of(context).copyWith(
                  unselectedWidgetColor: Colors.white,
                ),
                child: Checkbox(
                  // fillColor: MaterialStateProperty.resolveWith(),

                  activeColor: Colors.white,
                  checkColor: const Color.fromARGB(215, 110, 87, 87),
                  shape: const CircleBorder(),
                  onChanged: (_) {
                    setState(() {
                      agree = !agree;
                    });
                  },
                  value: agree,
                ),
              ),
              const Flexible(
                child: Text(
                  'By creating account, I agree to Terms & Conditions and Privacy Policy.',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),

          // signUP button
          SizedBox(
            height: 50,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  AuthenticationHelper()
                      .signUp(email: email!, password: password!)
                      .then((result) {
                    if (result == null) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CameraWidget()));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          result,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ));
                    }
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(100.0)))),
              child: const Text(
                'Sign Up',
                style: TextStyle(
                    fontSize: 24, color: Color.fromARGB(215, 110, 87, 87)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
