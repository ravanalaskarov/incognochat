import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:incognochat/constants/app_constants.dart';
import 'package:incognochat/controllers/auth_controller.dart';
import 'package:incognochat/controllers/chats_controller.dart';
import 'package:incognochat/controllers/current_chat_controller.dart';
import 'package:incognochat/providers/firebaseproviders/firebase_providers.dart';
import 'package:incognochat/screens/add_new_chat.dart';
import 'package:incognochat/screens/conversation_screen.dart';
import 'package:incognochat/screens/error_screen.dart';
import 'package:incognochat/screens/loading_screen.dart';
import 'package:incognochat/services/firebase/auth_service.dart';
import 'package:incognochat/widgets/slide_screen_animation.dart';

class ChatsScreen extends ConsumerStatefulWidget {
  const ChatsScreen({super.key});

  @override
  ConsumerState<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends ConsumerState<ChatsScreen> {

  StreamSubscription? _tokenStreamSubscription;
  Future<void> _signOutDialog(
    final BuildContext context,
    final WidgetRef ref,
  ) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete account?'),
          content: const Text(
            'If you sign out, you will lose all your data. Are you sure you want to continue?',
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Sign out'),
              onPressed: () {
                ref.read(authControllerProvider.notifier).signOut();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteChatDialog(
    final BuildContext context,
    final WidgetRef ref,
    final String chatID,
  ) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete chat?'),
          content: const Text(
            'If you delete this chat, you will lose all your messages. Are you sure you want to continue?',
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Delete chat'),
              onPressed: () {
                ref.read(chatsControllerProvider.notifier).deleteChat(chatID);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }



  void _setUpFirebaseMessaging() async {
    final userUID = ref.read(authControllerProvider.notifier).currentUser.uid;
    _tokenStreamSubscription = ref.read(firebaseMessagingProvider).onTokenRefresh
    .listen((fcmToken) {
      ref.read(authServiceProvider).setNotificationToken(userUID, fcmToken);
    });

    await ref.read(firebaseMessagingProvider).requestPermission(provisional: true);

    final token = await ref.read(firebaseMessagingProvider).getToken();
    if (token == null) {
      return;
    }
    
    await ref.read(firebaseMessagingProvider).setAutoInitEnabled(true);

    await ref.read(authServiceProvider).setNotificationToken(userUID, token);
    
  }



  @override
  void initState() {
    super.initState();
    
    _setUpFirebaseMessaging();


  }

  @override
  void dispose() {
    super.dispose();
    _tokenStreamSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final chatsStream = ref.watch(chatsProvider);
        final currentUser = ref.watch(authControllerProvider.notifier).currentUser;

    return chatsStream.when(
      data: (chats) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Chats'),
            actions: [
              IconButton(
                  icon: const Icon(Icons.exit_to_app),
                  onPressed: () => _signOutDialog(context, ref)),
            ],
          ),
          body: chats.isEmpty
              ? const Center(
                  child: Text('No chats yet. Start a new chat!'),
                )
              : ListView.separated(
                  itemBuilder: (ctx, index) {
                    final chat = chats[index];
                    return ListTile(
                      onLongPress: () =>
                          _deleteChatDialog(context, ref, chat.id!),
                      onTap: () {
                        ref
                            .read(currentChatControllerProvider.notifier)
                            .updateCurrentChat(chat);

                        Navigator.push(
                          context,
                          SlidePageRoute(
                            builder: (context) => const ConversationScreen(),
                          ),
                        );
                      },
                      title: Text(getRecepientID(chat, currentUser.uid)),
                      subtitle: Text(
                        chat.lastMessage ?? 'No messages yet',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 15,
                      ),
                    );
                  },
                  separatorBuilder: (ctx, index) => const Divider(),
                  itemCount: chats.length,
                ),
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => const AddNewChat(),
                ),
              );
            },
          ),
        );
      },
      error: (error, stackTrace) =>
          const ErrorScreen(errorMessage: 'Error loading chats'),
      loading: () => const LoadingScreen(),
    );
  }
}
