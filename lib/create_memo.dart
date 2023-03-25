import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';

class CreateMemo extends StatelessWidget {
  CreateMemo({Key? key}) : super(key: key);
  final senderController = TextEditingController();
  final recipientController = TextEditingController();
  final ccController = TextEditingController();
  final referenceController = TextEditingController();
  final dateController = TextEditingController();
  final subjectController = TextEditingController();
  final fileController =
      TextEditingController(); // New controller for file name

  String? _filePath;

  Future<bool> sendDataToServer(Map<String, dynamic> data) async {
    try {
      var url = Uri.parse('http://192.168.68.105/memo_api/insert_data.php');

      var request = http.MultipartRequest('POST', url);
      request.fields['sender_name'] = data['sender_name'];
      request.fields['recipient_name'] = data['recipient_name'];
      request.fields['cc'] = data['cc'];
      request.fields['reference'] = data['reference'];
      request.fields['date'] = data['date'];
      request.fields['subject'] = data['subject'];

      if (data['file_path'] != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'file', // Use the field name 'file' for the uploaded file
          data['file_path'],
        ));
      }

      var response = await request.send();

      if (response.statusCode == 200) {
        print('Response status: ${response.statusCode}');
        print('Response body: ${await response.stream.bytesToString()}');
        return true;
      } else {
        print('Response status: ${response.statusCode}');
        return false;
      }
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
                controller: subjectController,
                decoration: InputDecoration(
                  hintText: "SUBJECT",
                  labelText: "Subject",
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
                controller: fileController, // Display selected file name
                decoration: InputDecoration(
                  hintText: "FILENAME",
                  labelText: "File Name",
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
              ElevatedButton(
                onPressed: () async {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles(allowMultiple: false);
                  if (result != null) {
                    _filePath = result.files.single.path;
                    fileController.text =
                        result.files.single.name; // Update file name
                  } else {
                    // User canceled the file selection
                  }
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.attach_file),
                    SizedBox(width: 5),
                    Text('Attach File'),
                  ],
                ),
              ),
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
                    'file_path': _filePath,
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
