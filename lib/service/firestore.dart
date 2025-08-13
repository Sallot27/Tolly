import 'dart:async';
import 'package:flutter/foundation.dart';
import '../model/item.dart';
import '../model/booking.dart';

class FirestoreService {
  final List<ItemModel> _items = [
    ItemModel(
      id: '1',
      ownerId: 'owner123',
      title: 'Power Drill',
      description: 'A powerful cordless drill for all your home projects.',
      imageUrl: 'https://placehold.co/400x300/4CAF50/FFFFFF?text=Drill',
      category: 'Construction',
      deposit: 50.0,
      pricePerDay: 15.0,
    ),
    ItemModel(
      id: '2',
      ownerId: 'owner123',
      title: 'Lawn Mower',
      description: 'An electric lawn mower for a clean cut every time.',
      imageUrl: 'https://placehold.co/400x300/2196F3/FFFFFF?text=Mower',
      category: 'Gardening',
      deposit: 75.0,
      pricePerDay: 20.0,
    ),
    ItemModel(
      id: '3',
      ownerId: 'borrower456',
      title: 'Ladder',
      description: 'A sturdy 10-foot ladder for those hard-to-reach places.',
      imageUrl: 'https://placehold.co/400x300/FFC107/000000?text=Ladder',
      category: 'General',
      deposit: 30.0,
      pricePerDay: 10.0,
    ),
  ];

  Stream<List<ItemModel>> getItems() {
    return Stream.value(_items);
  }

  Stream<List<ItemModel>> getItemsForUser(String userId) {
    return Stream.value(_items.where((item) => item.ownerId == userId).toList());
  }
  
  ItemModel? getItemById(String itemId) {
    try {
      return _items.firstWhere((item) => item.id == itemId);
    } catch (e) {
      debugPrint("Item not found: $e");
      return null;
    }
  }

  Future<void> addItem(ItemModel item) async {
    _items.add(item);
  }
}
