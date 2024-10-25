import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '/utils/app_const.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class SummaryScreen extends StatelessWidget {
  final String prompt;
  final model = GenerativeModel(
    model: geminiModelFlash,
    apiKey: apiKey,
  );

  SummaryScreen({
    super.key,
    required this.prompt,
  });

  String buildPromptTemplate(String userPrompt) {
    // 템플릿 형식으로 프롬프트 구성
    return '''
    당신은 고고학자입니다. 질문을 하는 사용자는 역사적 사실을 탐구하는 사람입니다. / 
    You are an archaeologist. The user who asks the question is a person who explores historical facts.

    다음 가이드라인을 준수하여 답변해야 합니다. / 
    Please respond in accordance with the following guidelines.

    가이드라인은 다음과 같습니다. / 
    The guidelines are as follows: $guidlines
    
    먼저 사건/인물 "$userPrompt" 에 대해 정리해주세요.
    아래 내용은 서술형으로 항목별로 나누어 작성해주세요.
    사건(인물)명 : $userPrompt,
    사건 요약 : {사건요약},
    시기 : {사건 발생한 시기},
    발발 배경 : {사건 발발 배경},
    경과 : {사건에 대한 경과},
    결과 : {사건에 대한 결과},

    그 다음 $userPrompt 에 대해서 답변의 내용을 포괄하는 단일 역사적 이미지를 생성하는 프롬프트를 작성하세요. / 
    Create a prompt to generate a single historical image that encompasses the content of the answer.

    단일 이미지 답변 형식: / Single image answer format:
    {
      '주제': <답변 내용 요약>, 
      '시대': <정확한 시대, 시기>,
      '장소': <사건 발생 장소, 건축물, 지형 등>,
      '인물': <인물의 역할, 신분, 의상, 표정, 동작 등>,
      '사건': <사건의 주요 내용, 배경, 결과 등>,
      '문화': <당시 시대의 문화, 예술, 기술, 생활 방식 등>,
      '오브젝트': <사건과 관련된 물건, 도구, 의상 등>,
      '분위기': <시대적 분위기, 사건의 분위기 등>,
      '스타일': <회화 스타일, 사진 스타일, 특정 화가의 스타일 등>,
      '기타': <추가적인 요소: 조명, 색감, 구도 등>
    }
    {
      'Topic': <summary of the answer>,
      'Era': <exact era, period>,
      'Place': <location where the event occurred, buildings, terrain, etc.>,
      'Character': <character's role, status, clothing, expression, action, etc.>,
      'Event': <main content of the event, background, results, etc.>,
      'Culture': <culture, art, technology, lifestyle of the time, etc.>,
      'Object': <objects, tools, clothing related to the event, etc.>,
      'Mood': <atmosphere of the era, atmosphere of the event, etc.>,
      'Style': <painting style, photography style, style of a specific painter, etc.>,
      'Other': <additional elements: lighting, color, composition, etc.>
    }

    단일 이미지 prompt 생성 후, 네 컷 이미지 생성: 
    Create a 4-panel image prompt for "$userPrompt" to capture different aspects consistently:
    {
      Panel 1: 'Weather: {Weather}, Background colors: {Background colors}, historical era: {historical year}, Content: {content} 
      
      Panel 2: 'Weather: {Weather}, Background colors: {Background colors}, historical era: {historical year}, Content: {content} 
      
      Panel 3: 'Weather: {Weather}, Background colors: {Background colors}, historical era: {historical year}, Content: {content} 
      
      Panel 4: 'Weather: {Weather}, Background colors: {Background colors}, historical era: {historical year}, Content: {content} 
    }
    Please follow these additional safety rules for the 4-panel prompts:

    1. Do not depict harmful, offensive, or violent content.
    2. Avoid references to copyrighted modern elements, brand names, or characters.
    3. Do not create realistic depictions of identifiable individuals, especially public figures.
    4. Avoid sexual content, nudity, or innuendos.
    5. Use clear and simple descriptions, avoiding overly complex wording.
    6. Replace historical figures' names with their titles or roles (e.g., 'the 15th-century Joseon king').
    7. Be mindful of safety restrictions, focusing on historically accurate yet neutral descriptions.


    사람의 이름(왕, 신하 등)을 사용하지 마십시오. 사람의 이름은 대명사(그, 그녀 또는 신분이나 직책, 직업)로 대체하여 표현합니다. / 
    Do not use people's names (king, subject, etc.). Replace people's names with pronouns (he, she, or their titles, positions, or occupations).
    ''';
  }

  Future<GenerateContentResponse> generateResponse() async {
    // 프롬프트를 템플릿에 맞게 재구성
    String refinedPrompt = buildPromptTemplate(prompt);
    print(refinedPrompt);
    return await model.generateContent([Content.text(refinedPrompt)]);
  }

  // Body
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("사건 요약"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: FutureBuilder<GenerateContentResponse>(
          future: generateResponse(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data == null) {
              return const Center(child: Text('No data found.'));
            } else {
              return SingleChildScrollView(
                child: Center(
                  child: Container(
                    margin: const EdgeInsets.all(5.0),
                    padding: const EdgeInsets.all(10.0),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.90,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        MarkdownBody(
                          selectable: true,
                          data: snapshot.data!.text!,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          child: const Text('Imagen3 AI 이미지 1컷 생성'),
                          onPressed: () {
                            Navigator.pushNamed(
                                context, '/imagen_1cut_generation',
                                arguments: snapshot.data!.text!);
                          },
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          child: const Text('Imagen3 AI 이미지 4컷 생성'),
                          onPressed: () {
                            Navigator.pushNamed(
                                context, '/imagen_4cut_generation',
                                arguments: snapshot.data!.text!);
                          },
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          child: const Text('Dalle AI 이미지 1컷 생성'),
                          onPressed: () {
                            Navigator.pushNamed(context, '/dalle_test');
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
