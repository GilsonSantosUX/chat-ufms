import 'dart:async';
import 'dart:math';
import 'package:chat/core/model/chat_message.dart';
import 'package:chat/core/model/chat_user.dart';
import 'package:chat/core/services/chat/chat_service.dart';

class ChatMockService implements ChatService {
  static final List<ChatMessage> _msgs = [
    ChatMessage(
      id: '1',
      text: 'Bom dia',
      createdAt: DateTime.now(),
      userId: '123',
      userName: 'Admin',
      userImageURL: 'assets/images/avatar.png',
    ),
    ChatMessage(
      id: '2',
      text:
          'Olá hoje teremos aula gravada ou ao vivo, se sim qual será o horário?',
      createdAt: DateTime.now(),
      userId: '321',
      userName: 'Chat UFMS',
      userImageURL: 'assets/images/avatar.png',
    ),
    ChatMessage(
      id: '3',
      text: 'Como todos do grupo estão?',
      createdAt: DateTime.now(),
      userId: '456',
      userName: 'Coordenador',
      userImageURL: 'assets/images/avatar.png',
    )
  ];

  static MultiStreamController<List<ChatMessage>>? _controller;
  static final _msgsStream = Stream<List<ChatMessage>>.multi((controller) {
    _controller = controller;
    controller.add(_msgs);
  });

  Stream<List<ChatMessage>> messagesStream() {
    return _msgsStream;
  }

  Future<ChatMessage> save(String text, ChatUser user) async {
    final newMessage = ChatMessage(
      id: Random().nextDouble().toString(),
      text: text,
      createdAt: DateTime.now(),
      userId: user.id,
      userName: user.name,
      userImageURL: user.imageURL,
    );

    _msgs.add(newMessage);
    _controller?.add(_msgs.reversed.toList());
    return newMessage;
  }
}
