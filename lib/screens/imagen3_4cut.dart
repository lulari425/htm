import 'dart:convert';
import 'dart:io'; // File management
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_remote_config/firebase_remote_config.dart';
import '../utils/app_const.dart';
import 'package:gallery_saver_updated/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class Imagen4CutScreen extends StatefulWidget {
  const Imagen4CutScreen({super.key});

  @override
  Imagen4CutScreenState createState() => Imagen4CutScreenState();
}

class Imagen4CutScreenState extends State<Imagen4CutScreen> {
  String apiUrl = ''; // API URL from Remote Config
  String accessToken = ''; // Access Token from Remote Config
  List<String?> base64Images = List.filled(4, null); // 4 base64 images
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchRemoteConfigValues(); // Load Remote Config values
  }

  Future<void> fetchRemoteConfigValues() async {
    final remoteConfig = FirebaseRemoteConfig.instance;

    try {
      await remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: Duration.zero, // Fetch latest every time
        ),
      );

      await remoteConfig.fetchAndActivate();

      setState(() {
        apiUrl = remoteConfig.getString('apiUrl');
        accessToken = remoteConfig.getString('accessToken');
        print('Fetched API URL: $apiUrl');
        print('Fetched Access Token: $accessToken');
      });
    } catch (e) {
      print('Failed to fetch remote config: $e');
    }
  }

  Future<void> generate4PanelImage(String prompt) async {
    if (apiUrl.isEmpty || accessToken.isEmpty) {
      print('Missing API URL or access token.');
      return;
    }
    setState(() {
      isLoading = true; // Show loading indicator
    });

    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      "instances": [
        // {"prompt": "Generate 4-panel images for: $prompt"}
        {
          "prompt":
              "이 $prompt 에서 답변 형식으로 나온 4-panel 이미지 prompt에 대해 4-panel images로 묘사 해줘."
        }
      ],
      "parameters": {
        "sampleCount": 1,
        "negativePrompt": guidlines,
        "language": "ko"
      }
    });

    print('Request Headers: $headers');
    print('Request Body: $body');

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: body,
      );

      debugPrint('Response Body: ${response.body}', wrapWidth: 2048);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData.containsKey('predictions') &&
            responseData['predictions'] != null) {
          setState(() {
            for (int i = 0; i < 4; i++) {
              base64Images[i] =
                  responseData['predictions'][i]['bytesBase64Encoded'];
            }
            isLoading = false; // Stop loading
          });
        } else {
          throw Exception('Invalid response structure: ${response.body}');
        }
      } else {
        throw Exception('Failed to generate image: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false; // Stop loading
      });
    }
  }

  Future<void> saveImageToGallery() async {
    try {
      final dir = await getTemporaryDirectory();

      for (int i = 0; i < base64Images.length; i++) {
        if (base64Images[i] != null) {
          final bytes = base64Decode(base64Images[i]!);
          final file = File('${dir.path}/generated_image_$i.png');
          await file.writeAsBytes(bytes);

          await GallerySaver.saveImage(file.path, albumName: '4 cut AI Images');
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Images saved to gallery!')),
      );
    } catch (e) {
      print('Error saving images: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save images.')),
      );
    }
  }

  Future<void> shareImages() async {
    try {
      final dir = await getTemporaryDirectory();
      List<XFile> files = [];

      for (int i = 0; i < base64Images.length; i++) {
        if (base64Images[i] != null) {
          final bytes = base64Decode(base64Images[i]!);
          final file = File('${dir.path}/shared_image_$i.png');
          await file.writeAsBytes(bytes);
          files.add(XFile(file.path));
        }
      }

      await Share.shareXFiles(files,
          text: 'Check out these AI-generated images!');
    } catch (e) {
      print('Error sharing images: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to share images.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String prompt = ModalRoute.of(context)!.settings.arguments as String;
    print("Prompt: $prompt");

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Imagen3 - 4컷 AI 이미지 생성',
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              Navigator.pushNamed(context, '/'); // Navigate to Home
            },
          ),
        ],
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : base64Images.every((img) => img != null)
                ? SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Wrap(
                          spacing: 10.0,
                          runSpacing: 10.0,
                          children: List.generate(
                            4,
                            (index) =>
                                ImageDisplay(base64Image: base64Images[index]!),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: saveImageToGallery,
                          child: const Text('Save All to Gallery'),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: shareImages,
                          child: const Text('Share All Images'),
                        ),
                      ],
                    ),
                  )
                : const Text('Press the button to generate 4-panel images.'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          generate4PanelImage(prompt);
        },
        child: const Icon(Icons.image),
      ),
    );
  }
}

class ImageDisplay extends StatelessWidget {
  final String base64Image;

  const ImageDisplay({super.key, required this.base64Image});

  @override
  Widget build(BuildContext context) {
    final decodedBytes = base64Decode(base64Image);
    return Image.memory(decodedBytes);
  }
}
