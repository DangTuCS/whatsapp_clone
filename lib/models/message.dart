import 'package:whatsapp_ui/common/enums/message_enum.dart';

class Message {
  final String senderId;
  final String receiverId;
  final String text;
  final MessageEnum type;
  final DateTime timeSent;
  final String messageId;
  final bool isSeen;
  final String repliedMessage;
  final String repliedTo;
  final MessageEnum repliedMessageType;

  Message({
    required this.repliedMessage,
    required this.repliedTo,
    required this.repliedMessageType,
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.type,
    required this.timeSent,
    required this.messageId,
    required this.isSeen,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      senderId: json["senderId"],
      receiverId: json["receiverId"],
      text: json["text"],
      type: (json["type"] as String).toEnum(),
      timeSent: DateTime.parse(json["timeSent"]),
      messageId: json["messageId"],
      isSeen: json["isSeen"],
      repliedMessage: json["repliedMessage"],
      repliedTo: json["repliedTo"],
      repliedMessageType: (json["repliedMessageType"] as String).toEnum(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "senderId": senderId,
      "receiverId": receiverId,
      "text": text,
      "type": type.type,
      "timeSent": timeSent.toIso8601String(),
      "messageId": messageId,
      "isSeen": isSeen,
      "repliedMessage": repliedMessage,
      "repliedTo": repliedTo,
      "repliedMessageType": repliedMessageType.type,
    };
  }

}
