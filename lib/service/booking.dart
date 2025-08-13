import 'dart:async';
import '../model/booking.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookingService {
  final List<BookingModel> _bookings = [];

  Stream<List<BookingModel>> getBookingsForUser(String userId) {
    return Stream.value(_bookings.where((b) => b.borrowerId == userId).toList());
  }

  Future<void> createBooking(BookingModel booking) async {
    // In a real app, you'd add the booking to Firestore
    // For this mock, we'll just add it to the list
    _bookings.add(booking);
  }
}
