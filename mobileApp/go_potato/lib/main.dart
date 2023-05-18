import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Potato Disease Predictor',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? _image;
  String? _predictedClass;
  double? _confidence;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final PickedFile? pickedFile =
        // ignore: deprecated_member_use
        await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });

      const String apiUrl =
          'https://asia-south1-potato-disease-openlab.cloudfunctions.net/predicthis'; // Replace with your API URL
      final Uri apiUri = Uri.parse(apiUrl);

      final http.MultipartRequest request =
          http.MultipartRequest('POST', apiUri);
      request.files
          .add(await http.MultipartFile.fromPath('file', pickedFile.path));

      final http.StreamedResponse response = await request.send();
      final String responseBody = await response.stream.bytesToString();

      final dynamic responseJson = jsonDecode(responseBody);

      setState(() {
        _predictedClass = responseJson['class'];
        _confidence = responseJson['confidence'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Potato Disease Predictor'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickImage,
        tooltip: 'Pick Image',
        child: const Icon(Icons.image),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_image != null)
            Center(
              child: Column(
                children: [
                  Image.file(_image!),
                  if (_predictedClass != null && _confidence != null)
                    Text(
                      'Prediction: $_predictedClass\nConfidence: $_confidence%',
                      style: const TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
