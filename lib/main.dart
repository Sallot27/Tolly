import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '/screens/home.dart';
import '/screens/onboarding.dart';
import '/service/auth.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Tooly());
}

class Tooly extends StatelessWidget {
  const Tooly({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
      ],
      child: MaterialApp(
        title: 'Tolly',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: OnboardingScreen(),
        routes: {
          HomeScreen.routeName: (context) => HomeScreen(),
        },
      ),
    );
  }
}
