import 'package:flutter/material.dart';
import 'package:flutter_application_2/service/database.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController updateController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phNocontroller = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Key to validate the form

  @override
  Widget build(BuildContext context) {
    final firestoreService = Provider.of<FirestoreService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Firebase Firestore Example"),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_forever, color: const Color.fromARGB(255, 255, 2, 2)),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Delete All Users"),
                  content: Text("Are you sure you want to delete ALL users?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Cancel"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        firestoreService.deleteAll();
                        Navigator.pop(context);
                      },
                      child: Text("Delete All"),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey, // Assign the key for form validation
              child: Column(
                children: [
               
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: "Enter Name",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),

                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "Enter Email",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an email';
                      }
                      String pattern = r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,7}\b';
                      RegExp regExp = RegExp(pattern);
                      if (!regExp.hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),

                  TextFormField(
                    controller: phNocontroller,
                    decoration: InputDecoration(
                      labelText: "Enter Phone Number",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a phone number';
                      }
                      // Check if the phone number contains only digits
                      if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                        return 'Please enter a valid phone number';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {

                firestoreService.addUser(
                  nameController.text,
                  emailController.text,
                  phNocontroller.text,
                );
               
                nameController.clear();
                emailController.clear();
                phNocontroller.clear();
              }
            },
            child: Text("Add User"),
          ),
          Expanded(
            child: StreamBuilder(
              stream: firestoreService.getUser(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

                final users = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    final userId = user.id;
                    final userName = user['name'];
                    final userEmail = user['email'];
                    final userPhone = user['phNo'];

                    return ListTile(
                      title: Text(userName),
                      subtitle: Text('$userEmail - $userPhone'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                   
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              updateController.text = userName;
                              emailController.text = userEmail;
                              phNocontroller.text = userPhone;

                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text("Update User"),
                                  content: Column(
                                    children: [
                                      TextField(
                                        controller: updateController,
                                        decoration: InputDecoration(labelText: "Enter new name"),
                                      ),
                                      TextField(
                                        controller: emailController,
                                        decoration: InputDecoration(labelText: "Enter new email"),
                                      ),
                                      TextField(
                                        controller: phNocontroller,
                                        decoration: InputDecoration(labelText: "Enter new phone number"),
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text("Cancel"),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        if (updateController.text.isNotEmpty &&
                                            emailController.text.isNotEmpty &&
                                            phNocontroller.text.isNotEmpty) {
                                          firestoreService.updateUser(
                                            userId,
                                            updateController.text,
                                            emailController.text,
                                            phNocontroller.text,
                                          );
                                          Navigator.pop(context);
                                        }
                                      },
                                      child: Text("Update"),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text("Delete User"),
                                  content: Text("Are you sure you want to delete this user?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text("Cancel"),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        firestoreService.deleteUser(userId);
                                        Navigator.pop(context);
                                      },
                                      child: Text("Delete"),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
