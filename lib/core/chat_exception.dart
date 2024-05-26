class ChatException implements Exception {
  final String message;

  ChatException(this.message);

  @override
  String toString() {
    return "ChatException: $message";
  }
}