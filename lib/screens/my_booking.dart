import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../service/booking.dart';
import '../service/auth.dart';
import '../model/booking.dart';

class MyBookingsScreen extends StatelessWidget {
  const MyBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final bookingService = BookingService();

    return Scaffold(
      appBar: AppBar(title: const Text("My Bookings")),
      body: StreamBuilder<List<BookingModel>>(
        stream: bookingService.getBookingsForUser(auth.user!.uid),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final bookings = snapshot.data!;
          if (bookings.isEmpty) return const Center(child: Text("No bookings yet."));
          return ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (_, i) {
              final b = bookings[i];
              return ListTile(
                title: Text("Item: ${b.itemId}"),
                subtitle: Text("${b.startDate.toString().split(" ")[0]} → ${b.endDate.toString().split(" ")[0]}"),
                trailing: Text(b.status),
              );
            },
          );
        },
      ),
    );
  }
}