import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:incognochat/controllers/auth_controller.dart';
import 'package:incognochat/screens/chats_screen.dart';
import 'package:incognochat/screens/error_screen.dart';
import 'package:incognochat/screens/loading_screen.dart';
import 'package:incognochat/screens/signin_screen.dart';

class AuthChecker extends ConsumerWidget {
  const AuthChecker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateChangeProvider);

    return authState.when(
      data: (user) {
        if (user == null) {
          return const SignInScreen();
        }
        return const ChatsScreen();
      },
      loading: () => const LoadingScreen(),
      error: (e, trace) =>  const ErrorScreen(errorMessage: 'Error authenticating user'),
    );
  }
}
