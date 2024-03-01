import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../global_vars.dart';
import '../models/user_model.dart';
import '../theme/custom_theme_extension.dart';
import '../utils/colours.dart';
import 'custom_icon_button.dart';

class ChatTextField extends StatefulWidget {
  const ChatTextField(
      {super.key, required this.scrollController, required this.receiverId});
  final ScrollController scrollController;
  final String receiverId;

  @override
  State<ChatTextField> createState() => _ChatTextFieldState();
}

class _ChatTextFieldState extends State<ChatTextField> {
  late TextEditingController messageController;
  bool isMessageIconEnabled = false;
  double cardHeight = 0;

  void sendTextMessage() async {
    if (isMessageIconEnabled) {
      saveMessage(
          receiverId: widget.receiverId,
          textMessage: messageController.text,
          timeSent: DateTime.now().toString().substring(11, 16));
      messageController.clear();
    }

    await Future.delayed(const Duration(milliseconds: 100));
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      widget.scrollController.animateTo(
        widget.scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void saveMessage({
    required String receiverId,
    required String textMessage,
    required String timeSent,
  }) async {
    final senderMsg = Message(
      senderId: globalUID,
      receiverId: receiverId,
      text: textMessage,
      isSent: true,
      time: timeSent,
      seen: false,
    );
    final receiverMsg = Message(
      senderId: globalUID,
      receiverId: receiverId,
      text: textMessage,
      isSent: false,
      time: timeSent,
      seen: false,
    );

    // update sender
    final senderSnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(globalUID)
        .get();
    UserModel sender = UserModel.fromJson(senderSnapshot.data()!);
    sender.messageList.add(senderMsg);
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(globalUID)
        .set(sender.toJson());

    if (receiverId == globalUID) return; // send only once to ownself
    // update receiver
    final receiverSnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(receiverId)
        .get();
    UserModel receiver = UserModel.fromJson(receiverSnapshot.data()!);
    receiver.messageList.add(receiverMsg);
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(receiverId)
        .set(receiver.toJson());
  }

  iconWithText({
    required VoidCallback onPressed,
    required IconData icon,
    required String text,
    required Color background,
  }) {
    return Column(
      children: [
        CustomIconButton(
          onPressed: onPressed,
          icon: icon,
          background: background,
          minWidth: 50,
          iconColor: Colors.white,
          border: Border.all(
            color: context.theme.greyColor!.withOpacity(.2),
            width: 1,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          text,
          style: TextStyle(
            color: context.theme.greyColor,
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    messageController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: cardHeight,
          width: double.maxFinite,
          margin: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: context.theme.receiverChatCardBg,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      iconWithText(
                        onPressed: () {},
                        icon: Icons.book_rounded,
                        text: 'File',
                        background: const Color(0xFF7F66FE),
                      ),
                      iconWithText(
                        onPressed: () {},
                        icon: Icons.camera_alt_rounded,
                        text: 'Camera',
                        background: const Color(0xFFFE2E74),
                      ),
                      iconWithText(
                        onPressed: () {},
                        icon: Icons.photo_rounded,
                        text: 'Gallery',
                        background: const Color(0xFFC861F9),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      iconWithText(
                        onPressed: () {},
                        icon: Icons.headphones_rounded,
                        text: 'Audio',
                        background: const Color(0xFFF96533),
                      ),
                      iconWithText(
                        onPressed: () {},
                        icon: Icons.location_on_rounded,
                        text: 'Location',
                        background: const Color(0xFF1FA855),
                      ),
                      iconWithText(
                        onPressed: () {},
                        icon: Icons.person_rounded,
                        text: 'Contact',
                        background: const Color(0xFF009DE1),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: messageController,
                  maxLines: 4,
                  minLines: 1,
                  onChanged: (value) {
                    value.isEmpty
                        ? setState(() => isMessageIconEnabled = false)
                        : setState(() => isMessageIconEnabled = true);
                  },
                  decoration: InputDecoration(
                    hintText: 'Message',
                    hintStyle: TextStyle(color: context.theme.greyColor),
                    filled: true,
                    fillColor: context.theme.chatTextFieldBg,
                    isDense: true,
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                        style: BorderStyle.none,
                        width: 0,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    prefixIcon: Material(
                      color: Colors.transparent,
                      child: CustomIconButton(
                        onPressed: () {},
                        icon: Icons.emoji_emotions_rounded,
                        iconColor: Theme.of(context).listTileTheme.iconColor,
                      ),
                    ),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        RotatedBox(
                          quarterTurns: 45,
                          child: CustomIconButton(
                            onPressed: () => setState(
                              () => cardHeight == 0
                                  ? cardHeight = 220
                                  : cardHeight = 0,
                            ),
                            icon: cardHeight == 0
                                ? Icons.attach_file_rounded
                                : Icons.close,
                            iconColor:
                                Theme.of(context).listTileTheme.iconColor,
                          ),
                        ),
                        CustomIconButton(
                          onPressed: () {},
                          icon: Icons.camera_alt_rounded,
                          iconColor: Theme.of(context).listTileTheme.iconColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 5),
              CustomIconButton(
                onPressed: sendTextMessage,
                icon: isMessageIconEnabled
                    ? Icons.send_rounded
                    : Icons.mic_rounded,
                background: Colours.greenDark,
                iconColor: Colors.white,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
