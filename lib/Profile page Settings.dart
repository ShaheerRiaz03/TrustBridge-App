import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseDatabase.instance.ref();
  final _nameController = TextEditingController();
  bool _isEditing = false;
  String? _base64Image;
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final snapshot = await _db.child('users/$uid').get();
    if (snapshot.exists) {
      final data = snapshot.value as Map;
      _nameController.text = data['name'] ?? '';
      setState(() {
        _base64Image = data['imageBase64'];
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final imageFile = File(picked.path);
      final bytes = await imageFile.readAsBytes();
      setState(() {
        _base64Image = base64Encode(bytes);
        _selectedImage = imageFile;
      });
    }
  }

  Future<void> _saveProfile() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    await _db.child('users/$uid').set({
      'name': _nameController.text.trim(),
      'imageBase64': _base64Image ?? '',
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile saved")),
    );

    setState(() => _isEditing = false);
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  ImageProvider _getProfileImage() {
    if (_selectedImage != null) {
      return FileImage(_selectedImage!);
    } else if (_base64Image != null && _base64Image!.isNotEmpty) {
      final bytes = base64Decode(_base64Image!);
      return MemoryImage(bytes);
    } else {
      return const AssetImage("assets/default_avatar.png");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveProfile,
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 70,
                    backgroundImage: _getProfileImage(),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.deepPurple,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.camera_alt, color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _nameController,
              enabled: _isEditing,
              style: const TextStyle(fontSize: 18),
              decoration: InputDecoration(
                labelText: "Name",
                suffixIcon: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: _toggleEdit,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.deepPurple),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            const SizedBox(height: 30),
            ListTile(
              leading: const Icon(Icons.email, color: Colors.deepPurple),
              title: Text(_auth.currentUser?.email ?? 'No Email'),
              subtitle: const Text("Email"),
            ),
            ListTile(
              leading: const Icon(Icons.verified_user, color: Colors.deepPurple),
              title: Text(_auth.currentUser?.uid ?? 'Unknown UID'),
              subtitle: const Text("User ID"),
            ),
          ],
        ),
      ),
    );
  }
}
