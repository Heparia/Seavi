import 'package:flutter/material.dart';
import 'package:seavi/screens/home_screen.dart';
import 'package:seavi/services/network.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    getCategories();
  }

  void getCategories() async {
    List<Map<String, dynamic>> categories = []; 

    NetworkHelper networkHelper = NetworkHelper(
      url:
          'https://www.googleapis.com/youtube/v3/videoCategories?part=snippet&regionCode=ID',
    );

    try {
      var categoriesData = await networkHelper.getData();
      for (var item in categoriesData['items']) {
        categories.add({
          'id': item['id'],
          'title': item['snippet']['title'],
        });
      }

      if (!mounted) return;  
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(categories: categories)),
      );
    } catch (error) {
      print('Error fetching categories: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "Still fetching, please wait..."
        ),
      ),
    );
  }
}
