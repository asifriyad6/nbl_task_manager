import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/ui/screens/signin_screen.dart';

class TMAppBar extends StatefulWidget implements PreferredSizeWidget {
  const TMAppBar({super.key});

  @override
  State<TMAppBar> createState() => _TMAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _TMAppBarState extends State<TMAppBar> {
  final User? _currentUser = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.green,
      foregroundColor: Colors.white,
      title: Row(
        children: [
          const CircleAvatar(),
          const SizedBox(width: 16),
          Expanded(
            child: FutureBuilder<DocumentSnapshot>(
              future: _firestore
                  .collection('users')
                  .doc(_currentUser?.email)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text(
                    'Loading...',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  );
                }
                if (snapshot.hasError) {
                  return const Text(
                    'Error loading user',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  );
                }
                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return const Text(
                    'Unknown User',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  );
                }

                final data = snapshot.data!.data() as Map<String, dynamic>;
                final userName = data['name'] ?? 'User';
                final designation = data['designation'] ?? '';

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (designation.isNotEmpty)
                      Text(
                        designation,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
          IconButton(onPressed: _onTapLogout, icon: const Icon(Icons.logout)),
        ],
      ),
    );
  }

  void _onTapLogout() async {
    await FirebaseAuth.instance.signOut();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Sign out successful')));
    Navigator.pushNamedAndRemoveUntil(
      context,
      SigninScreen.name,
      (predicate) => false,
    );
  }
}
