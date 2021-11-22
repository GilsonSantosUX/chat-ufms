import 'package:chat/components/messsges.dart';
import 'package:chat/components/new_messages.dart';
import 'package:chat/core/model/chat_notification.dart';
import 'package:chat/core/services/auth/auth_service.dart';
import 'package:chat/core/services/notification/chat_notification_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'notification_page.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        // leading: IconButton(
        //   icon: Icon(Icons.menu),
        //   onPressed: () {
        //     // AuthService().logout();
        //   },
        // ),
        title: const Text('Chat UFMS'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8, top: 4),
            child: DropdownButton(
              underline: DropdownButtonHideUnderline(child: SizedBox()),
              icon: Icon(
                Icons.more_vert,
                color: Theme.of(context).primaryIconTheme.color,
              ),
              items: [
                DropdownMenuItem(
                  value: 'logout',
                  child: Container(
                    child: Row(
                      children: const [
                        Icon(
                          Icons.exit_to_app,
                          color: Colors.black87,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text('Sair')
                      ],
                    ),
                  ),
                ),
              ],
              onChanged: (value) {
                if (value == 'logout') {
                  AuthService().logout();
                }
              },
            ),
          ),
          Stack(children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                  return NotificationPage();
                }));
              },
              icon: const Icon(Icons.notifications),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: CircleAvatar(
                maxRadius: 8,
                backgroundColor: Theme.of(context).errorColor,
                child: Text(
                  '${Provider.of<ChatNotificationService>(context).itemsCount}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    overflow: TextOverflow.ellipsis,
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ]),
        ],
      ),
      body: SafeArea(
        child: Column(children: const [
          Expanded(
            child: Messages(),
          ),
          NewMessages(),
        ]),
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.add),
      //   onPressed: () {
      //     Provider.of<ChatNotificationService>(context, listen: false).add(
      //         ChatNotification(
      //             title: 'First Noty', body: 'Descrição da notificação'));
      //   },
      // ),
    );
  }
}
