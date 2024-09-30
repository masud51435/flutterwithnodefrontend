import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/user_model.dart';
import 'package:http/http.dart' as http;

class AddUserPage extends StatefulWidget {
  @override
  _AddUserPageState createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  bool isLoading = false;

  // Function to send POST request to the backend
  Future<void> addUser(String name, String email) async {
    final url = Uri.parse(
        'http://10.0.2.2:5000/users'); // Adjust the URL for your setup
    setState(() {
      isLoading = true;
    });

    // Create a UserModel object
    final UserModel newUser = UserModel(name: name, email: email);

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(newUser.toJson()),
      );

      if (response.statusCode == 201) {
        print('User added successfully');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User added successfully!')),
        );
      } else {
        print('Failed to add user');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: const Text('Failed to add user')),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error adding user')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final name = _nameController.text;
                          final email = _emailController.text;
                          addUser(name, email);
                          _formKey.currentState!.reset();
                          setState(() {
                            Navigator.pop(context);
                          });
                        }
                      },
                      child: const Text('Submit'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
