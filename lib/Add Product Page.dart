import 'dart:convert';
import 'dart:io' as io;
import 'dart:typed_data';

import 'package:course_project/Compound%20Materials/Compound%20Button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProductEntryPage extends StatefulWidget {
  final Product? product;
  const ProductEntryPage({super.key, this.product});

  @override
  State<ProductEntryPage> createState() => _ProductEntryPageState();
}

class _ProductEntryPageState extends State<ProductEntryPage> {
  final TextEditingController _PidController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _salePriceController = TextEditingController();
  final TextEditingController _purchasePriceController = TextEditingController();

  String? _selectedCategory;
  String? _selectedUnit;

  final List<String> _categories = ['Electronics', 'Clothing', 'Food', 'Books'];
  final List<String> _units = ['pcs', 'kg', 'liters'];

  final ImagePicker _picker = ImagePicker();
  List<Uint8List> _webImages = [];
  List<io.File> _mobileImages = [];

  Future<void> _pickImages() async {
    final pickedImages = await _picker.pickMultiImage(imageQuality: 70);
    if (pickedImages.isNotEmpty) {
      if (kIsWeb) {
        final webImgs = await Future.wait(pickedImages.map((x) => x.readAsBytes()));
        setState(() {
          _webImages = webImgs;
        });
      } else {
        setState(() {
          _mobileImages = pickedImages.map((x) => io.File(x.path)).toList();
        });
      }
    }
  }

  Future<List<String>> _convertImagesToBase64() async {
    List<String> base64Images = [];

    if (kIsWeb && _webImages.isNotEmpty) {
      base64Images = _webImages.map((bytes) => base64Encode(bytes)).toList();
    } else if (_mobileImages.isNotEmpty) {
      for (var file in _mobileImages) {
        final bytes = await file.readAsBytes();
        base64Images.add(base64Encode(bytes));
      }
    }

    return base64Images;
  }

  Future<void> _saveProduct() async {
    final imageList = await _convertImagesToBase64();
    final dbRef = FirebaseDatabase.instance.ref().child('products');
    final productId = widget.product?.Pid ?? dbRef.push().key!;

    final product = Product(
      Pid: productId,
      name: _nameController.text,
      description: _descController.text,
      category: _selectedCategory ?? '',
      unit: _selectedUnit ?? '',
      quantity: int.tryParse(_quantityController.text) ?? 0,
      salePrice: double.tryParse(_salePriceController.text) ?? 0,
      purchasePrice: double.tryParse(_purchasePriceController.text) ?? 0,
      imageBase64List: imageList,
    );

    try {
      if (widget.product == null) {
        await dbRef.child(productId).set(product.toMap());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Product saved successfully')),
        );
      } else {
        await dbRef.child(productId).update(product.toMap());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Product updated successfully')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Widget _imageContainer() {
    final imageWidgets = kIsWeb
        ? _webImages.map((img) => Image.memory(img, fit: BoxFit.cover)).toList()
        : _mobileImages.map((img) => Image.file(img, fit: BoxFit.cover)).toList();

    return GestureDetector(
      onTap: _pickImages,
      child: Container(
        height: 180,
        width: double.infinity,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey),
        ),
        child: imageWidgets.isEmpty
            ? Center(child: Text("Tap to select images"))
            : ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: imageWidgets.length,
          itemBuilder: (context, index) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 120,
                child: imageWidgets[index],
              ),
            );
          },
          separatorBuilder: (_, __) => SizedBox(width: 10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Product')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _imageContainer(),
            SizedBox(height: 12),
            TextField(
              maxLength: 20,
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Product Name',
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
              controller: _descController,
              decoration: InputDecoration(
                labelText: 'Product Description',
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
              ),
              items: _categories.map((cat) {
                return DropdownMenuItem(value: cat, child: Text(cat));
              }).toList(),
              onChanged: (value) => setState(() => _selectedCategory = value),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _quantityController,
                    decoration: InputDecoration(
                      labelText: 'Quantity',
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedUnit,
                    decoration: InputDecoration(
                      labelText: 'Unit',
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    items: _units.map((unit) {
                      return DropdownMenuItem(value: unit, child: Text(unit));
                    }).toList(),
                    onChanged: (value) => setState(() => _selectedUnit = value),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _salePriceController,
                    decoration: InputDecoration(
                      labelText: 'Sale Price',
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _purchasePriceController,
                    decoration: InputDecoration(
                      labelText: 'Purchase Price',
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            custombutton(
                text: "Submit Product",
                onpressed:(){
                  _saveProduct();
                }
                ),
            SizedBox(height: 12),
            custombutton(
                text: "View Product",
                onpressed:(){

                })
          ],
        ),
      ),
    );
  }
}

class Product {
  String name;
  String description;
  String category;
  String unit;
  int quantity;
  double salePrice;
  double purchasePrice;
  List<String>? imageBase64List;
  String Pid;

  Product({
    required this.Pid,
    required this.name,
    required this.description,
    required this.category,
    required this.unit,
    required this.quantity,
    required this.salePrice,
    required this.purchasePrice,
    this.imageBase64List,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'category': category,
      'unit': unit,
      'quantity': quantity,
      'salePrice': salePrice,
      'purchasePrice': purchasePrice,
      'imageBase64List': imageBase64List,
      'Pid': Pid,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      Pid: map['Pid'],
      name: map['name'],
      description: map['description'],
      category: map['category'],
      unit: map['unit'],
      quantity: map['quantity'],
      salePrice: map['salePrice'],
      purchasePrice: map['purchasePrice'],
      imageBase64List: List<String>.from(map['imageBase64List'] ?? []),
    );
  }
}
