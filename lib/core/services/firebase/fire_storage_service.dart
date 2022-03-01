import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';

class FireStorageService {
  StorageUploadTask uploadFileToStorage(
      {@required String fileId,
      @required File file,
      @required List<String> directories}) {
    try {
      StorageReference storageReference = FirebaseStorage.instance.ref();

      if (directories != null) {
        for (var directory in directories) {
          storageReference = storageReference.child(directory);
        }
      }

      storageReference = storageReference
          .child(fileId ?? DateTime.now().millisecondsSinceEpoch.toString());

      final StorageUploadTask uploadTask = storageReference.putFile(file);

      return uploadTask;
    } catch (e) {
      Logger().e('upload file error $e');
      return null;
    }
  }

  getFileFromStorage(String filepath) async {
    StorageReference starsRef = FirebaseStorage.instance.ref().child(filepath);
    return await starsRef.getDownloadURL();
  }

  deleteFileFromUrl(String url) async {
    try {
      StorageReference starsRef =
          await FirebaseStorage.instance.getReferenceFromUrl(url);
      await starsRef.delete();
      print("URL deleted:$url");
    } catch (e) {}
  }
}
