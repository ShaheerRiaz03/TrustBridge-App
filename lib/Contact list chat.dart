import 'package:course_project/Chat%20Page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class ChatContactsScreen extends StatelessWidget {
  final String currentUserId;

  ChatContactsScreen({required this.currentUserId});

  final DatabaseReference _userChatsRef = FirebaseDatabase.instance.ref('userChats');
  final DatabaseReference _usersRef = FirebaseDatabase.instance.ref('users');

  // Fetch user name using UID
  Future<String> fetchUserName(String uid) async {
    final snapshot = await _usersRef.child(uid).child('name').get();
    if (snapshot.exists) {
      return snapshot.value.toString();
    } else {
      return uid; // fallback if name not found
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chats"),
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder(
        stream: _userChatsRef.child(currentUserId).orderByChild('timestamp').onValue,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
            Map data = snapshot.data!.snapshot.value as Map;
            List<MapEntry> entries = data.entries.toList();

            // Sort by latest message timestamp
            entries.sort((a, b) {
              int tsA = (a.value['timestamp'] ?? 0);
              int tsB = (b.value['timestamp'] ?? 0);
              return tsB.compareTo(tsA);
            });

            return ListView.separated(
              itemCount: entries.length,
              separatorBuilder: (context, index) => Divider(height: 1, thickness: 0.5),
              itemBuilder: (context, index) {
                final contactId = entries[index].key;
                final chatInfo = entries[index].value;
                final lastMessage = chatInfo['lastMessage'] ?? "";

                return FutureBuilder<String>(
                  future: fetchUserName(contactId),
                  builder: (context, nameSnapshot) {
                    final displayName = nameSnapshot.data ?? contactId;

                    return ListTile(
                      leading: CircleAvatar(child: Icon(Icons.person)),
                      title: Text(displayName, style: TextStyle(fontWeight: FontWeight.w500)),
                      subtitle: Text(
                        lastMessage,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChatScreen(
                              currentUserId: currentUserId,
                              otherUserId: contactId,
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("Error loading chats"));
          } else {
            return Center(child: Text("No chats yet"));
          }
        },
      ),
    );
  }
}
