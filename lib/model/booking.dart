import 'package:cloud_firestore/cloud_firestore.dart';

class BookingModel {
  final String id;
  final String itemId;
  final String borrowerId;
  final String lenderId;
  final Timestamp startDate;
  final Timestamp endDate;
  final String status;

  BookingModel({
    required this.id,
    required this.itemId,
    required this.borrowerId,
    required this.lenderId,
    required this.startDate,
    required this.endDate,
    required this.status,
  });

  // Factory constructor to create a BookingModel from Firestore data
  factory BookingModel.fromFirestore(Map<String, dynamic> data) {
    return BookingModel(
      id: data['id'],
      itemId: data['itemId'],
      borrowerId: data['borrowerId'],
      lenderId: data['lenderId'],
      startDate: data['startDate'],
      endDate: data['endDate'],
      status: data['status'],
    );
  }

  // Method to convert the model to a format suitable for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'itemId': itemId,
      'borrowerId': borrowerId,
      'lenderId': lenderId,
      'startDate': startDate,
      'endDate': endDate,
      'status': status,
    };
  }
}
