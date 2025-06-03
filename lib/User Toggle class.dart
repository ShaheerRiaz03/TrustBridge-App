import 'package:flutter/material.dart';

class ProfileToggle extends StatelessWidget {
  final bool isBuyer;
  final Function(bool) onToggle;

  const ProfileToggle({super.key, required this.isBuyer, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onToggle(!isBuyer); // Toggle role
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isBuyer ? Colors.blueAccent : Colors.green,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isBuyer ? Icons.person : Icons.business_center,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              isBuyer ? "Buyer" : "Seller",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
