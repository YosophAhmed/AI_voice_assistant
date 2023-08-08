import 'package:flutter/material.dart';
import 'package:voice_assistant/presentation/widgets/feature_box.dart';

import '../core/app_colors.dart';
import '../core/constants.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
      body: Column(
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
          Container(
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
            child: const Padding(
              padding: EdgeInsets.symmetric(
                vertical: 10.0,
              ),
              child: Text(
                'Good Morning, What task can i do for you?',
                style: TextStyle(
                  color: AppColors.mainFontColor,
                  fontSize: 25,
                  fontFamily: Constants.fontFamily,
                ),
              ),
            ),
          ),
          Container(
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
          const Column(
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
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.secondSuggestionBoxColor,
        onPressed: () {},
        child: const Icon(
          Icons.mic,
          color: Colors.black,
        ),
      ),
    );
  }
}