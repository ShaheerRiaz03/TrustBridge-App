import 'package:flutter/material.dart';

class SellerProductGridPage extends StatelessWidget {
  final List<Map<String, dynamic>> sellerProducts = [
    {
      'title': 'Mobile',
      'price': 71500,
      'image': 'https://www.oppo.com/content/dam/oppo/common/mkt/v2-2/a40-a3-a40m-a60/listpage/427-600-black.png',
      'verified': true,
    },
    {
      'title': 'shoes',
      'price': 2500,
      'image': 'https://static-01.daraz.pk/p/55223cd384ad38ef8a8c02e53428746a.jpg',
      'verified': false,
    },
    {
      'title': 'Laptop',
      'price': 800,
      'image': 'https://i.rtings.com/assets/pages/cECBoo0k/best-laptops-at-best-buy-20250110-medium.jpg?format=auto',
      'verified': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Products")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          itemCount: sellerProducts.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.75,
          ),
          itemBuilder: (context, index) {
            final product = sellerProducts[index];

            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 4, spreadRadius: 1),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                          child: Image.network(
                            product['image'],
                            width: double.infinity,
                            fit: BoxFit.contain,
                          ),
                        ),
                        if (product['verified'])
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Icon(Icons.verified, color: Colors.blueAccent),
                          ),
                      ],
                    ),
                  ),

                  // 🧾 Product info and actions
                  Expanded(
                    flex: 2, // 40% of the card
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(product['title'],
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          SizedBox(height: 4),
                          Text("PKR ${product['price']}",
                              style: TextStyle(color: Colors.green)),
                          Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.orange),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

            );
          },
        ),
      ),
    );
  }
}
