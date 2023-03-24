import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobileapp/login_page.dart';

import 'admin_home_page.dart';

class HodPage extends StatefulWidget {
  const HodPage({super.key});

  @override
  _HodPageState createState() => _HodPageState();
}

class _HodPageState extends State<HodPage> {
  // Initialize an empty list to hold the data
  List<dynamic> _data = [];

  // Define the API links
  final String _pendingUrl = 'http://192.168.68.105/memo_api/get_pending.php';
  final String _approvedUrl = 'http://192.168.68.105/memo_api/get_approved.php';

  // Initialize a boolean variable to track the API status
  bool _isPending = true;

  // Update the status of the memo with the given memoId
  Future<void> _updateStatus(String memoId) async {
    try {
      // Define the API link and parameters
      const String url = 'http://192.168.68.105/memo_api/update_status.php';
      final Map<String, dynamic> params = {'memo_id': memoId};

      // Send a PUT request to the API endpoint with the memo ID as a parameter
      final response = await http.put(Uri.parse(url), body: params);
      if (response.statusCode == 200) {
        // If the response is successful, fetch the data again from the API endpoint
        _fetchData();
      } else {
        throw Exception('Failed to update memo status');
      }
    } catch (error) {
      print('Error updating memo status: $error');
    }
  }

  // Fetch the data from the server
  Future<void> _fetchData() async {
    try {
      final url = _isPending ? _pendingUrl : _approvedUrl;
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List<dynamic>;
        setState(() {
          _data = data;
        });
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (error) {
      log('Error fetching data: $error');
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          ),
        ),
        title: const Text('ListView Example'),
      ),
      body: Column(
        children: <Widget>[
          const SizedBox(height: 20.0),
          Text(
            _isPending ? 'Pending' : 'Approved',
            style: const TextStyle(fontSize: 22),
          ),
          const SizedBox(height: 20.0),
          Expanded(
            child: _data.isEmpty
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: _data.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text("Subject: ${_data[index]['subject']}"),
                        trailing:
                            Text("Sender: ${_data[index]['sender_name']}"),
                        subtitle:
                            Text("Receiver: ${_data[index]['recipient_name']}"),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Update Memo Status"),
                              content: const Text(
                                  "Are you sure you want to approve the memo?"),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    _updateStatus(_data[index]['id']);
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Confirm"),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
          Switch(
            value: _isPending,
            onChanged: (value) {
              setState(() {
                _isPending = value;
              });
              _fetchData();
            },
          ),
        ],
      ),
    );
  }
}
