import 'package:crime_app/image/imagepicker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth/login.dart';
import 'fir_output/output.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: SharedPreferences.getInstance(),
      initialData: null,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        Widget home = const Login();
        if (snapshot.data != null) {
          SharedPreferences pref = snapshot.data;
          if (pref.getBool('auth') ?? false) {
            home = const CameraWidget();
          }
        }
        return MaterialApp(
          theme: ThemeData(fontFamily: 'Libre'),
          debugShowCheckedModeBanner: false,
          title: 'Crime App',
          home: home,
        );
      },
    );
  }
}
