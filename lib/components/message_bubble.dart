import 'dart:io';

import 'package:chat/core/model/chat_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MessageBubble extends StatelessWidget {
  static final _defaultImage = 'assets/images/avatar.png';
  final ChatMessage message;
  final bool belongsToCurrentUser;

  const MessageBubble({
    Key? key,
    required this.message,
    required this.belongsToCurrentUser,
  }) : super(key: key);

  Widget _showUserImage(String imageURL) {
    ImageProvider? provider;

    final uri = Uri.parse(imageURL);

    if (uri.path.contains(_defaultImage)) {
      provider = AssetImage(uri.toString());
    } else if (uri.scheme.contains('http')) {
      provider = NetworkImage(uri.toString());
    } else {
      provider = FileImage(File(uri.toString()));
    }
    return CircleAvatar(
      backgroundImage: provider,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment: belongsToCurrentUser
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!belongsToCurrentUser)
              Container(
                  margin: EdgeInsets.only(left: 8),
                  child: _showUserImage(message.userImageURL)),
            Container(
              decoration: BoxDecoration(
                color: belongsToCurrentUser
                    ? Colors.grey.shade300
                    : Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                    bottomRight: belongsToCurrentUser
                        ? Radius.circular(0)
                        : Radius.circular(8),
                    bottomLeft: belongsToCurrentUser
                        ? Radius.circular(8)
                        : Radius.circular(0)),
              ),
              constraints: BoxConstraints(
                  minWidth: 100,
                  maxWidth: MediaQuery.of(context).size.width - 80),
              width: 240,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(message.userName,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: belongsToCurrentUser
                                ? Colors.grey.shade800
                                : Colors.white,
                            fontWeight: FontWeight.bold,
                          )),
                    ],
                  ),
                  Text(
                    message.text,
                    style: TextStyle(
                      color: belongsToCurrentUser
                          ? Colors.grey.shade900
                          : Colors.white,
                    ),
                    textAlign:
                        belongsToCurrentUser ? TextAlign.right : TextAlign.left,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        message.createdAt.day.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 10,
                          color: belongsToCurrentUser
                              ? Colors.grey.shade700
                              : Colors.blue.shade900,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (belongsToCurrentUser)
              Container(
                  margin: EdgeInsets.only(right: 8),
                  child: _showUserImage(message.userImageURL)),
          ],
        ),
        // Positioned(
        //   top: 0,
        //   left: belongsToCurrentUser ? null : 220,
        //   right: belongsToCurrentUser ? 200 : null,
        //   child: CircleAvatar(
        //     backgroundColor: Colors.pink,
        //   ),
        // ),
      ],
    );
  }
}
