

import 'package:flutter/material.dart';
import '../service/firestore.dart';
import '../model/item.dart';
import 'add_item.dart';
import 'item_details.dart';

class HomeScreen extends StatelessWidget {
  static var routeName;

const HomeScreen({super.key});

@override
Widget build(BuildContext context) {
final firestore = FirestoreService();

return Scaffold(
appBar: AppBar(title: const Text("Available Tools")),
body: StreamBuilder<List<ItemModel>>(
stream: firestore.getItems(),
builder: (context, snapshot) {
if (snapshot.connectionState == ConnectionState.waiting) {
return const Center(child: CircularProgressIndicator());
}
if (!snapshot.hasData || snapshot.data!.isEmpty) {
return const Center(child: Text("No tools available yet."));
}

final items = snapshot.data!;
return ListView.builder(
itemCount: items.length,
itemBuilder: (_, i) {
final item = items[i];

return Card(
  margin: const EdgeInsets.all(8),
  child: ListTile(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ItemDetailScreen(item: item)),
      );
    },
    leading: Image.network(item.imageUrl, width: 50, height: 50, fit: BoxFit.cover),
    title: Text(item.title),
    subtitle: Text("${item.pricePerDay} SAR/day • Deposit: ${item.deposit}"),
  ),
);
},
);
},
),
floatingActionButton: FloatingActionButton(
backgroundColor: Colors.orangeAccent,
onPressed: () {
Navigator.push(context, MaterialPageRoute(builder: (_) => const AddItemScreen()));
},
child: const Icon(Icons.add),
),
);
}
}