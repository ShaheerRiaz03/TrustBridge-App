import 'package:course_project/Compound%20Materials/Compound%20Button.dart';
import 'package:course_project/Seller%20Freelance%20Page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';


class ServiceEntryPage extends StatefulWidget {
  final Service? product;

  const ServiceEntryPage({Key? key, this.product}) : super(key: key);

  @override
  _ServiceEntryPageState createState() => _ServiceEntryPageState();
}

class _ServiceEntryPageState extends State<ServiceEntryPage> {
  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _nameController.text = widget.product!.name;
      _descController.text = widget.product!.description;
      _priceController.text = widget.product!.servicePrice.toString();
      _selectedCategory = widget.product!.category;
    }
  }

  Future<void> _saveProduct() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User not logged in')),
      );
      return;
    }

    final uid = user.uid;
    final dbRef = FirebaseDatabase.instance.ref().child('Service').child(uid);
    final productId = widget.product?.Sid ?? dbRef.push().key!;

    final product = Service(
      uid: uid,
      Sid: productId,
      name: _nameController.text,
      description: _descController.text,
      category: _selectedCategory ?? '',
      servicePrice: double.tryParse(_servicePriceController.text) ?? 0,
    );

    try {
      if (widget.product == null) {
        // New product
        await dbRef.child(productId).set(product.toMap());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Service Product saved successfully')),
        );
      } else {
        // Updating existing product
        await dbRef.child(productId).update(product.toMap());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Service Product updated successfully')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving product: $e')),
      );
    }
  }

  final TextEditingController _PidController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _servicePriceController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();





  String? _selectedCategory;
  String? _selectedUnit;

  final List<String> _categories = [ 'App / Web Developement','Video Editing', 'logo design','Others'];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Add Services')),
        body: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
                children: [
                  // Image container removed

                  SizedBox(height: 12),
                  TextField(
                    maxLength: 120,
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Service Name',
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    maxLines: 6,
                    controller: _descController,
                    decoration: InputDecoration(
                      labelText: ' Description',
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: InputDecoration(
                      labelText: 'Category',
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    items: _categories.map((cat) {
                      return DropdownMenuItem(value: cat, child: Text(cat));
                    }).toList(),
                    onChanged: (value) => setState(() => _selectedCategory = value),
                  ),
                  SizedBox(height: 14),
                  TextField(
                    controller: _servicePriceController,
                    decoration: InputDecoration(
                      labelText: 'Price',
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 120),
                  custombutton(
                    text: "Submit Services",
                    onpressed: _saveProduct,),
                  SizedBox(height: 24),
                  custombutton(
                      text: "Veiw Service",
                      onpressed: (){
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context)=>ServicesEditPage()));
                      })
                ]
            )
        )
    );
  }
}
class Service {
  String name;
  String description;
  String category;
  double servicePrice;
  String Sid;
  String? uid;

  Service({
    required this.Sid,
    required this.name,
    required this.description,
    required this.category,
    required this.servicePrice,
    this.uid,
  });

  Map<String, dynamic> toMap() {
    return {
      'Sid': Sid,
      'name': name,
      'description': description,
      'category': category,
      'servicePrice': servicePrice,
      'uid': uid,
    };
  }

  factory Service.fromMap(Map<String, dynamic> map) {
    return Service(
      Sid: map['Sid'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      servicePrice: (map['servicePrice'] is int)
          ? (map['servicePrice'] as int).toDouble()
          : (map['servicePrice'] ?? 0.0),
      uid: map['uid'],
    );
  }
}
