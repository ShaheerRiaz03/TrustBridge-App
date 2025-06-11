import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ViewSubmittedLinksPage extends StatefulWidget {
  const ViewSubmittedLinksPage({super.key});

  @override
  State<ViewSubmittedLinksPage> createState() => _ViewSubmittedLinksPageState();
}

class _ViewSubmittedLinksPageState extends State<ViewSubmittedLinksPage> {
  List<Map<String, dynamic>> _submittedLinks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchSubmittedLinks();
  }

  Future<void> _fetchSubmittedLinks() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User not logged in")),
      );
      return;
    }

    final dbRef = FirebaseDatabase.instance.ref().child('product-links').child(user.uid);
    try {
      final snapshot = await dbRef.get();

      if (snapshot.exists) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        final links = data.values.map((e) => Map<String, dynamic>.from(e)).toList();

        setState(() {
          _submittedLinks = links;
          _isLoading = false;
        });
      } else {
        setState(() {
          _submittedLinks = [];
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error loading data: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Submitted Links")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _submittedLinks.isEmpty
          ? const Center(child: Text("No submitted links found."))
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _submittedLinks.length,
        itemBuilder: (context, index) {
          final link = _submittedLinks[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: const Icon(Icons.link),
              title: Text(link['title'] ?? 'No Title'),
              subtitle: Text(link['link'] ?? ''),
              trailing: Text(
                "PKR ${link['price']?.toStringAsFixed(0) ?? '0'}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          );
        },
      ),
    );
  }
}
