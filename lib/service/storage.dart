import 'dart:io';

class StorageService {
  Future<String> uploadImage(File file, String path) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate upload time
    return 'https://placehold.co/400x300/607D8B/FFFFFF?text=Uploaded';
  }
}
