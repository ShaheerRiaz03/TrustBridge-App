import 'package:course_project/ViewSubmittedLinksPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ProductLinkSubmissionPage extends StatefulWidget {
  const ProductLinkSubmissionPage({Key? key}) : super(key: key);

  @override
  State<ProductLinkSubmissionPage> createState() => _ProductLinkSubmissionPageState();
}

class _ProductLinkSubmissionPageState extends State<ProductLinkSubmissionPage> {
  Future<void> _submitdata() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User not logged in")),
      );
      return;
    }

    final uid = user.uid;
    final dbRef = FirebaseDatabase.instance.ref().child('product-links').child(uid);
    final productId = dbRef.push().key!;

    final productData = {
      'uid': uid,
      'Pid': productId,
      'title': _titleController.text.trim(),
      'link': _linkController.text.trim(),
      'platform': _selectedPlatform,
      'category': _selectedCategory,
      'price': double.tryParse(_priceController.text.trim()) ?? 0,
      'fee': _calculatedFee ?? 0,
      'agreedToTerms': _agreeToTerms,
      'submittedAt': DateTime.now().toIso8601String(),
    };

    try {
      await dbRef.child(productId).set(productData);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product link saved to database.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving data: $e')),
      );
    }
  }


  final TextEditingController _linkController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();

  String _selectedCategory = 'Electronics';
  String _selectedPlatform = 'Daraz';

  bool _agreeToTerms = false;
  bool _isLoading = false;
  double? _calculatedFee;

  final List<String> categories = [
    'Electronics',
    'Fashion',
    'Home',
    'Health',
    'Other'
  ];
  final List<String> platforms = ['Daraz', 'Amazon', 'AliExpress', 'Other'];

  bool isValidLink(String url) {
    final pattern = r'^(https?:\/\/)?(www\.)?[\w\-]+\.[a-z]{2,6}([\/\w\-\.]*)*\/?$';
    final regExp = RegExp(pattern, caseSensitive: false);
    return regExp.hasMatch(url);
  }

  void _calculateFee() {
    final price = double.tryParse(_priceController.text.trim()) ?? 0;

    if (price >= 50000) {
      _calculatedFee = 1000;
    } else if (price >= 10000) {
      _calculatedFee = 500;
    } else if (price >= 5000) {
      _calculatedFee = 250;
    } else if (price > 0) {
      _calculatedFee = 100;
    } else {
      _calculatedFee = 0;
    }
  }



  void _submitLink() async {
    final link = _linkController.text.trim();
    final priceText = _priceController.text.trim();
    final title = _titleController.text.trim();

    if (link.isEmpty || priceText.isEmpty || title.isEmpty ) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields.")),
      );
      return;
    }

    if (!isValidLink(link)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter a valid product link.")),
      );
      return;
    }

    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please confirm product authenticity.")),
      );
      return;
    }

    _calculateFee();

    setState(() => _isLoading = true);

    await _submitdata();

    setState(() {
      _isLoading = false;
      _linkController.clear();
      _priceController.clear();
      _titleController.clear();
      _agreeToTerms = false;
      _calculatedFee = null;
    });


    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Link submitted for admin review.")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar:  AppBar(
          automaticallyImplyLeading: false,
          actions: [
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'view_links') {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context)
                      =>ViewSubmittedLinksPage()));
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem<String>(
                  value: 'view_links',
                  child: Text("View Submitted Links"),
                ),
              ],
            ),
          ],
        ),

        body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
                children: [
                  SizedBox(height: 20,),
                  SizedBox(width: 10,),
                  Text("Sumbit Product link for Verification",
                    style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Submit a product link for admin review",
                              style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 22),

                          TextField(
                            controller: _titleController,
                            decoration: const InputDecoration(
                              labelText: 'Product Title',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 22),

                          DropdownButtonFormField<String>(
                            value: _selectedPlatform,
                            decoration: const InputDecoration(
                              labelText: 'Platform',
                              border: OutlineInputBorder(),
                            ),
                            items: platforms.map((platform) {
                              return DropdownMenuItem(value: platform, child: Text(platform));
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) setState(() => _selectedPlatform = value);
                            },
                          ),
                          const SizedBox(height: 22),

                          TextField(
                            controller: _linkController,
                            decoration: const InputDecoration(
                              labelText: 'Product Link',
                              border: OutlineInputBorder(),
                              suffixIcon: Icon(Icons.link),
                            ),
                          ),
                          const SizedBox(height: 22),

                          TextField(
                            controller: _priceController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Estimated Product Price (PKR)',
                              border: OutlineInputBorder(),
                              suffixIcon: Icon(Icons.price_check),
                            ),
                          ),
                          const SizedBox(height: 22),

                          DropdownButtonFormField<String>(
                            value: _selectedCategory,
                            decoration: const InputDecoration(
                              labelText: 'Category',
                              border: OutlineInputBorder(),
                            ),
                            items: categories.map((cat) {
                              return DropdownMenuItem(value: cat, child: Text(cat));
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) setState(() => _selectedCategory = value);
                            },
                          ),
                          const SizedBox(height: 22),

                          Row(
                            children: [
                              Checkbox(
                                value: _agreeToTerms,
                                onChanged: (val) {
                                  setState(() => _agreeToTerms = val ?? false);
                                },
                              ),
                              const Expanded(
                                child: Text(
                                  "I confirm this is a real product I want verified for authenticity, seller reputation, return policy, and value.",
                                ),
                              ),
                            ],
                          ),

                          if (_priceController.text.isNotEmpty)
                            Builder(builder: (context) {
                              _calculateFee();
                              return Text(
                                _calculatedFee != null && _calculatedFee! > 0
                                    ? "Verification Fee: PKR ${_calculatedFee!.toStringAsFixed(0)}"
                                    : "No fee for items below PKR 50,000",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueAccent,
                                ),
                              );
                            }),
                          const SizedBox(height: 50),

                          _isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : ElevatedButton.icon(
                            icon: const Icon(Icons.send),
                            label: const Text("Submit for Review"),
                            onPressed: _submitLink,
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 48),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ]
            )
        ),
      ),
    );
  }
}
