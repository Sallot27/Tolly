import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../service/firestore.dart';
import '../service/auth.dart';
import '../model/item.dart';

class MyToolsScreen extends StatelessWidget {
  const MyToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firestore = FirestoreService();
    final auth = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text("My Tools")),
      body: StreamBuilder<List<ItemModel>>(
        stream: firestore.getItemsForUser(auth.user!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("You have not added any tools yet."));
          }

          final items = snapshot.data!;
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (_, i) {
              final item = items[i];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("${item.pricePerDay} SAR/day"),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // TODO: Navigate to a screen to view and manage bookings for this item.
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Manage bookings for this tool.')),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
