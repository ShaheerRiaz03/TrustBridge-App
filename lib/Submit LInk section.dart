import 'package:flutter/material.dart';

class SubmitLinkSection extends StatefulWidget {
  const SubmitLinkSection({Key? key}) : super(key: key);

  @override
  State<SubmitLinkSection> createState() => _SubmitLinkSectionState();
}

class _SubmitLinkSectionState extends State<SubmitLinkSection> {
  final TextEditingController _linkController = TextEditingController();
  String _selectedCategory = 'Electronics';
  bool _agreeToTerms = false;
  bool _isLoading = false;

  bool isValidLink(String url) {
    final pattern = r'^(https?:\/\/)?(www\.)?[\w\-]+\.[a-z]{2,6}([\/\w\-\.]*)*\/?$';
    final regExp = RegExp(pattern, caseSensitive: false);
    return regExp.hasMatch(url);
  }

  final List<String> categories = ['Electronics', 'Fashion', 'Home', 'Health', 'Other'];

  void _submitLink() async {
    final linkText = _linkController.text.trim();

    if (linkText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a product link.")),
      );
      return;
    }

    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You must agree to the terms.")),
      );
      return;
    }

    if (!isValidLink(linkText)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid link (e.g. starting with www. or https://).")),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Simulated delay, replace with actual Firebase/Backend logic
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Link submitted for verification!")),
    );

    _linkController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Submit your own link to verify products",
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            TextField(
              controller: _linkController,
              decoration: const InputDecoration(
                labelText: 'Product Link',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.link),
              ),
            ),
            const SizedBox(height: 12),
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
            const SizedBox(height: 12),
            Row(
              children: [
                Checkbox(
                  value: _agreeToTerms,
                  onChanged: (val) {
                    setState(() => _agreeToTerms = val ?? false);
                  },
                ),
                const Expanded(child: Text("I confirm this is a real product I want verified."))
              ],
            ),
            const SizedBox(height: 8),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton.icon(
              icon: const Icon(Icons.send),
              label: const Text("Send"),
              onPressed: _submitLink,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
