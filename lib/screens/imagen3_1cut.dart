import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_remote_config/firebase_remote_config.dart';
import '../utils/app_const.dart';
import 'package:gallery_saver_updated/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io'; // 파일 처리를 위한 dart:io 패키지 추가

class ImagenTestScreen extends StatefulWidget {
  const ImagenTestScreen({super.key});

  @override
  ImagenTestScreenState createState() => ImagenTestScreenState();
}

class ImagenTestScreenState extends State<ImagenTestScreen> {
  String apiUrl = ''; // Remote Config에서 가져올 API URL
  String accessToken = ''; // Remote Config에서 가져올 토큰
  String? base64Image; // base64 인코딩된 이미지를 저장할 변수
  bool isLoading = false;
  // String prompt = "";
  // final TextEditingController _promptController =
  //     TextEditingController(); // 사용자 입력을 받을 텍스트 필드 컨트롤러

  @override
  void initState() {
    super.initState();
    fetchRemoteConfigValues(); // Remote Config 값 가져오기
  }

  Future<void> fetchRemoteConfigValues() async {
    final remoteConfig = FirebaseRemoteConfig.instance;

    try {
      // Firebase Remote Config 기본 설정
      await remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10), // 요청 타임아웃 설정
          minimumFetchInterval: Duration.zero, // 매번 최신 값 가져오기
        ),
      );

      // Remote Config의 최신 값 가져오기
      await remoteConfig.fetchAndActivate();

      setState(() {
        apiUrl = remoteConfig.getString('apiUrl'); // API URL 가져오기
        accessToken =
            remoteConfig.getString('accessToken'); // Access Token 가져오기
        // isLoading = false; // 로딩 완료

        print('Fetched API URL: $apiUrl');
        print('Fetched Access Token: $accessToken');
      });
    } catch (e) {
      print('Failed to fetch remote config: $e');
      // setState(() {
      //   isLoading = false;
      // });
    }
  }

  // Vertex AI API 호출하여 이미지 생성
  Future<void> generateImage(String prompt) async {
    if (apiUrl.isEmpty || accessToken.isEmpty) {
      print('Missing API URL or access token.');
      return;
    } else {
      print(accessToken);
    }
    setState(() {
      isLoading = true; // 로딩 상태 표시
    });

    // Prepare headers and body for the POST request
    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      "instances": [
        {"prompt": "이 $prompt 에서 답변 형식으로 나온 이미지 prompt에 대해 이미지 묘사 해줘."}
      ],
      "parameters": {
        "sampleCount": 1,
        "negativePrompt": guidlines,
        "language": "ko"
      }
    });

    // Print headers and body for debugging
    print('Request Headers: $headers');
    print('Request Body: $body');

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: body,
      );

      // Print headers and body for debugging
      print('Request Headers: $headers');
      print('Request Body: $body');

      print('Response Status Code: ${response.statusCode}');
      // Print full response body using debugPrint for large content
      debugPrint('Response Body: ${response.body}', wrapWidth: 2048);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        // 응답 데이터 구조 검증
        if (responseData.containsKey('predictions') &&
            responseData['predictions'] != null &&
            responseData['predictions'].isNotEmpty) {
          setState(() {
            base64Image = responseData['predictions'][0]['bytesBase64Encoded'];
            isLoading = false; // 로딩 완료
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
        isLoading = false; // 로딩 완료
      });
    }
  }

  Future<void> saveImageToGallery() async {
    if (base64Image == null) return;

    try {
      final bytes = base64Decode(base64Image!);
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/generated_image.png');

      await file.writeAsBytes(bytes); // Corrected to await the operation

      final success =
          await GallerySaver.saveImage(file.path, albumName: '1 cut AI Images');
      if (success == true) {
        print('Image saved to gallery.');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image saved to gallery!')),
        );
      } else {
        throw Exception('Failed to save image.');
      }
    } catch (e) {
      print('Error saving image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save image.')),
      );
    }
  }

  Future<void> shareImage() async {
    if (base64Image == null) return;

    try {
      final bytes = base64Decode(base64Image!);
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/shared_image.png');

      await file.writeAsBytes(bytes); // Corrected to await the operation

      await Share.shareXFiles([XFile(file.path)],
          text: 'Check out this AI-generated image!');
    } catch (e) {
      print('Error sharing image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to share image.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String prompt = ModalRoute.of(context)!.settings.arguments as String;
    print("test:  $prompt");
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Imagen3 - 1컷 AI 이미지 생성',
          style: TextStyle(
            fontSize: 16.0, // Adjust the font size here
            fontWeight: FontWeight.bold,
          ), // Optional: Adjust weight
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
            ? const CircularProgressIndicator() // 로딩 중일 때 표시
            : base64Image != null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ImageDisplay(base64Image: base64Image!),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: saveImageToGallery,
                        child: const Text('Save to Gallery'),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: shareImage,
                        child: const Text('Share Image'),
                      ),
                    ],
                  )
                : const Text(
                    'Press the button to generate an image.'), // 아직 이미지가 없을 때 표시
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          generateImage(prompt);
        }, // 고정된 프롬프트로 이미지 생성
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
    // base64 인코딩된 이미지를 디코딩하여 메모리에서 이미지로 표시
    final decodedBytes = base64Decode(base64Image);

    return Image.memory(decodedBytes); // 디코딩된 이미지 표시
  }
}
