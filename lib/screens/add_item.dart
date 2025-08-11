
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../service/auth.dart';
import '../service/firestore.dart';
import '../service/storage.dart';
import '../model/item.dart';

class AddItemScreen extends StatefulWidget {
const AddItemScreen({super.key});

@override
State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
final _formKey = GlobalKey<FormState>();
final _titleController = TextEditingController();
final _descController = TextEditingController();
final _depositController = TextEditingController();
final _priceController = TextEditingController();
String _category = "General";
File? _imageFile;

bool _isLoading = false;

Future<void> _pickImage() async {
final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
if (pickedFile != null) {
setState(() {
_imageFile = File(pickedFile.path);
});
}
}

Future<void> _saveItem() async {
if (!_formKey.currentState!.validate() || _imageFile == null) return;

setState(() => _isLoading = true);

final auth = Provider.of<AuthService>(context, listen: false);
final storage = StorageService();
final firestore = FirestoreService();

try {
final itemId = const Uuid().v4();
final imageUrl = await storage.uploadImage(_imageFile!, "items/$itemId.jpg");

final newItem = ItemModel(
id: itemId,
ownerId: auth.user!.uid,
title: _titleController.text.trim(),
description: _descController.text.trim(),
imageUrl: imageUrl,
category: _category,
deposit: double.tryParse(_depositController.text) ?? 0,
pricePerDay: double.tryParse(_priceController.text) ?? 0,
);

await firestore.addItem(newItem);
Navigator.pop(context);
} catch (e) {
debugPrint("Error adding item: $e");
} finally {
setState(() => _isLoading = false);
}
}

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(title: const Text("Add Tool")),
body: SingleChildScrollView(
padding: const EdgeInsets.all(16),
child: Form(
key: _formKey,
child: Column(
children: [
GestureDetector(
onTap: _pickImage,
child: Container(
height: 150,
width: double.infinity,
color: Colors.grey[800],
child: _imageFile == null
? const Icon(Icons.add_a_photo, color: Colors.white70)
: Image.file(_imageFile!, fit: BoxFit.cover),
),
),
const SizedBox(height: 16),
TextFormField(
controller: _titleController,
decoration: const InputDecoration(labelText: "Tool Name"),
validator: (v) => v!.isEmpty ? "Enter tool name" : null,
),
TextFormField(
controller: _descController,
decoration: const InputDecoration(labelText: "Description"),
maxLines: 2,
),
TextFormField(
controller: _depositController,
decoration: const InputDecoration(labelText: "Deposit Amount"),
keyboardType: TextInputType.number,
),
TextFormField(
controller: _priceController,
decoration: const InputDecoration(labelText: "Price Per Day"),
keyboardType: TextInputType.number,
),
const SizedBox(height: 10),
DropdownButtonFormField(
value: _category,
items: ["General", "Gardening", "Construction", "Party"].map((cat) {
return DropdownMenuItem(value: cat, child: Text(cat));
}).toList(),
onChanged: (val) => setState(() => _category = val!),
decoration: const InputDecoration(labelText: "Category"),
),
const SizedBox(height: 20),
_isLoading
? const CircularProgressIndicator()
: ElevatedButton(
onPressed: _saveItem,
style: ElevatedButton.styleFrom(backgroundColor: Colors.orangeAccent),
child: const Text("Add Tool"),
),
],
),
),
),
);
}
}

