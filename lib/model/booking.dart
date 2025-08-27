import 'package:cloud_firestore/cloud_firestore.dart';

class BookingModel {
  final String id;
  final String itemId;
  final String userId;
  final DateTime startDate;
  final DateTime endDate;
  final String status;

  BookingModel({
    required this.id,
    required this.itemId,
    required this.userId,
    required this.startDate,
    required this.endDate,
    required this.status,
  });

  // Factory constructor to create a BookingModel from a Firestore document.
  factory BookingModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return BookingModel(
      id: doc.id,
      itemId: data['itemId'] ?? '',
      userId: data['userId'] ?? '',
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: (data['endDate'] as Timestamp).toDate(),
      status: data['status'] ?? '',
    );
  }

  // Method to convert a BookingModel to a format suitable for Firestore.
  Map<String, dynamic> toFirestore() {
    return {
      'itemId': itemId,
      'userId': userId,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'status': status,
    };
  }
}
