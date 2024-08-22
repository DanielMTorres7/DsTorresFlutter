class ManagerConversations {
  final Map<String, Chat> chats;

  ManagerConversations({required this.chats});

  factory ManagerConversations.fromJson(Map<String, dynamic> json) {
    return ManagerConversations(
      chats: (json['chats'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, Chat.fromJson(key, value)),
      ),
    );
  }
}

class Chat {
  final String chatUid;  // Adicionando chatUid
  final User user;
  final bool managerControlled;
  final bool ended;
  final Map<String, IAppMessage> messageHistory;

  Chat({
    required this.chatUid,  // Incluindo chatUid no construtor
    required this.user,
    required this.ended,
    required this.managerControlled,
    required this.messageHistory,
  });

  factory Chat.fromJson(uid, Map<String, dynamic> json) {
    return Chat(
      chatUid: uid,
      managerControlled: json['managerControlled'],
      user: User.fromJson(json['User']),
      ended: json['ended'],
      messageHistory: (json['MessageHistory'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, IAppMessage.fromJson(value)),
      ),
    );
  }
}

class User {
  final String userUid;
  final String name;
  final String phone;

  User({required this.userUid, required this.name, required this.phone});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userUid: json['userUid'],
      name: json['name'],
      phone: json['phone'],
    );
  }
}



class Message {
  final String text;
  final String status;

  Message({required this.text, required this.status});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      text: json['text'],
      status: json['status'],
    );
  }
}

class IMessageStatus {
  final String? sent;
  final String? received;
  final String? read;

  IMessageStatus({this.sent, this.received, this.read});

  factory IMessageStatus.fromJson(Map<String, dynamic> json) {
    return IMessageStatus(
      sent: json['sent'] as String?,
      received: json['received'] as String?,
      read: json['read'] as String?,
    );
  }
}




class IAppMessage {
  final String sender;
  final Message message;
  final IMessageStatus status;

  IAppMessage({required this.sender, required this.message, required this.status});

  factory IAppMessage.fromJson(Map<String, dynamic> json) {
    return IAppMessage(
      sender: json['sender'],
      message: Message.fromJson(json['message']),
      status: IMessageStatus.fromJson(json['status']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sender': sender,
      'message': {
        'text': message.text,
        'status': message.status,
      },
      'status': {
        'sent': status.sent,
        'received': status.received,
        'read': status.read,
      },
    };
  }
}