import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadVehicleImage(File image) async {
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final ref = _storage.ref().child('vehicles/$fileName.jpg');
    await ref.putFile(image);
    return await ref.getDownloadURL();
  }
}
