import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../model/item.dart';
import '../service/auth.dart';
import '../service/firestore.dart';
import '../service/storage.dart';
import '../widget/custom_input.dart'; // Import the new widget
import '../widget/custom_button.dart'; // Import the new widget

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
    if (!_formKey.currentState!.validate() || _imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields and add an image.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final auth = Provider.of<AuthService>(context, listen: false);
    final storage = StorageService();
    final firestore = FirestoreService();

    try {
      final itemId = const Uuid().v4();
      final imageUrl = await storage.uploadImage(_imageFile!, "items/$itemId.jpg");

      final newItem = ItemModel(
        id: itemId,
        ownerId: auth.user!,
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
        imageUrl: imageUrl,
        category: _category,
        deposit: double.tryParse(_depositController.text) ?? 0,
        pricePerDay: double.tryParse(_priceController.text) ?? 0,
      );

      await firestore.addItem(newItem);
      if(mounted) Navigator.pop(context);
    } catch (e) {
      debugPrint("Error adding item: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add New Tool")),
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
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: _imageFile == null
                      ? const Icon(Icons.add_a_photo, size: 50, color: Colors.white70)
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(_imageFile!, fit: BoxFit.cover)),
                ),
              ),
              const SizedBox(height: 16),
              CustomInput(
                controller: _titleController,
                labelText: "Tool Name",
                validator: (v) => v!.isEmpty ? "Enter tool name" : null,
              ),
              const SizedBox(height: 10),
              CustomInput(
                controller: _descController,
                labelText: "Description",
                maxLines: 2,
              ),
              const SizedBox(height: 10),
              CustomInput(
                controller: _depositController,
                labelText: "Deposit Amount (SAR)",
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? "Enter deposit amount" : null,
              ),
              const SizedBox(height: 10),
              CustomInput(
                controller: _priceController,
                labelText: "Price Per Day (SAR)",
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? "Enter price per day" : null,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _category,
                decoration: const InputDecoration(labelText: "Category"),
                items: ["General", "Gardening", "Construction", "Party"].map((cat) {
                  return DropdownMenuItem(value: cat, child: Text(cat));
                }).toList(),
                onChanged: (val) => setState(() => _category = val!),
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: "Add Tool",
                onPressed: _saveItem,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
