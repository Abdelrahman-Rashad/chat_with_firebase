import 'package:chat_with_firebase/screens/chat_list_screen.dart';
import 'package:chat_with_firebase/screens/private_chat.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubits/chat_cubit/cubit/chat_cubit.dart';
import 'firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'services/auth_service.dart';
import 'cubits/auth_cubit/auth_cubit.dart';
import 'services/chat_service.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/reset_password_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthCubit(authService),
        ),
        BlocProvider(
          create: (context) => ChatCubit(
            ChatService(),
            authService,
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Chat App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state is Authenticated) {
              return const ChatListScreen();
            }
            if (state is Unauthenticated) {
              return const LoginScreen();
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/reset-password': (context) => const ResetPasswordScreen(),
          '/chat-list': (context) => const ChatListScreen(),
          '/private-chat': (context) {
            final args = ModalRoute.of(context)!.settings.arguments as List;
            final receiverId = args[0] as String;
            final receiverName = args[1] as String;

            return PrivateChat(
              receiverId: receiverId,
              receiverName: receiverName,
            );
          },
        },
      ),
    );
  }
}
