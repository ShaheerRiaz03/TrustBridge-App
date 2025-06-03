import 'package:course_project/Seller%20Add%20Services.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';


class ServicesEditPage extends StatefulWidget {
  const ServicesEditPage({super.key});

  @override
  State<ServicesEditPage> createState() => _ServicesEditPageState();
}

class _ServicesEditPageState extends State<ServicesEditPage> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref().child('Service');
  List<Service> _products = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void deleteEntry(String uid) {
    _dbRef.child(uid).remove().then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Service Deleted')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete: $error')),
      );
    });
  }

  void _loadProducts() {
    _dbRef.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        final List<Service> loadedProducts = [];
        data.forEach((key, value) {
          final productMap = Map<String, dynamic>.from(value);
          productMap['Sid'] = key; // Set Pid
          loadedProducts.add(Service.fromMap(productMap));
        });

        setState(() {
          _products = loadedProducts;
        });
      } else {
        setState(() {
          _products = [];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('All Services')),
      body: _products.isEmpty
          ? const Center(child: Text("No services available"))
          : GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          childAspectRatio: 3 / 5.4,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: _products.length,
        itemBuilder: (ctx, index) {
          final product = _products[index];

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ServiceEntryPage(product: product),
                ),
              );
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Center(

                  child: Column(
                    mainAxisSize: MainAxisSize.min, // ✅ This centers content vertically
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 30,),
                      Text(
                        product.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        product.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8,),
                      Text(product.category,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),),
                      SizedBox(height: 8),
                      Text(
                        "PKR ${product.servicePrice.toStringAsFixed(0)}",
                        style: TextStyle(color: Colors.green),
                      ),
                      SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Tooltip(
                            message: 'Edit',
                            child: IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ServiceEntryPage(product: product),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.edit, color: Colors.blue),
                            ),
                          ),
                          Tooltip(
                            message: "Delete",
                            child: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.redAccent),
                              onPressed: () {
                                deleteEntry(product.Sid);
                              },
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

