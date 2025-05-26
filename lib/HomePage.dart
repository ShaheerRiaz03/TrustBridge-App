import 'package:course_project/Submit%20LInk%20section.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  // Dummy user data – replace with actual dynamic data
  String userName = "Ali";
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
    {
      'title': 'Logo Design',
      'description': 'Professional logo for your brand.',
      'user': 'Ali Khan',
      'rating': 4.8,
    },
    {
      'title': 'Website Development',
      'description': 'Build responsive websites.',
      'user': 'Sara Ahmed',
      'rating': 4.5,
    },
    {
      'title': 'Social Media Management',
      'description': 'Grow your online presence.',
      'user': 'Usman Ahmed',
      'rating': 4.9,
    },
  ];

  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
                ),
              ],
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Popular Freelance Services',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 160,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: gigs.length,
                        itemBuilder: (context, index) {
                          final gig = gigs[index];
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
                                  gig['title'],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  gig['description'],
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
                                        gig['user'],
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Icon(Icons.star, color: Colors.orange.shade400, size: 18),
                                    Text(
                                      gig['rating'].toString(),
                                      style: const TextStyle(fontWeight: FontWeight.bold),
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
    );
  }
}
