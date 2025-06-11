import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'Chat Page.dart'; // Update if needed

class ChatContactsScreen extends StatelessWidget {
  final String currentUserId;

  ChatContactsScreen({required this.currentUserId});

  final DatabaseReference _userChatsRef = FirebaseDatabase.instance.ref('userChats');
  final DatabaseReference _usersRef = FirebaseDatabase.instance.ref('users');

  Future<String> getLastMessage(String otherUserId) async {
    final snapshot = await _userChatsRef.child(currentUserId).child(otherUserId).child('lastMessage').get();
    if (snapshot.exists) {
      return snapshot.value.toString();
    } else {
      return "No messages yet";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chats"), automaticallyImplyLeading: false),
      body: StreamBuilder(
        stream: _usersRef.onValue,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
            Map data = snapshot.data!.snapshot.value as Map;
            data.remove(currentUserId); // remove current user
            final entries = data.entries.toList();

            return ListView.separated(
              itemCount: entries.length,
              separatorBuilder: (context, index) => Divider(height: 1, thickness: 0.5),
              itemBuilder: (context, index) {
                final userId = entries[index].key;
                final userInfo = entries[index].value;
                final name = userInfo['name'] ?? 'Unknown';

                return StreamBuilder<DatabaseEvent>(
                  stream: _userChatsRef.child(currentUserId).child(userId).onValue,
                  builder: (context, chatSnapshot) {
                    String lastMessage = 'No messages yet';

                    if (chatSnapshot.hasData && chatSnapshot.data!.snapshot.value != null) {
                      final data = chatSnapshot.data!.snapshot.value as Map;
                      lastMessage = data['lastMessage'] ?? 'No messages yet';
                    }

                    return ListTile(
                      leading: CircleAvatar(child: Icon(Icons.person)),
                      title: Text(name, style: TextStyle(fontWeight: FontWeight.w500)),
                      subtitle: Text(lastMessage, style: TextStyle(color: Colors.grey[700], fontSize: 13)),
                      trailing: Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChatScreen(
                              currentUserId: currentUserId,
                              otherUserId: userId,
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
            return Center(child: Text("Error loading users"));
          } else {
            return Center(child: Text("No users found"));
          }
        },
      ),
    );
  }
}
