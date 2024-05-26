import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:incognochat/controllers/auth_controller.dart';
import 'package:incognochat/controllers/current_chat_controller.dart';
import 'package:incognochat/controllers/text_field_value_controller.dart';
import 'package:incognochat/core/chat_exception.dart';
import 'package:incognochat/screens/conversation_screen.dart';
import 'package:incognochat/services/firebase/chats_service.dart';
import 'package:incognochat/widgets/qr_code_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

class AddNewChat extends ConsumerStatefulWidget {
  const AddNewChat({super.key});

  @override
  ConsumerState<AddNewChat> createState() => _AddNewChatState();
}

class _AddNewChatState extends ConsumerState<AddNewChat> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final textFieldValue = ref.watch(textFiledValueControllerProvider);
    final currentUser = ref.read(authControllerProvider.notifier).currentUser;
    if (textFieldValue != _controller.text) {
      _controller.text = textFieldValue;
    }
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Add new chat'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        ref
                            .read(textFiledValueControllerProvider.notifier)
                            .changeValue(value);
                      },
                      style: const TextStyle(decorationThickness: 0),
                      maxLines: 1,
                      controller: _controller,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Enter User ID',
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    icon: const Icon(Icons.qr_code_scanner),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const QrCodeScanner(),
                        ),
                      );
                    },
                  )
                ],
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: textFieldValue.isEmpty ? null : _addNewChat,
                child: const Text('Add Chat'),
              ),
              const SizedBox(height: 40),
              const Text('- or -'),
              const SizedBox(height: 40),
              QrImageView(
                backgroundColor: Colors.white,
                data: currentUser.uid,
                size: 160,
                errorStateBuilder: (cxt, err) {
                  return const Center(
                    child: Text(
                      'Something went wrong...',
                      textAlign: TextAlign.center,
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              Column(
                children: [
                  Text(currentUser.uid),
                  IconButton(
                    icon: const Icon(Icons.ios_share),
                    onPressed: () {
                      Share.share(currentUser.uid);
                    },
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _addNewChat() async {
    try {
      final chatModel = await ref
          .read(chatsServiceProvider)
          .getChat(ref.read(textFiledValueControllerProvider));

      ref
          .read(currentChatControllerProvider.notifier)
          .updateCurrentChat(chatModel);
    } catch (e) {
      FocusManager.instance.primaryFocus?.unfocus();
      String message = 'Something went wrong...';
      if (e is ChatException) {
        message = e.message;
      }
      if (mounted) {
        _errorDialog(context, message);
      }
      return;
    }

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (ctx) => const ConversationScreen(),
        ),
      );
    }
  }

  Future<void> _errorDialog(
    final BuildContext context,
    final String errorMeassage,
  ) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(errorMeassage),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
