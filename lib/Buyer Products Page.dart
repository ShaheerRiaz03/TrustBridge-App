import 'package:flutter/material.dart';

class BuyerProductPage extends StatelessWidget {
  final List<Map<String, dynamic>> products = [
    {
      'title': 'Mobile',
      'price': 51500,
      'imageUrl': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQaEkvjp9uIyiI6Q_jicOa3usrv_yEc_P-X8A&s',
      'seller': 'Oppo Mobile company',
      'isVerified': true,
    },
    {
      'title': 'Shoes',
      'price': 3000,
      'imageUrl':'https://www.julke.pk/cdn/shop/products/Napoleon-men-shoes-leather-sideview-JULKE_1400x.jpg?v=1668776014',
      'seller': 'Bata',
      'isVerified': false,
    },
    {
      'title': 'Laptops',
      'price': 85000,
      'imageUrl': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQgi3XhodPpI98vAqzSVzzC3V3ZCdntjMZbBqmQjEIQMc7hORrV8uijepq6lr4OOwmphGQ&usqp=CAU',
      'seller': 'DevPro',
      'isVerified': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Available Products')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          itemCount: products.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.7,
          ),
          itemBuilder: (context, index) {
            final product = products[index];
            return GestureDetector(
              onTap: () {
              },
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                      child: SizedBox(
                        height: 130,
                        width: double.infinity,
                        child: Image.network(
                          product['imageUrl'],
                          fit: BoxFit.contain,

                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment:MainAxisAlignment.end,
                        children: [
                          SizedBox(height:80 ,),
                          Text(
                            product['title'],
                            style: TextStyle(fontWeight: FontWeight.bold),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),

                          SizedBox(height: 4),

                          Text("by ${product['seller']}", style: TextStyle(fontSize: 12, color: Colors.grey[600])),

                          Text("PKR ${product['price']}", style: TextStyle(fontWeight: FontWeight.bold)),
                          if (product['isVerified'])
                            Container(
                              margin: EdgeInsets.only(top: 6),
                              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.blue[100],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Verified by TrustBridge',
                                style: TextStyle(fontSize: 10, color: Colors.blue[900]),
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
