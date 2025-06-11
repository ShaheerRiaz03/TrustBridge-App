import 'dart:convert';
import 'dart:io';
import 'package:course_project/Compound%20Materials/Compound%20Button.dart';
import 'package:flutter/foundation.dart';
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
  final ImagePicker _picker = ImagePicker();

  bool _isEditing = false;
  XFile? _image;
  String? _base64Image;

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
      _base64Image = data['imageBase64'];
      setState(() {});
    }
  }

  Future<void> _pickImage() async {
    final result = await _picker.pickImage(source: ImageSource.gallery);
    if (result != null) {
      final bytes = await result.readAsBytes();
      setState(() {
        _image = result;
        _base64Image = base64Encode(bytes);
      });
    }
  }

  Future<void> _saveProfile() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    await _db.child('users/$uid').update({
      'name': _nameController.text.trim(),
      if (_base64Image != null) 'ProfilePic': _base64Image,
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

  ImageProvider? _getProfileImage() {
    if (_image != null) {
      return kIsWeb
          ? NetworkImage(_image!.path)
          : FileImage(File(_image!.path)) as ImageProvider;
    } else if (_base64Image != null && _base64Image!.isNotEmpty) {
      try {
        final bytes = base64Decode(_base64Image!);
        return MemoryImage(bytes);
      } catch (e) {
        debugPrint('❌ Error decoding image: $e');
      }
    }
    return const AssetImage("assets/default_avatar.png");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.blueAccent,
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
                    radius: 55,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: _getProfileImage(),
                    child: (_getProfileImage() == null)
                        ? const Icon(Icons.person, size: 50,
                        color: Colors.white)
                        : null,
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.blueAccent,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.edit, color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _nameController,
                    enabled: _isEditing,
                    style: const TextStyle(fontSize: 18),
                    decoration: InputDecoration(
                      labelText: "Name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.deepPurple),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.edit,
                      color: Colors.blueAccent),
                  onPressed: _toggleEdit,
                ),
              ],
            ),
            const SizedBox(height: 30),
            ListTile(
              leading: const Icon(Icons.email,
                  color: Colors.blueAccent),
              title: Text(_auth.currentUser?.email ?? 'No Email'),
              subtitle: const Text("Email"),
            ),
            ListTile(
              leading: const Icon(Icons.verified_user,
                  color: Colors.blueAccent),
              title: Text(_auth.currentUser?.uid ?? 'Unknown UID'),
              subtitle: const Text("User ID"),
            ),
            const SizedBox(height: 250),
            custombutton(
                text: "Save Changes",
                onpressed: _saveProfile
            )
          ],
        ),
      ),
    );
  }
}
