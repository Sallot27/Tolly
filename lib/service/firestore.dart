import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/item.dart';

class FirestoreService {
  final CollectionReference _itemsCollection =
      FirebaseFirestore.instance.collection('items');

  // Get a stream of all items from Firestore.
  Stream<List<ItemModel>> getItems() {
    return _itemsCollection.snapshots().map(
      (snapshot) => snapshot.docs
          .map((doc) => ItemModel.fromFirestore(doc))
          .toList(),
    );
  }

  // Get a stream of items owned by a specific user.
  Stream<List<ItemModel>> getItemsForUser(String userId) {
    return _itemsCollection
        .where('ownerId', isEqualTo: userId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ItemModel.fromFirestore(doc))
              .toList(),
        );
  }

  // Get a single item by its ID.
  Future<ItemModel?> getItemById(String itemId) async {
    try {
      DocumentSnapshot doc = await _itemsCollection.doc(itemId).get();
      if (doc.exists) {
        return ItemModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Add a new item to Firestore.
  Future<void> addItem(ItemModel item) async {
    await _itemsCollection.add(item.toFirestore());
  }
}
