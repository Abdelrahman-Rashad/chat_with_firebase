// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:chat_with_firebase/models/user_model.dart';
import 'package:chat_with_firebase/services/chat_service.dart';

import '../../../models/message_model.dart';
import '../../../services/auth_service.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatService _chatService;
  final AuthService _authService;
  ChatCubit(
    this._chatService,
    this._authService,
  ) : super(ChatInitial()) {
    init();
  }

  init() {
    getUsers();
  }

  void getUsers() {
    emit(ChatLoading());
    try {
      _chatService.getUsersStream().listen((userList) {
        emit(ChatLoaded(userList));
      });
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  void sendMessage(String receiverId, String messageContent) {
    try {
      emit(ChatSending());
      _chatService.sendMessage(
          receiverId, messageContent, _authService.currentUser!.uid);
      emit(ChatSent());
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  void getMessages(String userId2) {
    emit(ChatMessagesLoading());
    try {
      _chatService
          .getMessagesStream(_authService.currentUser!.uid, userId2)
          .listen((messages) {
        emit(ChatMessagesLoaded(messages));
      });
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }
}
