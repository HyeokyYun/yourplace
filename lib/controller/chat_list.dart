class Chat {
  final String message;
  final bool sent;

  Chat({required this.message, required this.sent});

  factory Chat.sent({required message}) => Chat(message: message, sent: true);
}
