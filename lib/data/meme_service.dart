import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:anytalk_meme/core/config.dart';

class MemeService {
  MemeService({
    http.Client? client,
    String? endpoint,
    String? model,
    Duration? timeout,
  }) : _client = client ?? http.Client(),
       _endpoint = endpoint ?? openaiEndpoint,
       _model = model ?? openaiModel,
       _timeout = timeout ?? const Duration(milliseconds: openaiTimeoutMs);

  final http.Client _client;
  final String _endpoint;
  final String _model;
  final Duration _timeout;

  /// Generate 1–3 memes using OpenAI API
  Future<List<String>> generate({
    required String keyword,
    int maxCount = 3,
    double temperature = 0.9,
  }) async {
    if (openaiApiKey.isEmpty) {
      throw const FormatException('OPENAI_API_KEY not set');
    }

    final headers = <String, String>{
      'Authorization': 'Bearer $openaiApiKey',
      'Content-Type': 'application/json',
    };

    final prompt = _buildPrompt(keyword.trim(), maxCount);

    final body = jsonEncode({
      'model': _model,
      'temperature': temperature,
      'messages': [
        {
          'role': 'system',
          'content':
              'You are a Korean comedy writer. Only output punchy one-liner memes in Korean. No preface, no numbering.',
        },
        {'role': 'user', 'content': prompt},
      ],
    });

    final res = await _client
        .post(Uri.parse(_endpoint), headers: headers, body: body)
        .timeout(_timeout);

    if (res.statusCode != 200) {
      throw HttpExceptionDetailed('HTTP ${res.statusCode}', res.body);
    }

    final map = jsonDecode(res.body) as Map<String, dynamic>;
    final content =
        map['choices']?[0]?['message']?['content']?.toString() ?? '';

    // Clean up output
    final lines = content
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .map((l) => l.replaceFirst(RegExp(r'^[-•*\d\.\)\s]+'), ''))
        .take(maxCount)
        .toList();

    return lines;
  }

  /// Build user prompt
  String _buildPrompt(String keyword, int maxCount) {
    final rules =
        '''
Format:
- Exactly $maxCount lines
- Each line is a single Korean one-liner meme
- No numbering, bullets, quotes, or commentary
''';

    if (keyword.isEmpty) {
      return '''
Topic: random (daily life, work, development, love, coffee, etc.)
$rules
Generate now.
''';
    }
    return '''
Keyword: "$keyword"
$rules
Generate now.
''';
  }

  void close() => _client.close();
}

/// Detailed exception with HTTP response body
class HttpExceptionDetailed implements Exception {
  const HttpExceptionDetailed(this.message, this.body);

  final String message;
  final String body;

  @override
  String toString() => 'HttpExceptionDetailed: $message\n$body';
}
