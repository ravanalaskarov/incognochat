import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:incognochat/firebase_options.dart';
import 'package:incognochat/screens/error_screen.dart';
import 'package:incognochat/screens/loading_screen.dart';
import 'package:incognochat/widgets/auth_checker.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  runApp(const ProviderScope(child: App()));
}

final packageInitilizerProvider = FutureProvider<FirebaseApp>((ref) async {
  await initializeDateFormatting();

  return await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
});

class App extends ConsumerWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initialize = ref.watch(packageInitilizerProvider);

    return MaterialApp(
      title: 'Incogno Chat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: initialize.when(
        data: (data) => const AuthChecker(),
        error: (e, stackTrace) =>
            const ErrorScreen(errorMessage: 'Error initializing Firebase'),
        loading: () => const LoadingScreen(),
      ),
    );
  }
}
