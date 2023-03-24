import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CreateMemo extends StatelessWidget {
  CreateMemo({super.key});
  final senderController = TextEditingController();
  final recipientController = TextEditingController();
  final ccController = TextEditingController();
  final referenceController = TextEditingController();
  final dateController = TextEditingController();
  final subjectController = TextEditingController();

  Future<bool> sendDataToServer(Map<String, dynamic> data) async {
    try {
      var url = Uri.parse('http://192.168.68.105/memo_api/insert_data.php');
      var response = await http.post(url, body: data);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      return true;
    } catch (error) {
      print(error.toString());
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    void _showDialog(bool success) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(success ? 'Success' : 'Error'),
            content: Text(success
                ? 'Data uploaded successfully'
                : 'There was an error uploading the data'),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              TextField(
                controller: senderController,
                decoration: InputDecoration(
                  hintText: "SENDER",
                  labelText: "Sender's Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(
                  top: 20.0,
                ),
              ),
              TextField(
                // obscureText: true,
                controller: recipientController,
                decoration: InputDecoration(
                  hintText: "RECIPIENT",
                  labelText: "Recipient's Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(
                  top: 20.0,
                ),
              ),
              TextField(
                // obscureText: true,
                controller: ccController,
                decoration: InputDecoration(
                  hintText: "CC",
                  labelText: "cc",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(
                  top: 20.0,
                ),
              ),
              TextField(
                // obscureText: true,
                controller: referenceController,
                decoration: InputDecoration(
                  hintText: "REFERENCE",
                  labelText: "Reference",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(
                  top: 20.0,
                ),
              ),
              TextField(
                // obscureText: true,
                controller: dateController,
                decoration: InputDecoration(
                  hintText: "DATE",
                  labelText: "Date",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(
                  top: 20.0,
                ),
              ),
              TextField(
                // obscureText: true,
                controller: subjectController,
                decoration: InputDecoration(
                  hintText: "SUBJECT",
                  labelText: "Subject",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
              // ElevatedButton(
              //   style: ButtonStyle(
              //     foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              //     overlayColor: MaterialStateProperty.resolveWith<Color?>(
              //       (Set<MaterialState> states) {
              //         if (states.contains(MaterialState.hovered)) {
              //           return Colors.blue.withOpacity(0.5);
              //         }
              //         if (states.contains(MaterialState.focused) ||
              //             states.contains(MaterialState.pressed)) {
              //           return Colors.blue.withOpacity(1.0);
              //         }
              //         return Colors.red; // Defer to the widget's default.
              //       },
              //     ),
              //   ),
              //   onPressed: () async {},
              //   child: const Text('UPLOAD'),
              // ),
              ElevatedButton(
                style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  overlayColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.hovered)) {
                        return Colors.blue.withOpacity(0.5);
                      }
                      if (states.contains(MaterialState.focused) ||
                          states.contains(MaterialState.pressed)) {
                        return Colors.blue.withOpacity(1.0);
                      }
                      return Colors.red; // Defer to the widget's default.
                    },
                  ),
                ),
                onPressed: () async {
                  Map<String, dynamic> data = {
                    'sender_name': senderController.text,
                    'recipient_name': recipientController.text,
                    'cc': ccController.text,
                    'reference': referenceController.text,
                    'date': dateController.text,
                    'subject': subjectController.text,
                  };
                  bool success = await sendDataToServer(data);
                  _showDialog(success);
                },
                child: const Text('SUBMIT'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
