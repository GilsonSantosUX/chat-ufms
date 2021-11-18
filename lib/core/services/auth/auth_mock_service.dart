import 'dart:async';
import 'dart:math';

import 'package:chat/core/model/chat_user.dart';
import 'dart:io';

import 'package:chat/core/services/auth/auth_service.dart';

class AuthMockService implements AuthService {
  static final _defaultUser = ChatUser(
      id: '1',
      name: 'CHAT UFMS',
      email: 'admin@ufms.br',
      imageURL: 'assets/images/avatar.png');

  static Map<String, ChatUser> _users = {
    _defaultUser.email: _defaultUser,
  };
  static ChatUser? _currentUser;
  static MultiStreamController<ChatUser?>? _controller;
  static final _userStream = Stream<ChatUser?>.multi((controller) {
    _controller = controller;
    _updateUser(_defaultUser);
  });

  ChatUser? get currentUser {
    return _currentUser;
  }

  @override
  Future<void> login(String email, String password) async {
    _updateUser(_users[email]);
  }

  @override
  Future<void> logout() async {
    _updateUser(null);
  }

  @override
  Future<void> signup(
      String name, String email, String password, File? image) async {
    final newUser = ChatUser(
        id: Random().nextDouble().toString(),
        name: name,
        email: email,
        imageURL: image?.path ?? 'assets/images/avatar.png');
    _users.putIfAbsent(email, () => newUser);
    _updateUser(newUser);
  }

  Stream<ChatUser?> get userChanges {
    return _userStream;
  }

  static void _updateUser(ChatUser? user) {
    _currentUser = user;
    _controller?.add(_currentUser);
  }
}
