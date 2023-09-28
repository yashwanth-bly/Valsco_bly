import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core/models/models.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference users =
      FirebaseFirestore.instance.collection('valsco_users');
  User? getUser() {
    return FirebaseAuth.instance.currentUser;
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<ValscoUser?> readUser() async {
    final snapShotData = await users.doc(getUser()!.uid).get();
    if (snapShotData.exists) {
      return ValscoUser.fromJson(snapShotData.data());
    }
    return null;
  }

  Stream<DocumentSnapshot<Object?>> listenUser() {
    return users.doc(getUser()!.uid).snapshots();
  }

  Future<ValscoUser> addUser() async {
    User user = getUser()!;
    final userJson = {'name': user.displayName, 'uid': user.uid, 'photo': ''};
    await users.doc(user.uid).set(userJson);
    return ValscoUser.fromJson(userJson);
  }

  uploadImage(File file) async {
    final userId = getUser()!.uid;
    print('blb $userId');
    Reference ref = FirebaseStorage.instance
        .ref()
        .child('valsco_users_pics')
        .child('/$userId.jpg');

    UploadTask uploadTask;

    final metadata = SettableMetadata(
      contentType: 'image/jpeg',
      customMetadata: {'picked-file-path': file.path},
    );
    uploadTask = ref.putFile(File(file.path), metadata);

    final url = await (await uploadTask).ref.getDownloadURL();


    return users.doc(userId).update({'photo': url});
  }

  logout() {
    return FirebaseAuth.instance.signOut();
  }
}
