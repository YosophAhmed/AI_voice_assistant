import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:voice_assistant/core/constants.dart';

class OpenAIService {
  final List<Map<String, String>> messages = [];

  Future<String> isArtPromptAPI(String prompt) async {
    try {
      final response = await http.post(
        Uri.parse(
          Constants.baseUrl,
        ),
        headers: {
          "Content-Type": "application/json",
          "Authorization": 'Bearer ${Constants.apiKey}',
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo",
          'messages': [
            {
              'role': 'user',
              'content':
                  'Does this message want to generate an AI picture, image, art or anything similar? $prompt . Simply answer with a yes or no.',
            }
          ],
        }),
      );
      if (response.statusCode == 200) {
        String content =
            jsonDecode(response.body)['choices'][0]['message']['content'];
        content = content.trim();
        switch (content) {
          case 'Yes':
          case 'yes':
          case 'Yes.':
          case 'yes.':
            return await dallEAPI(prompt);
          default:
            return await chatGPTAPI(prompt);
        }
      }
      return 'An Internal Error occurred';
    } catch (error) {
      return error.toString();
    }
  }

  Future<String> chatGPTAPI(String prompt) async {
    messages.add({
      'role': 'user',
      'content': prompt,
    });
    try {
      final response = await http.post(
        Uri.parse(
          Constants.baseUrl,
        ),
        headers: {
          "Content-Type": "application/json",
          "Authorization": 'Bearer ${Constants.apiKey}',
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo",
          'messages': messages,
        }),
      );
      if (response.statusCode == 200) {
        String content =
            jsonDecode(response.body)['choices'][0]['message']['content'];
        content = content.trim();
        debugPrint(content);
        messages.add({
          'role': 'assistant',
          'content': content,
        });
        return content;
      }
      return 'An Internal Error occurred';
    } catch (error) {
      return error.toString();
    }
  }

  Future<String> dallEAPI(String prompt) async {
    messages.add({
      'role': 'user',
      'content': prompt,
    });
    try {
      final response = await http.post(
        Uri.parse(
          Constants.imageBaseUrl,
        ),
        headers: {
          "Content-Type": "application/json",
          "Authorization": 'Bearer ${Constants.apiKey}',
        },
        body: jsonEncode({
          'prompt': prompt,
          'n': 1,
        }),
      );
      if (response.statusCode == 200) {
        String imageUrl = jsonDecode(response.body)['data'][0]['url'];
        imageUrl = imageUrl.trim();
        messages.add({
          'role': 'assistant',
          'content': imageUrl,
        });
        debugPrint(prompt);
        debugPrint(imageUrl);
        return imageUrl;
      } else {
        return 'An Internal Error occurred';
      }
    } catch (error) {
      return error.toString();
    }
  }
}
