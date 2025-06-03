import 'package:flutter/material.dart';

class ServiceDetailPage extends StatelessWidget {
  final Map<String, dynamic> service;

  const ServiceDetailPage({Key? key, required this.service}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isVerified = service['verified'] == true;

    return Scaffold(
      appBar: AppBar(
        title: Text(service['title'] ?? 'Service Details'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Service Card
            Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      service['title'] ?? 'Untitled',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "PKR ${service['price']}",
                      style: TextStyle(fontSize: 20, color: Colors.green[700]),
                    ),
                    SizedBox(height: 10),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.person, color: Colors.grey[700]),
                      title: Text(service['seller'] ?? 'Unknown Seller'),
                      subtitle: isVerified
                          ? Row(
                        children: [
                          Icon(Icons.verified, color: Colors.blue, size: 16),
                          SizedBox(width: 5),
                          Text("Verified Seller", style: TextStyle(color: Colors.blue)),
                        ],
                      )
                          : Text("Not Verified", style: TextStyle(color: Colors.red)),
                    ),
                    Divider(),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Description",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      service['description'] ?? '',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // TODO: implement order functionality
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Order request sent!')),
                    );
                  },
                  icon: Icon(Icons.shopping_cart),
                  label: Text('Order Service'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // TODO: implement chat functionality
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Chat feature coming soon!')),
                    );
                  },
                  icon: Icon(Icons.chat),
                  label: Text('Chat with Seller'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
