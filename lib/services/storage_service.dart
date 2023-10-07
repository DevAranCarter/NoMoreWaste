import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  static final _instance = StorageService._internal();

  StorageService._internal();

  static StorageService get instance {
    return _instance;
  }

  Future<String> loadImage(String fileName) async {
    final ref = FirebaseStorage.instance.ref().child(fileName);
    // no need of the file extension, the name will do fine.
    var url = await ref.getDownloadURL();

    return url;
  }

}
