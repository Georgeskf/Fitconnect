class ChatMessage {
  String messageContent;
  MessageType messageType;

  ChatMessage({required this.messageContent, required this.messageType});
}

enum MessageType{
  sender, receiver
}