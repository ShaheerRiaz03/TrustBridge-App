import 'dart:convert';
import 'dart:typed_data';
import 'package:course_project/Buyer%20Freelance%20Page.dart';
import 'package:course_project/Buyer%20Products%20Page.dart';
import 'package:course_project/Buyer%20Services%20only%20Page.dart';
import 'package:course_project/SellerHomePage.dart';
import 'package:course_project/Submit%20LInk%20section.dart';
import 'package:course_project/User%20Toggle%20class.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class Buyerhomepage extends StatefulWidget {
  final bool isBuyer;
  final Function(bool) onToggle;

  const Buyerhomepage({super.key, required this.isBuyer, required this.onToggle});

  @override
  State<Buyerhomepage> createState() => _BuyerhomepageState();
}

class _BuyerhomepageState extends State<Buyerhomepage> {
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

  List<Map<String, dynamic>> products = [];
  List<Map<String, dynamic>> services = [];
  String userName = '';
  String? profileImageUrl = "https://i.pravatar.cc/300";


  @override
  void initState() {
    super.initState();
    fetchServices();
    fetchUserName();
    fetchProducts();
    _loadProfilePicFromWeb();
  }


  Future<String> getUserNameFromRealtimeDB() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return 'Guest';
    final ref = FirebaseDatabase.instance.ref('users/${user.uid}');
    final snapshot = await ref.get();
    if (snapshot.exists) {
      final data = snapshot.value as Map;
      return data['name'] ?? 'No Name';
    }
    return 'No Name Found';
  }


  void fetchUserName() async {
    final name = await getUserNameFromRealtimeDB();
    setState(() => userName = name);
  }

  void fetchServices() async {
    final ref = FirebaseDatabase.instance.ref('Service');
    final snapshot = await ref.get();
    if (snapshot.exists) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);
      setState(() {
        services = data.values.map((e) => Map<String, dynamic>.from(e)).toList();
      });
    }
  }

  void fetchProducts() async {
    final ref = FirebaseDatabase.instance.ref('products');
    final snapshot = await ref.get();

    if (snapshot.exists) {
      final data = snapshot.value as Map<dynamic, dynamic>;

      List<Map<String, dynamic>> loadedProducts = [];
      Map<String, String> uidToUsername = {}; // cache usernames

      for (var userEntry in data.entries) {
        final userUID = userEntry.key as String;
        final userProducts = userEntry.value as Map<dynamic, dynamic>;

        // Get seller name once per userUID and cache it
        if (!uidToUsername.containsKey(userUID)) {
          final userSnapshot = await FirebaseDatabase.instance.ref('users/$userUID').get();
          uidToUsername[userUID] = userSnapshot.exists
              ? (userSnapshot.value as Map)['username'] ?? 'Unknown'
              : 'Unknown';
        }
        final sellerName = uidToUsername[userUID]!;

        for (var productEntry in userProducts.entries) {
          final productData = Map<String, dynamic>.from(productEntry.value);

          productData['seller'] = sellerName;

          loadedProducts.add(productData);
        }
      }

      setState(() {
        products = loadedProducts;
      });

      print('Loaded products count: ${loadedProducts.length}');
    } else {
      print('No products found in database');
    }
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
              /// Header Row
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
                  Text('Hi $userName', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  ProfileToggle(isBuyer: widget.isBuyer, onToggle: widget.onToggle),
                ],
              ),
              const SizedBox(height: 24),

              /// Freelance Services Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Popular Freelance Services', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => FreelanceBuyerPage()));
                    },
                    child: const Text("See All"),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              services.isEmpty
                  ? const Center(child: Text("No Services Yet"))
                  : SizedBox(
                height: 160,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: services.length,
                  itemBuilder: (context, index) {
                    final service = services[index];
                    return Container(
                      width: 250,
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(service['name'] ?? 'No Title', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 6),
                          Text(service['description'] ?? '', maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14, color: Colors.black54)),
                          const Spacer(),
                          Row(
                            children: [
                              const Icon(Icons.person, size: 20),
                              const SizedBox(width: 4),
                              Expanded(child: Text(service['seller'] ?? 'Unknown', overflow: TextOverflow.ellipsis)),
                              const SizedBox(width: 8),
                              Icon(Icons.star, color: Colors.orange.shade400, size: 18),
                              const Text('4.5', style: TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 32),

              /// Featured Products Grid Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Featured Products', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => BuyerProductPage()));
                    },
                    child: const Text("See All"),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              products.isEmpty
                  ? const Center(child: Text("No Products Available"))
                  : SizedBox(
                height: 280,  // adjust height as needed
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    List<dynamic> imageBase64List = product['imageBase64List'] ?? [];

                    Uint8List? imageBytes;
                    if (imageBase64List.isNotEmpty) {
                      try {
                        imageBytes = base64Decode(imageBase64List[0]);
                      } catch (e) {
                        imageBytes = null;
                        print('Error decoding image: $e');
                      }
                    }

                    return Container(
                      width: 180,  // fixed width for horizontal cards
                      margin: EdgeInsets.only(right: index == products.length - 1 ? 0 : 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                              child: imageBytes != null
                                  ? Image.memory(imageBytes, width: double.infinity, fit: BoxFit.cover)
                                  : Container(
                                color: Colors.grey[300],
                                child: const Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(product['name'] ?? 'No Name', style: const TextStyle(fontWeight: FontWeight.w600)),
                                const SizedBox(height: 4),
                                Text('PKR ${product['salePrice'] ?? 'N/A'}'),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(Icons.star, color: Colors.orange.shade400, size: 18),
                                    const SizedBox(width: 4),
                                    Text(product['rating']?.toString() ?? '0'),
                                    const Spacer(),
                                    Text(product['seller'] ?? 'Unknown', style: const TextStyle(fontSize: 12, color: Colors.black54)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              /// Link Submission Section
              SubmitLinkSection(),
            ],
          ),
        ),
      ),
    );
  }
}