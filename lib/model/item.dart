import 'package:cloud_firestore/cloud_firestore.dart';

class ItemModel {
  final String id;
  final String ownerId;
  final String title;
  final String description;
  final String imageUrl;
  final String category;
  final double deposit;
  final double pricePerDay;

  ItemModel({
    required this.id,
    required this.ownerId,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.category,
    required this.deposit,
    required this.pricePerDay,
  });

  // Factory constructor to create an ItemModel from a Firestore document.
  factory ItemModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return ItemModel(
      id: doc.id,
      ownerId: data['ownerId'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      category: data['category'] ?? '',
      deposit: (data['deposit'] ?? 0.0).toDouble(),
      pricePerDay: (data['pricePerDay'] ?? 0.0).toDouble(),
    );
  }

  // Method to convert an ItemModel to a format suitable for Firestore.
  Map<String, dynamic> toFirestore() {
    return {
      'ownerId': ownerId,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'category': category,
      'deposit': deposit,
      'pricePerDay': pricePerDay,
    };
  }
}
