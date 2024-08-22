import 'package:dstorres_plataforma/pages/services/classes.dart';
import 'package:flutter/material.dart';
import 'package:dstorres_plataforma/pages/services/chats/chat_page.dart';
import 'package:dstorres_plataforma/services/socket_service.dart';
import 'package:intl/intl.dart';



class ChatListPage extends StatefulWidget {
  final SocketService socketService;

  const ChatListPage({required this.socketService, super.key});

  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat List'),
      ),
      body: ValueListenableBuilder<Map<String, Chat>>(
        valueListenable: widget.socketService.chatsNotifier,
        builder: (context, chats, _) {
          final endedChats = chats.values.where((chat) => chat.ended).toList();
          final activeChats = chats.values.where((chat) => !chat.ended).toList();

          return ListView(
            children: [
              const ListTile(
                title: Text('Ativos'),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: activeChats.length,
                itemBuilder: (context, index) {
                  final chat = activeChats[index];
                  return ListTile(
                    title: Text(chat.user.name),
                    subtitle: Text(chat.user.phone),
                    trailing: chat.messageHistory.entries.last.value.status.sent != null
                    ? Text(
                        DateFormat('HH:mm').format(
                      DateTime.fromMillisecondsSinceEpoch(int.parse(chat.messageHistory.entries.last.value.status.sent!)),
                        ),
                      )
                    : null,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ChatPage(
                            user: chat.user,
                            chatUid: chat.chatUid,
                            socketService: widget.socketService,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              const ListTile(
                title: Text('Finalizados'),
                tileColor:Color.fromARGB(255, 215, 231, 252),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: endedChats.length,
                itemBuilder: (context, index) {
                  final chat = endedChats[index];
                  return ListTile(
                    title: Text(chat.user.name),
                    tileColor:const Color.fromARGB(255, 215, 231, 252),
                    subtitle: Text(chat.user.phone),
                    trailing: chat.messageHistory.entries.last.value.status.sent != null
                    ? Text(
                        DateFormat('HH:mm').format(
                          DateTime.fromMillisecondsSinceEpoch(int.parse(chat.messageHistory.entries.last.value.status.sent!)),
                        ),
                      )
                    : null,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ChatPage(
                            user: chat.user,
                            chatUid: chat.chatUid,
                            socketService: widget.socketService,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}