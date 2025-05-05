part of 'chat_cubit.dart';

sealed class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

final class ChatInitial extends ChatState {}

final class ChatLoading extends ChatState {}

final class ChatSending extends ChatState {}

final class ChatSent extends ChatState {}

final class ChatMessagesLoaded extends ChatState {
  final List<MessageModel> messages;
  const ChatMessagesLoaded(this.messages);

  @override
  List<Object> get props => [messages];
}

final class ChatMessagesLoading extends ChatState {}

final class ChatLoaded extends ChatState {
  final List<UserFirebase> users;
  const ChatLoaded(this.users);

  @override
  List<Object> get props => [users];
}

final class ChatError extends ChatState {
  final String message;
  const ChatError(this.message);

  @override
  List<Object> get props => [message];
}
