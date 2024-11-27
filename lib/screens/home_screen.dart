import 'package:flutter/material.dart';
import 'package:seavi/screens/dashboard_screen.dart';

class HomeScreen extends StatefulWidget {
  final List<Map<String, dynamic>> categories;

  const HomeScreen({Key? key, required this.categories}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, String> user = {};
  final TextEditingController nameController = TextEditingController();
  late String dropdownValue;
  bool _isRestrict = false;

  @override
  void initState() {
    super.initState();
    if (widget.categories.isNotEmpty) {
      dropdownValue = widget.categories[0]['id'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/bg_home.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Center(
                  child: Container(
                    constraints: const BoxConstraints(
                      maxWidth: 500, // Batas maksimum lebar kolom
                    ),
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
                    padding: const EdgeInsets.all(50.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Streamify",
                          style: TextStyle(
                            fontSize: 48.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "Hello StreamFriends, please fill in the form below!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15.0,
                          ),
                        ),
                        const SizedBox(height: 30),
                        Form(
                          child: Column(
                            children: [
                              TextField(
                                controller: nameController,
                                obscureText: false,
                                decoration: const InputDecoration(
                                  labelText: 'What is your name?',
                                ),
                              ),
                              const SizedBox(height: 20),
                              Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: [
                                  const Text("What are your interests?"),
                                  SizedBox(
                                    width: double.infinity,
                                    child: DropdownMenu<String>(
                                      initialSelection: dropdownValue,
                                      onSelected: (String? value) {
                                        setState(() {
                                          dropdownValue = value!;
                                        });
                                      },
                                      dropdownMenuEntries: widget.categories
                                          .map<DropdownMenuEntry<String>>(
                                        (Map<String, dynamic> category) {
                                          return DropdownMenuEntry<String>(
                                            value: category['id'],
                                            label: category['title'],
                                          );
                                        },
                                      ).toList(),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Checkbox(
                                    value: _isRestrict,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        _isRestrict = value ?? false;
                                      });
                                    },
                                  ),
                                  const Text("I am 18 or older"),
                                ],
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      side: BorderSide.none,
                                    ),
                                    backgroundColor: Colors.transparent,
                                  ),
                                  onPressed: () {
                                    String name = nameController.text;
                                    if (name.isEmpty) {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text('Input Error'),
                                          content:
                                              const Text('Please enter your name.'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text('OK'),
                                            ),
                                          ],
                                        ),
                                      );
                                    } else {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => DashboardScreen(
                                            name: name,
                                            kategori: dropdownValue,
                                            isRestrict: _isRestrict,
                                            kategoriName: widget.categories.firstWhere((category) => category['id'] == dropdownValue)['title'],
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      image: const DecorationImage(
                                        image: AssetImage('images/bg_button_30.png'),
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.zero,
                                    child: const Text(
                                      "Let's dive in!",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Powered by Youtube Data API",
                          style: TextStyle(
                            fontSize: 10.0,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
