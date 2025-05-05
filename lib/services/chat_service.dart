import 'package:chat_with_firebase/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/message_model.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<UserFirebase>> getUsersStream() {
    return _firestore.collection('users').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => UserFirebase.fromMap(doc.data())).toList());
  }

  Future<void> sendMessage(
      String receiverId, String messageContent, String senderId) async {
    MessageModel message = MessageModel(
      senderId: senderId,
      receiverId: receiverId,
      content: messageContent,
      timestamp: Timestamp.now().toDate(),
    );

    List<String> chatIds = [senderId, receiverId];
    chatIds.sort();
    final chatId = chatIds.join('_');

    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add(message.toMap());
  }

  Stream<List<MessageModel>> getMessagesStream(String userId1, String userId2) {
    List<String> chatIds = [userId1, userId2];
    chatIds.sort();
    final chatId = chatIds.join('_');

    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MessageModel.fromFirestore(doc))
            .toList());
  }
}
