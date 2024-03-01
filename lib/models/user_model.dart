class UserModel {
  UserModel({
    required this.uid,
    required this.userName,
    required this.phoneNo,
    required this.active,
    required this.messageList,
  });
  late final String uid;
  late final String userName;
  late final String phoneNo;
  late final bool active;
  late List<Message> messageList;

  UserModel.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    userName = json['userName'];
    phoneNo = json['phoneNo'] ?? "";
    active = json['active'];
    messageList =
        List.from(json['messageList']).map((e) => Message.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['uid'] = uid;
    data['userName'] = userName;
    data['phoneNo'] = phoneNo;
    data['active'] = active;
    data['messageList'] = messageList.map((e) => e.toJson()).toList();
    return data;
  }
}

class Message {
  Message({
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.isSent,
    required this.seen,
    required this.time,
  });
  late final String senderId;
  late final String receiverId;
  late final String text;
  late final bool isSent;
  late final bool seen;
  late final String time;

  Message.fromJson(Map<String, dynamic> json) {
    senderId = json['senderId'];
    receiverId = json['receiverId'];
    text = json['text'];
    isSent = json['isSent'];
    seen = json['seen'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['senderId'] = senderId;
    data['receiverId'] = receiverId;
    data['text'] = text;
    data['isSent'] = isSent;
    data['seen'] = seen;
    data['time'] = time;
    return data;
  }
}
