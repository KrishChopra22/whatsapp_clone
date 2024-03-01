import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_clone/global_vars.dart';

import '../chat/chat_page.dart';
import '../models/user_model.dart';
import '../utils/colours.dart';
import '../widgets/contact_card.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  List<UserModel> usersList = [];
  Future<List<UserModel>> fetchUsers() async {
    final snapshot = await FirebaseFirestore.instance.collection('Users').get();
    return snapshot.docs
        .map(
          (doc) => UserModel.fromJson(doc.data()),
        )
        .toList();
  }

  @override
  void initState() {
    usersList.clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: fetchUsers(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                // usersList = snapshot.data!;
                usersList.clear();
                for (var item in snapshot.data!) {
                  if (item.uid == globalUID) {
                    usersList.insert(0, item);
                  } else {
                    usersList.add(item);
                  }
                }
                return ListView.builder(
                    itemCount: usersList.length,
                    itemBuilder: (context, index) {
                      return ContactCard(
                          contact: usersList[index],
                          onTap: () =>
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ChatPage(
                                        receiverId: usersList[index].uid,
                                        receiverName: usersList[index].userName,
                                      ))));
                    });
              } else {
                return const Center(
                  child: Text('No Contacts to show'),
                );
              }
            }
            return const Center(
                child: CircularProgressIndicator(
              color: Colours.greenDark,
            ));
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.chat),
      ),
    );
  }
}
