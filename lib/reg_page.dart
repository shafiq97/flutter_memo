import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegPage extends StatefulWidget {
  const RegPage({Key? key}) : super(key: key);

  @override
  _RegPageState createState() => _RegPageState();
}

class _RegPageState extends State<RegPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _wilayahController = TextEditingController();
  final _departmentController = TextEditingController();
  final _positionController = TextEditingController();
  final _telNoController = TextEditingController();
  String _selectedItem = 'Pengurus Kanan/ Pengurus';
  String _selectedWilayah = 'Wilayah Utara 1';
  String _selectedDepartment = 'Jabatan Undang-undang';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _wilayahController.dispose();
    _departmentController.dispose();
    _positionController.dispose();
    _telNoController.dispose();
    super.dispose();
  }

  Future<dynamic> registerUser(
      dynamic email,
      dynamic password,
      dynamic confirmPassword,
      dynamic wilayah,
      dynamic department,
      dynamic position,
      dynamic telNo) async {
    const dynamic apiUrl =
        'http://192.168.68.105/memo_api/register.php'; // Replace with the actual API endpoint URL

    final Map<dynamic, dynamic> requestBody = {
      'email': email,
      'password': password,
      'confirm_password': confirmPassword,
      'wilayah': wilayah,
      'department': department,
      'position': position,
      'tel_no': telNo,
    };

    try {
      final response = await http.post(Uri.parse(apiUrl), body: requestBody);
      if (response.statusCode == 200) {
        print('Response body: ${response.body}');

        final responseJson = json.decode(response.body);
        if (responseJson['success'] == true) {
          log('got here');
          return responseJson['message'];
        } else {
          print('got not success');
          return responseJson['error'];
        }
      } else {
        return 'Error: ${response.body.toString()}';
      }
    } catch (e) {
      return 'Error: $e';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SADA Staff'),
      ),
      body: SingleChildScrollView(
        // scrollDirection: Axis.vertical,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50.0),
              const Text(
                'New Registration',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 40.0),
              ),
              const SizedBox(height: 10.0),
              Image.asset(
                'images/sada.png',
                height: 200.0,
                width: 200.0,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                margin: const EdgeInsets.only(top: 10.0),
                child: TextFormField(
                  controller: _emailController,
                  // obscureText: true,
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    prefixIcon: Icon(Icons.email_sharp),
                    hintText: 'E-mail',
                    fillColor: Colors.grey,
                    filled: true,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                margin: const EdgeInsets.only(top: 10.0),
                child: TextFormField(
                  controller: _passwordController,
                  // obscureText: true,
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    prefixIcon: Icon(Icons.lock),
                    hintText: 'Password',
                    fillColor: Colors.grey,
                    filled: true,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                margin: const EdgeInsets.only(top: 10.0),
                child: TextFormField(
                  controller: _confirmPasswordController,
                  // obscureText: true,
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    prefixIcon: Icon(Icons.lock),
                    hintText: 'Confirm Password',
                    fillColor: Colors.grey,
                    filled: true,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                margin: const EdgeInsets.only(top: 10.0),
                child: DropdownButtonFormField<String>(
                  value: _selectedWilayah,
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    prefixIcon: Icon(Icons.apartment),
                    hintText: 'Wilayah',
                    fillColor: Colors.grey,
                    filled: true,
                  ),
                  items: <String>[
                    'Wilayah Utara 1',
                    'Wilayah Utara 2',
                    'Wilayah Selatan',
                    'Wilayah Tengah',
                    'Wilayah Langkawi',
                    'Wilayah Timur'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedWilayah = newValue!;
                      _wilayahController.text = newValue;
                    });
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                margin: const EdgeInsets.only(top: 10.0),
                child: DropdownButtonFormField<String>(
                  value: _selectedDepartment,
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    prefixIcon: Icon(Icons.apartment),
                    hintText: 'Department',
                    fillColor: Colors.grey,
                    filled: true,
                  ),
                  items: <String>[
                    'Jabatan Undang-undang',
                    'Jabatan Korporat',
                    'Jabatan Pembangunan/R&D',
                    'Jabatan Sumber Manusia',
                    'Jabatan Hasil',
                    'Jabatan Mekanikal/Elektrikal',
                    'Jabatan Pengguna',
                    'Jabatan Audit dalam, pengurusan & integriti',
                    'Jabatan Kewangan',
                    'Jabatan Ukur Bahan',
                    'Jabatan Pengeluaran',
                    'Jabatan Perumahan',
                    'Jabatan Keselamatan',
                    'Jabatan Teknologi Maklumat',
                    'Jabatan Pengurusan Aset',
                    'Jabatan Agihan/NRW'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedDepartment = newValue!;
                      _departmentController.text = newValue;
                    });
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                margin: const EdgeInsets.only(top: 10.0),
                child: DropdownButtonFormField<String>(
                  value: _selectedItem,
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    prefixIcon: Icon(Icons.person_pin_rounded),
                    hintText: 'Position',
                    fillColor: Colors.grey,
                    filled: true,
                  ),
                  items: <String>['Pengurus Kanan/ Pengurus', 'Staff', 'Admin']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedItem = newValue!;
                      _positionController.text = newValue;
                    });
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                margin: const EdgeInsets.only(top: 10.0),
                child: TextFormField(
                  controller: _telNoController,
                  // obscureText: true,
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    prefixIcon: Icon(Icons.phone),
                    hintText: 'Tel No',
                    fillColor: Colors.grey,
                    filled: true,
                  ),
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
                  dynamic message = await registerUser(
                      _emailController.text,
                      _passwordController.text,
                      _confirmPasswordController.text,
                      _wilayahController.text,
                      _departmentController.text,
                      _positionController.text,
                      _telNoController.text);
                  if (message != null) {
                    // Display a snackbar with the registration result message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(message)),
                    );
                  }
                },
                child: const Text('Register'),
              ),
            ],
            //child: const Text('Register'),
          ),
        ),
      ),
    );
  }
}
