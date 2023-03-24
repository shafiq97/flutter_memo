import 'package:flutter/material.dart';
import 'package:mobileapp/create_memo.dart';
import 'package:mobileapp/admin_sent.dart';
import 'package:mobileapp/admin_received.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SADA Staff'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.note_add_rounded),
            onPressed: () {
              // Navigate to the next page
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CreateMemo()));
            },
          ),
        ],
      ),
      body: const Center(
        child: Text('My Page!'),
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: const Text('Received'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AdminReceived()),
                );
              },
            ),
            ListTile(
              title: const Text('Sent'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AdminSent()),
                );
              },
            ),
            ListTile(
                title: const Text('Logout'),
                onTap: () {
                  void logout() {
                    Navigator.pushNamed(context, '/login');
                  }
                }),
          ],
        ),
      ),
    );
  }
}
