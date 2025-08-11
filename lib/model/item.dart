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

Map<String, dynamic> toMap() {
return {
'id': id,
'ownerId': ownerId,
'title': title,
'description': description,
'imageUrl': imageUrl,
'category': category,
'deposit': deposit,
'pricePerDay': pricePerDay,
};
}

factory ItemModel.fromMap(Map<String, dynamic> map) {
return ItemModel(
id: map['id'] ?? '',
ownerId: map['ownerId'] ?? '',
title: map['title'] ?? '',
description: map['description'] ?? '',
imageUrl: map['imageUrl'] ?? '',
category: map['category'] ?? '',
deposit: (map['deposit'] ?? 0).toDouble(),
pricePerDay: (map['pricePerDay'] ?? 0).toDouble(),
);
}
}


