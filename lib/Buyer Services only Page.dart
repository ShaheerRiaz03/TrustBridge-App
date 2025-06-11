import 'package:course_project/Buyer%20Services%20Details%20page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class FreelanceBuyerPage extends StatefulWidget {
  @override
  State<FreelanceBuyerPage> createState() => _FreelanceBuyerPageState();
}

class _FreelanceBuyerPageState extends State<FreelanceBuyerPage> {
  final databaseref = FirebaseDatabase.instance.ref('Service');
  List<Map<String, dynamic>> services = [];
  bool isLoading = true;
  String error = '';

  @override
  void initState() {
    super.initState();
    fetchServices();
  }

  void fetchServices() async {
    try {
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
            'verified': true, // Change if needed
            'description': serviceData['description'] ?? '',
          });
        });

        setState(() {
          services = loadedServices;
          isLoading = false;
        });
      } else {
        setState(() {
          error = 'No services available.';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Something went wrong.';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Services', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : error.isNotEmpty
            ? Center(child: Text(error, style: TextStyle(fontSize: 16)))
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Available Services",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                itemCount: services.length,
                gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.70,
                ),
                itemBuilder: (context, index) {
                  return _buildServiceCard(services[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard(Map<String, dynamic> service) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ServiceDetailPage(service: service),
          ),
        );
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Replace icon with image if needed
              Center(
                child: Icon(Icons.design_services,
                    size: 40, color: Colors.blueGrey),
              ),
              const SizedBox(height: 10),
              Text(
                service['title'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text("PKR ${service['price']}",
                  style: const TextStyle(color: Colors.green)),
              const SizedBox(height: 6),
              Text(
                service['description'],
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 13, color: Colors.black87),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      service['seller'],
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (service['verified'])
                    const Icon(Icons.verified, color: Colors.blue, size: 16),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }}
