import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final String name;
  final String interest;
  final bool restrict;

  const ProfileScreen({
    super.key,
    required this.name,
    required this.interest,
    required this.restrict,
  });

  getAge() {
    String age;
    if (restrict) {
      age = '18 years old or older'; 
    } else {
      age = 'Under 18 years old';
    }
    return age;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity, 
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/bg_home.png'),
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.7),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text(
                name,
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Interest: $interest',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                'Age: ${getAge()}',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
