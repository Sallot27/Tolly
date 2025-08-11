import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/booking.dart';

class BookingService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> createBooking(BookingModel booking) async {
    await _db.collection('bookings').doc(booking.id).set(booking.toMap());
  }

  Stream<List<BookingModel>> getBookingsForUser(String userId) {
    return _db
        .collection('bookings')
        .where('lenderId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => BookingModel.fromMap(doc.data())).toList());
  }
}