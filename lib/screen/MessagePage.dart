import 'package:avatar_stack/avatar_stack.dart';
import 'package:avatar_stack/positions.dart';
import 'package:flutter/material.dart';
import 'package:chat/data/message.dart';
import 'package:chat/data/message_dao.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

import '../component/MessageWidget.dart';

class MessagePage extends StatefulWidget {
  MessagePage({Key? key}) : super(key: key);

  final messageDAO = MessageDAO();

  @override
  MessagePageState createState() => MessagePageState();
}

class MessagePageState extends State<MessagePage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final settings = RestrictedAmountPositions(
      maxAmountItems: 4,
      maxCoverage: 0.9,
      minCoverage: 0.3,
      align: StackAlign.left,
    );
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _scrollDown();
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Expanded(
              child: AvatarStack(
                settings: settings,
                height: 40,
                avatars: [
                  for (var n = 0; n < 4; n++)
                    NetworkImage('https://i.pravatar.cc/150?img=$n'),
                ],
              ),
            ),
            const Text("last seen 45 seconds ago"),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _getListMessage(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: TextField(
                      keyboardType: TextInputType.text,
                      controller: _textEditingController,
                      onSubmitted: (input) {
                        _sendMessage();
                      },
                      decoration: const InputDecoration(
                        hintText: 'Start typing...',
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _sendMessage,
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage() {
    if (_checkTheMessage()) {
      final message = Message(
        _textEditingController.text,
        DateTime.now(),
      );
      widget.messageDAO.saveMessage(message);
      setState(() {
        _textEditingController.clear();
      });
    }
  }

  bool _checkTheMessage() => _textEditingController.text.isNotEmpty;

  Widget _getListMessage() {
    return Expanded(
      child: FirebaseAnimatedList(
        controller: _scrollController,
        query: widget.messageDAO.getMessages(),
        itemBuilder: (context, snapshot, animation, index) {
          final json = snapshot.value as Map<dynamic, dynamic>;
          final message = Message.fromJson(json);
          return MessageWidget(
            message.createdAt,
            message.text,
          );
        },
      ),
    );
  }

  void _scrollDown() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }
}
