import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/UI/homepage.dart';
import 'package:flutter_application_2/UI/loginPage.dart';
import 'package:flutter_application_2/UI/newAcc.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_2/service/database.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); 
  runApp(UserInfo());
}

class UserInfo extends StatelessWidget {
  const UserInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider<FirestoreService>(
      create: (context) => FirestoreService(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Firebase Example',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        initialRoute: '/login', 
        routes: {
          '/login': (context) => LoginPage(),
          '/signUpPage': (context) => SignUpPage(),
          '/homePage': (context) => HomeScreen(),
        },
      ),
    );
  }
}
