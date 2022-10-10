import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spending_management/repository/data_manager.dart';

class ProfileRepository {
  static final ProfileRepository profileRepo = ProfileRepository._getInstance();

  ProfileRepository._getInstance();

  final storageRef = FirebaseStorage.instance.ref();
  DataManager dataManager = DataManager.instance;

  getFromGallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      final metadata = SettableMetadata(contentType: "image/jpeg");
      var currentUserId = await dataManager.getCurrentUserId();
      final uploadTask = storageRef
          .child('images/avatar/$currentUserId.jpg')
          .putFile(imageFile, metadata);

      uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
        switch (taskSnapshot.state) {
          case TaskState.running:
            final progress = 100.0 *
                (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
            print("Upload is $progress% complete.");
            break;
          case TaskState.paused:
            print("Upload is paused.");
            break;
          case TaskState.canceled:
            print("Upload was canceled");
            break;
          case TaskState.error:
            // Handle unsuccessful uploads
            break;
          case TaskState.success:
            // Handle successful uploads on complete
            // ...
            break;
        }
      });
    }
  }
}
