import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:incognochat/constants/app_constants.dart';
import 'package:incognochat/controllers/auth_controller.dart';
import 'package:incognochat/controllers/current_chat_controller.dart';
import 'package:incognochat/controllers/messages_controller.dart';
import 'package:incognochat/models/message_model.dart';
import 'package:incognochat/screens/error_screen.dart';
import 'package:incognochat/screens/loading_screen.dart';
import 'package:incognochat/services/firebase/chats_service.dart';
import 'package:incognochat/widgets/messages_listview.dart';

class ConversationScreen extends ConsumerStatefulWidget {
  const ConversationScreen({super.key});

  @override
  ConsumerState<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends ConsumerState<ConversationScreen> {
  final _scrollController = ScrollController();
  final _pageBucket = PageStorageBucket();
  List<MessageModel> _currentMessages = [];
  final _renderedIndexStreamController = StreamController<int>.broadcast();

  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final currentChat = ref.watch(currentChatControllerProvider);
    final currentUser = ref.watch(authControllerProvider.notifier).currentUser;

    final title = getRecepientID(currentChat!, currentUser.uid);

    final messagesStream = ref.watch(messagesProvider);

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Column(
          children: [
            Expanded(
              child: messagesStream.when(
                data: (messages) {
                  if (messages.isEmpty) {
                    return const Center(
                      child: Text('No messages yet. Start a conversation!'),
                    );
                  }

                  _currentMessages = messages;
                  return MessagesListView(
                    currentUser: currentUser,
                    renderedIndexStreamController:
                        _renderedIndexStreamController,
                    pageStorageBucket: _pageBucket,
                    scrollController: _scrollController,
                    currentMessages: _currentMessages,
                  );
                },
                loading: () {
                  if (_currentMessages.isEmpty) {
                    return const LoadingScreen();
                  }
                  return Column(
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 20),
                      Expanded(
                        child: MessagesListView(
                          currentUser: currentUser,
                          renderedIndexStreamController:
                              _renderedIndexStreamController,
                          pageStorageBucket: _pageBucket,
                          scrollController: _scrollController,
                          currentMessages: _currentMessages,
                        ),
                      )
                    ],
                  );
                },
                error: (error, stackTrace) =>
                    ErrorScreen(errorMessage: error.toString()),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxHeight: 170.0,
                      ),
                      child: TextField(
                        style: const TextStyle(decorationThickness: 0),
                        controller: _controller,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          hintText: 'Type a message...',
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: IconButton(
                    onPressed: () async {
                      if (_controller.text.trim().isEmpty) {
                        return;
                      }
                      if (currentChat.id == null) {
                        final chatId = await ref
                            .read(chatsServiceProvider)
                            .createChat(currentChat);

                        ref
                            .read(currentChatControllerProvider.notifier)
                            .updateCurrentChatId(chatId);
                      }

                      ref
                          .read(messagesControllerProvider.notifier)
                          .sendMessage(_controller.text);
                      _controller.clear();
                    },
                    icon: const Icon(Icons.send),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _renderedIndexStreamController.stream.listen((index) {
      ref
          .read(messagesControllerProvider.notifier)
          .markAsRead(_currentMessages[index]);

      if (_currentMessages.length - index + 1 < 3) {
        final isLoading = ref
            .read(messagesControllerProvider.notifier)
            .loadNewMessages(_currentMessages.length);
        if (isLoading) {
          //Make sure scroll has ended to save position
          _scrollController.jumpTo(_scrollController.position.pixels);
        }
      }
    });
  }
}
