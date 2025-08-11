
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/item.dart';

class FirestoreService {
final FirebaseFirestore _db = FirebaseFirestore.instance;

Future<void> addItem(ItemModel item) async {
await _db.collection('items').doc(item.id).set(item.toMap());
}

Stream<List<ItemModel>> getItems() {
return _db.collection('items').snapshots().map((snapshot) {
return snapshot.docs.map((doc) => ItemModel.fromMap(doc.data())).toList();
});
}
}
