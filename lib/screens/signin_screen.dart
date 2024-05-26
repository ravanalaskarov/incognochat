import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:incognochat/controllers/auth_controller.dart';
import 'package:incognochat/screens/loading_screen.dart';

class SignInScreen extends ConsumerWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(authControllerProvider);
    if (isLoading) {
      return const LoadingScreen();
    }
    return Scaffold(
      
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            ref
                .read(authControllerProvider.notifier)
                .signInAnonymously(context);
          },
          child: const Text('Anonymous login'),
        ),
      ),
    );
  }
}
