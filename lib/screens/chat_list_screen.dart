import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/auth_cubit/auth_cubit.dart';
import '../cubits/chat_cubit/cubit/chat_cubit.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Chats'), actions: [
          IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                context.read<AuthCubit>().signOut();
              })
        ]),
        body: displayAllChatsList());
  }

  BlocBuilder<ChatCubit, ChatState> displayAllChatsList() {
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        if (state is ChatLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ChatLoaded) {
          final authState = context.read<AuthCubit>().state;
          if (authState is! Authenticated) {
            return const Text('User not authenticated');
          }

          // Filter out the current user from the chat list
          final currentUserEmail = authState.userFirebase.email;
          final otherUsers = state.users
              .where((user) => user.email != currentUserEmail)
              .toList();

          return ListView.builder(
            itemCount: otherUsers.length,
            itemBuilder: (context, index) {
              final user = otherUsers[index];
              return GestureDetector(
                  onTap: () {
                    context.read<ChatCubit>().getMessages(user.uid);
                    Navigator.pushNamed(context, '/private-chat',
                        arguments: [user.uid, user.name]);
                  },
                  child: ListTile(title: Text(user.name)));
            },
          );
        } else if (state is ChatError) {
          return Text('Error: ${state.message}');
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
