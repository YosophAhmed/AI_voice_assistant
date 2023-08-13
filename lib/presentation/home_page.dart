import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:voice_assistant/presentation/widgets/feature_box.dart';
import 'package:voice_assistant/services/openai_service.dart';

import '../core/app_colors.dart';
import '../core/constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final speechToText = SpeechToText();
  final FlutterTts flutterTts = FlutterTts();
  String lastWords = '';
  final OpenAIService openAIService = OpenAIService();
  String? generatedContent;
  String? generatedImageUrl;

  @override
  void initState() {
    super.initState();
    initSpeechToText();
    initTextToSpeech();
  }

  Future<void> initSpeechToText() async {
    await speechToText.initialize();
    setState(() {});
  }

  Future<void> initTextToSpeech() async {
    await flutterTts.setSharedInstance(true);
    setState(() {});
  }

  Future<void> startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {});
  }

  Future<void> stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
    });
  }

  Future<void> systemSpeak({
    required String content,
  }) async {
    await flutterTts.speak(content);
  }

  @override
  void dispose() {
    super.dispose();
    speechToText.stop();
    flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'AI Voice Assistant',
          style: TextStyle(
            color: AppColors.mainFontColor,
            fontSize: 25,
            fontFamily: Constants.fontFamily,
          ),
        ),
        centerTitle: true,
        leading: const Icon(
          Icons.menu,
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Stack(
              children: [
                Center(
                  child: Container(
                    height: 120,
                    width: 120,
                    margin: const EdgeInsets.only(
                      top: 4,
                    ),
                    decoration: const BoxDecoration(
                      color: AppColors.assistantCircleColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Container(
                  height: 123,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage('assets/images/virtualAssistant.png'),
                    ),
                  ),
                ),
              ],
            ),
            Visibility(
              visible: generatedImageUrl == null,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                margin: const EdgeInsets.symmetric(
                  horizontal: 40,
                ).copyWith(
                  top: 30,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.borderColor,
                  ),
                  borderRadius: BorderRadius.circular(20).copyWith(
                    topLeft: Radius.zero,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10.0,
                  ),
                  child: Text(
                    generatedContent == null
                        ? 'Good Morning, What task can i do for you?'
                        : generatedContent!,
                    style: TextStyle(
                      color: AppColors.mainFontColor,
                      fontSize: generatedContent == null ? 25 : 18,
                      fontFamily: Constants.fontFamily,
                    ),
                  ),
                ),
              ),
            ),
            if (generatedImageUrl != null) Padding(
              padding: const EdgeInsets.all(10.0,),
              child: Image.network(generatedImageUrl!),
            ),
            Visibility(
              visible: generatedContent == null && generatedImageUrl == null,
              child: Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(
                  top: 10,
                  left: 22,
                ),
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Here are a few features',
                  style: TextStyle(
                    fontFamily: Constants.fontFamily,
                    color: AppColors.mainFontColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Visibility(
              visible: generatedContent == null && generatedImageUrl == null,
              child: const Column(
                children: [
                  FeatureBox(
                    color: AppColors.firstSuggestionBoxColor,
                    headerText: 'ChatGPT',
                    descriptionText:
                        'A smarter way to stay organized and informed with ChatGPT',
                  ),
                  FeatureBox(
                    color: AppColors.secondSuggestionBoxColor,
                    headerText: 'Dall-E',
                    descriptionText:
                        'Get inspired and stay creative with ypur personal assistant powered by Dall-E',
                  ),
                  FeatureBox(
                    color: AppColors.thirdSuggestionBoxColor,
                    headerText: 'Smart voice Assistant',
                    descriptionText:
                        'Get the best of both worlds with a voice assitant powered by Dall-E and ChatGPT',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.secondSuggestionBoxColor,
        onPressed: () async {
          if (await speechToText.hasPermission && speechToText.isNotListening) {
            await startListening();
          } else if (speechToText.isListening) {
            final speech = await openAIService.isArtPromptAPI(lastWords);
            if (speech.contains('htttps')) {
              generatedImageUrl = speech;
              generatedContent = null;
              setState(() {});
            } else {
              generatedImageUrl = null;
              generatedContent = speech;
              setState(() {});
              await systemSpeak(
                content: speech,
              );
            }
            await stopListening();
          } else {
            await initSpeechToText();
          }
        },
        child: const Icon(
          Icons.mic,
          color: Colors.black,
        ),
      ),
    );
  }
}
