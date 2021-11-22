import 'dart:async';

import 'package:chat/core/model/chat_user.dart';
import 'dart:io';

import 'package:chat/core/services/auth/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthFirebaseService implements AuthService {
  static ChatUser? _currentUser;
  // static MultiStreamController<ChatUser?>? _controller;
  static final _userStream = Stream<ChatUser?>.multi((controller) async {
    // _controller = controller;
    final authChanges = FirebaseAuth.instance.authStateChanges();
    await for (final user in authChanges) {
      _currentUser = user == null ? null : _toChatUser(user);
      controller.add(_currentUser);
    }
  });

  ChatUser? get currentUser {
    return _currentUser;
  }

  Stream<ChatUser?> get userChanges {
    return _userStream;
  }

  @override
  Future<void> login(String email, String password) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
  }

  @override
  Future<void> logout() async {
    FirebaseAuth.instance.signOut();
  }

  @override
  Future<void> signup(
      String name, String email, String password, File? image) async {
    final auth = FirebaseAuth.instance;
    UserCredential creadential = await auth.createUserWithEmailAndPassword(
        email: email, password: password);
    if (creadential.user == null) return;

    final imageName = '${creadential.user!.uid}.jpg';
    final imageURL = await _uploadUserImage(image, imageName);

    await creadential.user?.updateDisplayName(name);
    await creadential.user?.updatePhotoURL(imageURL);

    _currentUser = _toChatUser(creadential.user!, name, imageURL);
    await _saveChatUser(_currentUser!);
  }

  static ChatUser _toChatUser(User user, [String? name, String? imageURL]) {
    return ChatUser(
      id: user.uid,
      name: name ?? user.displayName ?? user.email!.split("@")[0],
      email: user.email!,
      imageURL: imageURL ?? user.photoURL ?? 'assets/images/avatar.png',
    );
  }

  Future<String?> _uploadUserImage(File? image, String imageName) async {
    if (image == null) return null;
    final storage = FirebaseStorage.instance;
    final imageRef = storage.ref().child('user_image').child(imageName);
    await imageRef.putFile(image).whenComplete(() async {
      return await imageRef.getDownloadURL();
    });
  }

  Future<void> _saveChatUser(ChatUser user) async {
    final store = FirebaseFirestore.instance;
    final docRef = store.collection('users').doc(user.id);

    return docRef.set({
      'name': user.name,
      'email': user.email,
      'imageURL': user.imageURL,
    });
  }
}
