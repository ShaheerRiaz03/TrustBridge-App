import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class BuyerProductPage extends StatefulWidget {
  @override
  _BuyerProductPageState createState() => _BuyerProductPageState();
}

class _BuyerProductPageState extends State<BuyerProductPage> {
  final DatabaseReference _productsRef = FirebaseDatabase.instance.ref("products");
  final DatabaseReference _usersRef = FirebaseDatabase.instance.ref("users");

  List<Map<String, dynamic>> products = [];
  Map<String, String> uidToUsername = {};

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    await fetchUsernames();
    await fetchProducts();
  }

  Future<void> fetchUsernames() async {
    final snapshot = await _usersRef.get();
    if (snapshot.exists) {
      final Map data = snapshot.value as Map;
      data.forEach((uid, userInfo) {
        if (userInfo is Map && userInfo['username'] != null) {
          uidToUsername[uid] = userInfo['username'];
        }
      });
    }
  }

  Future<void> fetchProducts() async {
    final snapshot = await _productsRef.get();
    if (snapshot.exists) {
      final Map data = snapshot.value as Map;
      final List<Map<String, dynamic>> loadedProducts = [];

      data.forEach((uid, userProducts) {
        if (userProducts is Map) {
          userProducts.forEach((pid, productData) {
            final item = Map<String, dynamic>.from(productData);
            final sellerUid = item['uid'];
            final sellerName = uidToUsername[sellerUid] ?? 'Unknown Seller';

            loadedProducts.add({
              'name': item['name'] ?? 'No Name',
              'price': item['salePrice'] ?? 0,
              'imageBase64List': item['imageBase64List'] ?? [],
              'seller': sellerName,
              'isVerified': true, // Add real verification logic later
            });
          });
        }
      });

      setState(() {
        products = loadedProducts;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Available Products')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: products.isEmpty
            ? Center(child: CircularProgressIndicator())
            : GridView.builder(
          itemCount: products.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.7,
          ),
          itemBuilder: (context, index) {
            final product = products[index];
            final imageBytes = product['imageBase64List'].isNotEmpty
                ? base64Decode(product['imageBase64List'][0])
                : null;

            return GestureDetector(
              onTap: () {},
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius:
                      BorderRadius.vertical(top: Radius.circular(12)),
                      child: SizedBox(
                        height: 130,
                        width: double.infinity,
                        child: imageBytes != null
                            ? Image.memory(imageBytes, fit: BoxFit.cover)
                            : Container(
                          color: Colors.grey[300],
                          child: Icon(Icons.image_not_supported),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product['name'],
                            style: TextStyle(fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4),
                          Text("Seller: ${product['seller']}",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600])),
                          Text("PKR ${product['price']}",
                              style:
                              TextStyle(fontWeight: FontWeight.bold)),
                          if (product['isVerified'])
                            Container(
                              margin: EdgeInsets.only(top: 6),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.blue[100],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Verified by TrustBridge',
                                style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.blue[900]),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
