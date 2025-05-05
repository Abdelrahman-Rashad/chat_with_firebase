// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/auth_cubit/auth_cubit.dart';
import '../cubits/chat_cubit/cubit/chat_cubit.dart';

class PrivateChat extends StatelessWidget {
  PrivateChat({
    Key? key,
    required this.receiverId,
    required this.receiverName,
  }) : super(key: key);
  final String receiverId;
  final String receiverName;
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.read<ChatCubit>().getUsers();
        return true;
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text('Chat with ${receiverName}'),
          ),
          body: Column(
            children: [
              Expanded(child: BlocBuilder<ChatCubit, ChatState>(
                builder: (context, state) {
                  if (state is ChatMessagesLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ChatMessagesLoaded) {
                    return ListView.builder(
                        itemCount: state.messages.length,
                        itemBuilder: (context, index) {
                          return messageStyle(state, index, context);
                        });
                  }
                  return const SizedBox.shrink();
                },
              )),
              Row(
                children: [
                  Expanded(
                      child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                    ),
                    controller: _messageController,
                  )),
                  IconButton(
                      onPressed: () {
                        context
                            .read<ChatCubit>()
                            .sendMessage(receiverId, _messageController.text);
                      },
                      icon: Icon(Icons.send))
                ],
              )
            ],
          )),
    );
  }

  Widget messageStyle(
      ChatMessagesLoaded state, int index, BuildContext context) {
    final currentUser = context.read<AuthCubit>().currentUser;
    Alignment alignment = state.messages[index].senderId == currentUser.uid
        ? Alignment.centerRight
        : Alignment.centerLeft;
    return Align(
        alignment: alignment,
        child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            padding: const EdgeInsets.all(8),
            child: Text(state.messages[index].content)));
  }
}
