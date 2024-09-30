import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/user_model.dart';
import 'package:http/http.dart' as http;

import 'add_user.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<UserModel> users = [];

  Future<void> fetchUsers() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:5000/users'),
      ); // Use proper URL

      if (response.statusCode == 200) {
        final List<dynamic> usersJson = json.decode(response.body);
        setState(() {
          users = usersJson.map((json) => UserModel.fromJson(json)).toList();
        });
      } else {
        throw Exception('Failed to load users');
      }
    } catch (error) {
      print('Error fetching users: $error');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('show node js data'),
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (BuildContext context, int index) {
          final user = users[index];
          return ListTile(
            leading: Text(user.id.toString()),
            title: Text(user.name ?? ''),
            trailing: Text(user.email ?? ''),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the AddUserPage when button is pressed
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddUserPage()),
          ).then((value) =>
              fetchUsers()); // Fetch users again after returning from AddUserPage
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
