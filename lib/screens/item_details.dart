import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
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
    if (_startDate == null || _endDate == null) return;

    setState(() => _loading = true);

    final auth = Provider.of<AuthService>(context, listen: false);
    final bookingService = BookingService();

    final bookingId = const Uuid().v4();

    final booking = BookingModel(
      id: bookingId,
      itemId: widget.item.id,
      borrowerId: auth.user!.uid,
      lenderId: widget.item.ownerId,
      startDate: _startDate!,
      endDate: _endDate!,
      status: "requested",
    );

    await bookingService.createBooking(booking);

    setState(() => _loading = false);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    return Scaffold(
      appBar: AppBar(title: Text(item.title)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(item.imageUrl, height: 250, width: double.infinity, fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(item.description),
                  const SizedBox(height: 8),
                  Text("Price: ${item.pricePerDay} SAR/day"),
                  Text("Deposit: ${item.deposit} SAR"),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _pickDate(start: true),
                          child: Text(_startDate == null ? "Pick Start Date" : _startDate!.toString().split(" ")[0]),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _pickDate(start: false),
                          child: Text(_endDate == null ? "Pick End Date" : _endDate!.toString().split(" ")[0]),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _loading
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: _requestBooking,
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.orangeAccent),
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