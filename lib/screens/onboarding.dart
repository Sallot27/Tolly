import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../service/auth.dart';

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
              const Icon(Icons.handyman, size: 100, color: Colors.orangeAccent),
              const SizedBox(height: 20),
              const Text(
                "Neighbour Tool Lending",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 10),
              const Text(
                "Borrow and lend tools with your community.",
                style: TextStyle(fontSize: 16, color: Colors.white70),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: ElevatedButton(
                  onPressed: () => auth.signInAnonymously(),
                  child: const Text("Continue as Guest"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
