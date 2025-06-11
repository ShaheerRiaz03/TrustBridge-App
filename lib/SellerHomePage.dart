import 'dart:convert';

import 'package:course_project/Add%20Product%20Page.dart';
import 'package:course_project/Seller%20Add%20Services.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:course_project/User%20Toggle%20class.dart';

class SellerHomePage extends StatefulWidget {
  final bool isBuyer;
  final Function(bool) onToggle;
  const SellerHomePage({super.key, required this.isBuyer, required this.onToggle});

  @override
  State<SellerHomePage> createState() => _SellerHomePageState();
}

class _SellerHomePageState extends State<SellerHomePage> {

  Future<void> _loadProfilePicFromWeb() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final snapshot = await FirebaseDatabase.instance
        .ref('users/${user.uid}/ProfilePic')
        .get();

    if (snapshot.exists && snapshot.value is String) {
      final base64Image = snapshot.value as String;

      try {
        final bytes = base64Decode(base64Image);

        // Save it as a data URL to show directly in NetworkImage
        setState(() {
          profileImageUrl = 'data:image/png;base64,$base64Image';
        });
      } catch (e) {
        debugPrint("❌ Failed to decode profile image: $e");
      }
    }
  }


  Future<String> getUserNameFromRealtimeDB() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return 'Guest';

    final ref = FirebaseDatabase.instance.ref('users/${user.uid}');
    final snapshot = await ref.get();

    if (snapshot.exists) {
      final data = snapshot.value as Map<dynamic, dynamic>;
      return data['name'] ?? 'No Name';
    } else {
      return 'No Name Found';
    }
  }
String userName ="";
  void fetchUserName() async {
    final name = await getUserNameFromRealtimeDB();
    setState(() {
      userName = name;
    });
  }


  String? profileImageUrl = "https://i.pravatar.cc/300";

  List<Map<String, dynamic>> products = [];
  List<Map<String, dynamic>> services = [];

  String sellerId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    fetchSellerItems();
    fetchUserName();
    _loadProfilePicFromWeb();
  }

  void fetchSellerItems() async {
    final productRef = FirebaseDatabase.instance.ref('products');
    final serviceRef = FirebaseDatabase.instance.ref('Service');

    final productSnapshot = await productRef.get();
    final serviceSnapshot = await serviceRef.get();

    List<Map<String, dynamic>> filteredProducts = [];
    List<Map<String, dynamic>> filteredServices = [];

    if (productSnapshot.exists) {
      final productData = Map<String, dynamic>.from(productSnapshot.value as Map);
      filteredProducts = productData.values
          .map((e) => Map<String, dynamic>.from(e))
          .where((item) => item['sellerId'] == sellerId)
          .toList();
    }

    if (serviceSnapshot.exists) {
      final serviceData = Map<String, dynamic>.from(serviceSnapshot.value as Map);
      filteredServices = serviceData.values
          .map((e) => Map<String, dynamic>.from(e))
          .where((item) => item['sellerId'] == sellerId)
          .toList();
    }

    setState(() {
      products = filteredProducts;
      services = filteredServices;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Row with profile and toggle
              Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: (profileImageUrl != null && profileImageUrl!.startsWith('data:image'))
                        ? MemoryImage(base64Decode(profileImageUrl!.split(',').last))
                        : NetworkImage(profileImageUrl!) as ImageProvider,
                    child: profileImageUrl == null ? const Icon(Icons.person, size: 30) : null,
                  ),
                  const SizedBox(width: 12),
                  Text('Hi $userName',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  ProfileToggle(isBuyer: widget.isBuyer, onToggle: widget.onToggle),
                ],
              ),
              const SizedBox(height: 24),

              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => ProductEntryPage()));
                    },
                    icon: const Icon(Icons.add),
                    label: const Text("Add Product"),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => ServiceEntryPage()));
                    },
                    icon: const Icon(Icons.design_services),
                    label: const Text("Add Service"),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              const Text(
                'Your Listed Products',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              products.isEmpty
                  ? const Text('No products listed yet.')
                  : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final item = products[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: item['imageUrl'] != null
                          ? Image.network(item['imageUrl'], width: 60, fit: BoxFit.cover)
                          : const Icon(Icons.image_not_supported),
                      title: Text(item['name'] ?? 'No Name'),
                      subtitle: Text(item['description'] ?? 'No Description'),
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),

              const Text(
                'Your Listed Services',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              services.isEmpty
                  ? const Text('No services listed yet.')
                  : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: services.length,
                itemBuilder: (context, index) {
                  final item = services[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: const Icon(Icons.build_circle),
                      title: Text(item['name'] ?? 'No Name'),
                      subtitle: Text(item['description'] ?? 'No Description'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
