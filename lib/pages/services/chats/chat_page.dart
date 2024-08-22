import 'package:dstorres_plataforma/pages/services/classes.dart';
import 'package:flutter/material.dart';
import 'package:dstorres_plataforma/services/socket_service.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatPage extends StatefulWidget {
  final User user;
  final String chatUid;  // Adicionando chatUid
  final SocketService socketService;

  const ChatPage({
    required this.user,
    required this.chatUid,
    required this.socketService,
    super.key
  });

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage(chatUid) async {
    if (_messageController.text.isNotEmpty) {
      final url = Uri.parse('https://whatsapp.dstorres.com.br/dstorres/webhook/answer');

      await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'chatUid': chatUid,"manager":"manager","message":_messageController.text}),
      );
      _messageController.clear();
    }
  }

  void _takeControll(chatUid) async{
    final url = Uri.parse('https://whatsapp.dstorres.com.br/dstorres/webhook/exitprotocol');

    await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'chatUid': chatUid}),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with ${widget.user.name}'),
      ),
      body: ValueListenableBuilder<Map<String, Chat>>(
        valueListenable: widget.socketService.chatsNotifier,
        builder: (context, chats, _) {
          final messages=[];
          messages.addAll(chats[widget.chatUid]?.messageHistory.values ?? []);
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isMyMessage = ! (message.sender == chats[widget.chatUid]?.user.name);
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      child: Column(
                        crossAxisAlignment:
                            isMyMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                        children: [
                          Text(
                            message.sender,  // Nome do remetente acima da mensagem
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isMyMessage ? Colors.blueAccent : Colors.black,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 5),
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                            decoration: BoxDecoration(
                              color: isMyMessage ? Colors.blueAccent : Colors.grey[300],
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                              message.message.text,
                              style: TextStyle(
                                color: isMyMessage ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                          Text(
                            DateFormat('HH:mm').format(
                              DateTime.fromMillisecondsSinceEpoch(int.parse(message.status.sent)),
                            ),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              if (chats[widget.chatUid] != null && chats[widget.chatUid]!.managerControlled) // Verificação da condição
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          decoration: const InputDecoration(
                            hintText: 'Type a message...',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () => _sendMessage(widget.chatUid),
                      ),
                    ],
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: 
                    TextButton(
                      onPressed: () => _takeControll(widget.chatUid),
                      child: const Text('Assumir Controle'),
                    ),
                ),
            ],
          );
        },
      ),
    );
  }
}