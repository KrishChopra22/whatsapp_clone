import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../theme/custom_theme_extension.dart';

import '../global_vars.dart';
import '../models/user_model.dart';
import '../utils/colours.dart';
import '../widgets/chat_text_field.dart';
import '../widgets/custom_icon_button.dart';
import '../widgets/message_card.dart';

class ChatPage extends StatefulWidget {
  const ChatPage(
      {super.key, required this.receiverId, required this.receiverName});
  final String receiverId;
  final String receiverName;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late final Stream<DocumentSnapshot<Map<String, dynamic>>> _userStream =
      FirebaseFirestore.instance.collection('Users').doc(globalUID).snapshots();
  final ScrollController scrollController = ScrollController();
  bool needsScroll = true;

  Future<void> scrollToBottom() async {
    await Future.delayed(const Duration(milliseconds: 100));
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  // void getMessages() async {
  //   await FirebaseFirestore.instance
  //       .collection("Users")
  //       .doc(globalUID)
  //       .get()
  //       .then((docSnap) {
  //     var user = UserModel.fromJson(docSnap.data() as Map<String, dynamic>);
  //     for (var item in user.messageList) {
  //       msgList.add(item);
  //     }
  //   });
  // }
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.chatPageBgColor,
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          borderRadius: BorderRadius.circular(40),
          child: const Row(
            children: [
              Icon(Icons.arrow_back),
              Spacer(),
              Hero(
                tag: 'profile',
                child: CircleAvatar(
                  backgroundColor: Colours.greyDark,
                  radius: 16,
                  child: Icon(
                    Icons.person_rounded,
                    color: Colours.backgroundLight,
                    size: 25,
                  ),
                ),
              ),
            ],
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.receiverName,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              const Text(
                "online",
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w400),
              )
            ],
          ),
        ),
        actions: [
          CustomIconButton(
            onPressed: () {},
            icon: Icons.videocam_rounded,
            iconColor: Colors.white,
          ),
          CustomIconButton(
            onPressed: () {},
            icon: Icons.call_rounded,
            iconColor: Colors.white,
          ),
          CustomIconButton(
            onPressed: () {},
            icon: Icons.more_vert,
            iconColor: Colors.white,
          ),
        ],
      ),
      body: Stack(children: [
        // chat background image
        Image(
          height: double.maxFinite,
          width: double.maxFinite,
          image: const AssetImage('assets/images/doodle_bg.png'),
          fit: BoxFit.cover,
          color: context.theme.chatPageDoodleColor,
        ),
        StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: _userStream,
          builder: (context,
              AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong'));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colours.greenDark,
                ),
              );
            }

            UserModel user = UserModel.fromJson(
                snapshot.data!.data() as Map<String, dynamic>);
            List<Message> msgList = [];
            for (Message msg in user.messageList) {
              if ((msg.senderId == globalUID &&
                      msg.receiverId == widget.receiverId) ||
                  (msg.senderId == widget.receiverId &&
                      msg.receiverId == globalUID)) msgList.add(msg);
            }

            return SingleChildScrollView(
              controller: scrollController,
              child: Column(
                children: [
                  ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: msgList.length,
                      shrinkWrap: true,
                      itemBuilder: (_, index) {
                        if (needsScroll) {
                          scrollToBottom();
                          needsScroll = false;
                        }
                        return Column(
                          children: [
                            MessageCard(
                              message: msgList[index],
                            ),
                          ],
                        );
                      }),
                  const SizedBox(
                    height: 60,
                  )
                ],
              ),
            );
          },
        ),
        Container(
          alignment: const Alignment(0, 1),
          child: ChatTextField(
            receiverId: widget.receiverId,
            scrollController: scrollController,
          ),
        ),
      ]),
    );
  }
}
