import 'dart:developer';

import 'package:course_project/Buyer%20Services%20Details%20page.dart';
import 'package:course_project/Buyer%20Services%20only%20Page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class FreelanceBuyerPage extends StatefulWidget {
  @override
  State<FreelanceBuyerPage> createState() => _FreelanceBuyerPageState();
}

class _FreelanceBuyerPageState extends State<FreelanceBuyerPage> {
  final databaseref = FirebaseDatabase.instance.ref('Service');

  List<Map<String, dynamic>> services = [];


  @override
  void initState() {
    super.initState();
    fetchServices();
  }
  void fetchServices() async {
    final snapshot = await databaseref.get();
    if (snapshot.exists) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);

      final List<Map<String, dynamic>> loadedServices = [];

      data.forEach((key, value) {
        final serviceData = Map<String, dynamic>.from(value);
        loadedServices.add({
          'title': serviceData['category'] ?? 'No Title',
          'price': serviceData['servicePrice'] ?? 0,
          'seller': serviceData['name'] ?? 'Unknown',
          'verified': true, // You can change this if your DB has a field for it
          'description': serviceData['description'] ?? '',
        });
      });

      setState(() {
        services = loadedServices;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Available Services",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: services.isEmpty
                  ? Center(child: Text("No Services Yet"))
                  : GridView.builder(
                itemCount: services.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) {
                  final service = services[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ServiceDetailPage(service: service),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 80),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              service['title'],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            SizedBox(height: 5),
                            Text("PKR ${service['price']}",
                                style: TextStyle(color: Colors.green)),
                            SizedBox(height: 10),
                            Text(
                              service['description'],
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 13),
                            ),
                            Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  service['seller'],
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey[700]),
                                ),
                                if (service['verified'] == true)
                                  Icon(Icons.verified,
                                      color: Colors.blue, size: 16),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
