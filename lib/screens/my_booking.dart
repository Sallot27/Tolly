import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../service/booking.dart';
import '../service/auth.dart';
import '../service/firestore.dart';
import '../model/booking.dart';

class MyBookingsScreen extends StatelessWidget {
  const MyBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final bookingService = BookingService();
    final firestore = FirestoreService();

    return Scaffold(
      appBar: AppBar(title: const Text("My Bookings")),
      body: StreamBuilder<List<BookingModel>>(
        stream: bookingService.getBookingsForUser(auth.user!),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final bookings = snapshot.data!;
          if (bookings.isEmpty) return const Center(child: Text("No bookings yet."));
          
          return ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (_, i) {
              final b = bookings[i];
              final item = firestore.getItemById(b.itemId);
              
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: item != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(item.imageUrl, width: 60, height: 60, fit: BoxFit.cover),
                        )
                      : const Icon(Icons.help_outline, size: 60),
                  title: Text(item?.title ?? "Unknown Item"),
                  subtitle: Text("${b.startDate.toString().split(" ")[0]} → ${b.endDate.toString().split(" ")[0]}"),
                  trailing: Chip(
                    label: Text(b.status.toUpperCase()),
                    backgroundColor: b.status == "requested" ? Colors.yellow.shade900 : Colors.green.shade900,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
