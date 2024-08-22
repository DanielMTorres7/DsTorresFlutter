import 'package:dstorres_plataforma/pages/services/classes.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/foundation.dart';

class SocketService {
  IO.Socket? _socket;

  IO.Socket get socket => _socket!;
  final ValueNotifier<Map<String, Chat>> chats = ValueNotifier<Map<String, Chat>>({});

  ValueNotifier<Map<String, Chat>> get chatsNotifier => chats;

  void connect() {
    _socket = IO.io('https://whatsapp.dstorres.com.br', IO.OptionBuilder()
        .setTransports(['websocket'])
        .enableForceNew()
        .build());

    _socket!.on('connect', (_) {
      print('Connected to Socket.IO');
      socket.emit('managerConnection', { "empresa":"dstorres", "manager":"manager" });
      // Emit authentication token or handle it here
    });

    _socket!.on('disconnect', (_) {
      print('Disconnected from Socket.IO');
    });

    _socket!.on('error', (error) {
      print('Socket.IO error: $error');
    });


    _socket!.on('updateChat', (data) {
      final updatedChats = ManagerConversations.fromJson(data).chats;
      // Cria uma nova lista de chats, movendo os chats atualizados para o topo
      chats.value = {
        ...updatedChats,
        ...chats.value..removeWhere((key, _) => updatedChats.containsKey(key)),
      };
    });
    _socket!.on('forceUpdateChat', (data) {
      final updatedChats = ManagerConversations.fromJson(data).chats;
      // Cria uma nova lista de chats, movendo os chats atualizados para o topo
      chats.value = {...updatedChats};
    });
  }

  void disconnect() {
    _socket?.disconnect();
  }
}