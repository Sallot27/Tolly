import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Make sure this is imported
import '../model/item.dart';
import '../model/booking.dart';
import '../service/booking.dart';
import '../service/auth.dart';

class ItemDetailScreen extends StatefulWidget {
  final ItemModel item;
  const ItemDetailScreen({super.key, required this.item});

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  DateTime? _startDate;
  DateTime? _endDate;
  bool _loading = false;

  Future<void> _pickDate({required bool start}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        if (start) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _requestBooking() async {
    // This check ensures _startDate and _endDate are not null
    if (_startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select both start and end dates.')),
      );
      return;
    }
    if (_startDate!.isAfter(_endDate!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Start date must be before end date.')),
      );
      return;
    }

    setState(() => _loading = true);

    final auth = Provider.of<AuthService>(context, listen: false);
    final bookingService = BookingService();

    final bookingId = const Uuid().v4();

    // The key part: Convert DateTime? to Timestamp by using .fromDate()
    // The '!' operator asserts that _startDate and _endDate are not null here.
    final booking = BookingModel(
      id: bookingId,
      itemId: widget.item.id,
      borrowerId: auth.user!,
      lenderId: widget.item.ownerId,
      startDate: Timestamp.fromDate(_startDate!),
      endDate: Timestamp.fromDate(_endDate!),
      status: "requested",
    );

    await bookingService.createBooking(booking);

    setState(() => _loading = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking request sent successfully!')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    return Scaffold(
      appBar: AppBar(title: Text(item.title)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.network(
              item.imageUrl,
              height: 250,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.description,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  Text("Category: ${item.category}", style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text("Price: ${item.pricePerDay} SAR/day"),
                  Text("Deposit: ${item.deposit} SAR"),
                  const SizedBox(height: 24),
                  const Text("Request a booking:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _pickDate(start: true),
                          child: Text(_startDate == null ? "Start Date" : _startDate!.toString().split(" ")[0]),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _pickDate(start: false),
                          child: Text(_endDate == null ? "End Date" : _endDate!.toString().split(" ")[0]),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _loading
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: _requestBooking,
                          child: const Text("Request Booking"),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
