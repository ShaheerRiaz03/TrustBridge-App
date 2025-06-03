import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class ChatScreen extends StatefulWidget {
  final String currentUserId;
  final String otherUserId;

  ChatScreen({required this.currentUserId, required this.otherUserId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final DatabaseReference _messagesRef = FirebaseDatabase.instance.ref('messages');
  final DatabaseReference _usersRef = FirebaseDatabase.instance.ref('users');


  Future<void> fetchOtherUserName() async {
    try {
      final snapshot = await _usersRef.child(widget.otherUserId).child('name').get();
      if (snapshot.exists) {
        setState(() {
          otherUserName = snapshot.value.toString();
        });
      } else {
        setState(() {
          otherUserName = "Unknown User";
        });
      }
    } catch (e) {
      setState(() {
        otherUserName = "Error loading name";
      });
    }
  }


  String? otherUserName;
  late String chatId;

  @override
  void initState() {
    super.initState();
    chatId = getChatId(widget.currentUserId, widget.otherUserId);
    fetchOtherUserName();

  }

  String getChatId(String uid1, String uid2) {
    return uid1.hashCode <= uid2.hashCode ? '$uid1\_$uid2' : '$uid2\_$uid1';
  }

  void sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final text = _messageController.text.trim();
    final timestamp = ServerValue.timestamp;

    final msgRef = _messagesRef.child(chatId).push();
    msgRef.set({
      'senderId': widget.currentUserId,
      'receiverId': widget.otherUserId,
      'text': text,
      'timestamp': timestamp,
    });

    // Update userChats for sender and receiver
    final userChatsRef = FirebaseDatabase.instance.ref('userChats');
    userChatsRef.child(widget.currentUserId).child(widget.otherUserId).set({
      'lastMessage': text,
      'timestamp': timestamp,
    });
    userChatsRef.child(widget.otherUserId).child(widget.currentUserId).set({
      'lastMessage': text,
      'timestamp': timestamp,
    });

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(otherUserName ?? "Loading..."),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: _messagesRef.child(chatId).orderByChild('timestamp').onValue,
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
                  Map data = snapshot.data!.snapshot.value as Map;
                  List messages = data.entries.map((e) => e.value).toList();

                  messages.sort((a, b) => a['timestamp'].compareTo(b['timestamp']));

                  return ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[index];
                      final isMe = msg['senderId'] == widget.currentUserId;

                      return Align(
                        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          decoration: BoxDecoration(
                            color: isMe ? Colors.blue[100] : Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(msg['text']),
                        ),
                      );
                    },
                  );
                } else {
                  return Center(child: Text("No messages yet"));
                }
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: "Enter message...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: sendMessage,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
