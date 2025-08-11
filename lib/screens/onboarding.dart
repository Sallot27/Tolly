import 'package:flutter/material.dart';
import '../service/auth.dart';
import 'package:provider/provider.dart';

class OnboardingScreen extends StatelessWidget {
const OnboardingScreen({super.key});

@override
Widget build(BuildContext context) {
final auth = Provider.of<AuthService>(context, listen: false);

return Scaffold(
body: SafeArea(
child: Center(
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
children: [
const Icon(Icons.handyman, size: 80, color: Colors.orangeAccent),
const SizedBox(height: 20),
const Text(
"Neighbour Tool Lending",
style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
),
const SizedBox(height: 20),
ElevatedButton(
onPressed: () => auth.signInAnonymously(),
child: const Text("Continue as Guest"),
),
],
),
),
),
);
}
}
