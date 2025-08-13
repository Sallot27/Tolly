import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/message.dart';

class ChatService {
  // A mock list of messages to simulate a database.
  final List<MessageModel> _messages = [
    MessageModel(
      id: '1',
      senderId: 'other-user-id-123',
      text: 'Hi, is the lawn mower still available?',
      timestamp: Timestamp.fromDate(DateTime.now().subtract(const Duration(minutes: 5))),
    ),
    MessageModel(
      id: '2',
      senderId: 'current-user-id-456',
      text: 'Yes, it is! When would you like to borrow it?',
      timestamp: Timestamp.fromDate(DateTime.now().subtract(const Duration(minutes: 4))),
    ),
    MessageModel(
      id: '3',
      senderId: 'other-user-id-123',
      text: 'Great. I was thinking of borrowing it for the weekend.',
      timestamp: Timestamp.fromDate(DateTime.now().subtract(const Duration(minutes: 3))),
    ),
  ];

  // A stream controller to simulate real-time updates.
  final StreamController<List<MessageModel>> _messagesController =
      StreamController<List<MessageModel>>.broadcast();

  ChatService() {
    // Initial data for the stream
    _messagesController.add(_messages);
  }

  // Returns a stream of messages for a given chat room.
  // In a real app, this would be a Firestore snapshot stream.
  Stream<List<MessageModel>> getMessages(String chatRoomId) {
    return _messagesController.stream;
  }

  // Adds a new message to the mock list and updates the stream.
  Future<void> sendMessage(MessageModel message) async {
    // In a real app, you would add the message to a Firestore collection.
    _messages.add(message);
    _messagesController.add(_messages);
  }

  void dispose() {
    _messagesController.close();
  }
}
