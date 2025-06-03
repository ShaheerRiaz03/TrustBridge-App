import 'package:course_project/Buyer%20Freelance%20Page.dart';
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
  const Buyerhomepage({super.key,required this.isBuyer, required this.onToggle});

  @override
  State<Buyerhomepage> createState() => _BuyerhomepageState();

}

class _BuyerhomepageState extends State<Buyerhomepage> {
  List<Map<String, dynamic>> services = [];
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
  String userName='';
  void fetchUserName() async {
    final name = await getUserNameFromRealtimeDB();
    setState(() {
      userName = name;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchServices();
    fetchUserName();
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
  // Dummy user data – replace with actual dynamic data
  String? profileImageUrl =
      "https://i.pravatar.cc/300"; // Replace with null to test no image case

  @override

  final List<Map<String, dynamic>> products = const [
    {
      'image':
      'https://images.unsplash.com/photo-1606813902894-044ec15f5c78?auto=format&fit=crop&w=300&q=80',
      'title': 'Wireless Headphones',
      'rating': 4.7,
      'seller': 'TechWorld'
    },
    {
      'image':
      'https://images.unsplash.com/photo-1571689936040-c3f0e61ec006?auto=format&fit=crop&w=300&q=80',
      'title': 'Modern Chair',
      'rating': 4.5,
      'seller': 'FurniPro'
    },
    {
      'image':
      'https://images.unsplash.com/photo-1555617980-047b39bcd4b1?auto=format&fit=crop&w=300&q=80',
      'title': 'Smart Watch',
      'rating': 4.8,
      'seller': 'GadgetZone'
    },
  ];
  final List<Map<String, dynamic>> gigs = const [
  ];

  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Row(
                children: [
                  const SizedBox(width: 20),
                  Container(
                    height: 50,
                    width: 150,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                          ),
                          child: CircleAvatar(
                            radius: 20,
                            backgroundImage: profileImageUrl != null
                                ? NetworkImage(profileImageUrl!)
                                : null,
                            child: profileImageUrl == null
                                ? const Icon(Icons.person, color: Colors.white)
                                : null,
                            backgroundColor:
                            profileImageUrl == null ? Colors.blueGrey : null,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Hi $userName',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                      ],
                    ),
                  ),SizedBox(width: 20,)
            ,Expanded(
                    child: Align(
                      alignment: Alignment.topRight,
                      child: ProfileToggle(
                        isBuyer: widget.isBuyer,
                        onToggle: widget.onToggle,
                      ),
                    ),
                  ),
                  SizedBox(width: 20,)
                ],
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Popular Freelance Services',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => FreelanceBuyerPage(),
                                ),
                              );
                            },
                            child: const Text("See All"),
                          )
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
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 4,
                                    offset: const Offset(2, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    service['name'] ?? 'No Title',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    service['description'] ?? '',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  const Spacer(),
                                  Row(
                                    children: [
                                      const Icon(Icons.person, size: 20),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          service['seller'] ?? 'Unknown',
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Icon(Icons.star,
                                          color: Colors.orange.shade400, size: 18),
                                      Text(
                                        '4.5',
                                        style:
                                        const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Text(
              'Featured Products',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              SizedBox(
              height: 240,
              child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: products.length,
              itemBuilder: (context, index) {
              final product = products[index];
              return Container(
              width: 180,
              margin: const EdgeInsets.only(right: 12),
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
              // Product Image
              Expanded(
              child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
              top: Radius.circular(12)),
              child: Image.network(
              product['image'],
              width: double.infinity,
              fit: BoxFit.cover,
              ),
              ),
              ),
              Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Text(product['title'],
              style: const TextStyle(
              fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Row(
              children: [
              Icon(Icons.star,
              color: Colors.orange.shade400, size: 18),
              const SizedBox(width: 4),
              Text(product['rating'].toString()),
              const Spacer(),
              Text(product['seller'],
              style: const TextStyle(
              fontSize: 12,
              color: Colors.black54)),
              ],
              ),
              ],
              ),
              ),
              ],
              ),
              );
              },
              ),),
              SubmitLinkSection(),
            ],
          ),
        ),
      ),
    );
  }
}
