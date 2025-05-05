import 'package:chat_with_firebase/screens/chat_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cubits/chat_cubit/cubit/chat_cubit.dart';
import 'cubits/theme_cubit/theme_state.dart';
import 'firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/private_chat_screen.dart';
import 'services/auth_service.dart';
import 'cubits/auth_cubit/auth_cubit.dart';
import 'services/chat_service.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/reset_password_screen.dart';
import 'cubits/theme_cubit/theme_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final prefs = await SharedPreferences.getInstance();
  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;

  const MyApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthCubit(AuthService()),
        ),
        BlocProvider(
          create: (context) => ChatCubit(
            ChatService(),
            AuthService(),
          ),
        ),
        BlocProvider(
          create: (context) => ThemeCubit(prefs),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Chat App',
            themeMode: state.themeMode,
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.blue,
                brightness: Brightness.light,
              ),
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.blue,
                brightness: Brightness.dark,
              ),
            ),
            home: BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                if (state is Authenticated) {
                  return const ChatListScreen();
                } else if (state is Unauthenticated) {
                  return const LoginScreen();
                }

                return const LoginScreen();
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

                return PrivateChatScreen(
                  receiverId: receiverId,
                  receiverName: receiverName,
                );
              },
            },
          );
        },
      ),
    );
  }
}
