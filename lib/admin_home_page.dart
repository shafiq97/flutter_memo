import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobileapp/admin_received.dart';
import 'package:mobileapp/admin_sent.dart';
import 'package:mobileapp/create_memo.dart';

import 'login_page.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({Key? key}) : super(key: key);

  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  List<dynamic> _data = [];

  Future<void> _fetchData() async {
    List<dynamic> data = [];
    try {
      final response = await http
          .get(Uri.parse("http://192.168.68.105/memo_api/get_all.php"));
      if (response.statusCode == 200) {
        data = jsonDecode(response.body) as List<dynamic>;
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (error) {
      log('Error fetching data: $error');
    }
    setState(() {
      _data = data;
    });
  }

  Future<void> _sendText(String text, String memoId) async {
    try {
      final response = await http.put(
        Uri.parse("http://192.168.68.105/memo_api/assign_to.php"),
        headers: {
          "Content-Type": "application/json",
        },
        body: json.encode({
          "text": text,
          "memo_id": memoId,
        }),
      );
      if (response.statusCode == 200) {
        // Handle success response
        log('got here 2');
        final response2 = json.decode(response.body);
        log(response2['message']);
        response.body.toString();
      } else {
        log('got here 1');
        throw Exception(response.body.toString());
      }
    } catch (error) {
      log('got here 3');
      log('Error sending data: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateMemo()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _data.isEmpty
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: _data.length,
                    itemBuilder: (context, index) {
                      return Dismissible(
                        key: UniqueKey(),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          color: Colors.red,
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (direction) async {
                          final memoId = _data[index]['id'];
                          try {
                            final response = await http.post(
                              Uri.parse(
                                  "http://192.168.68.105/memo_api/delete_memo.php"),
                              headers: {
                                "Content-Type": "application/json",
                              },
                              body: json.encode({
                                "memo_id": memoId,
                              }),
                            );
                            if (response.statusCode == 200) {
                              // Handle success response
                              log('Delete successful');
                            } else {
                              throw Exception(response.body.toString());
                            }
                          } catch (error) {
                            log('Error sending data: $error');
                          }
                          setState(() {
                            _data.removeAt(index);
                          });
                        },
                        child: ListTile(
                          title: Text("Subject: ${_data[index]['subject']}"),
                          trailing:
                              Text("Sender: ${_data[index]['sender_name']}"),
                          subtitle: Text(
                              "Receiver: ${_data[index]['recipient_name']}\n Filename: ${_data[index]['image']}"),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                String text = "";
                                return AlertDialog(
                                  title: const Text("Assign to (Use Id)"),
                                  content: TextField(
                                    onChanged: (value) {
                                      text = value;
                                    },
                                  ),
                                  actions: [
                                    TextButton(
                                      child: const Text("CANCEL"),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                    TextButton(
                                      child: const Text("SEND"),
                                      onPressed: () {
                                        _sendText(text, _data[index]['id']);
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
