/// Centralized OpenAI configuration loaded via --dart-define.
///
/// Example run:
/// flutter run --dart-define=OPENAI_API_KEY=sk-xxxx

const String openaiApiKey = String.fromEnvironment('OPENAI_API_KEY');

const String openaiEndpoint = String.fromEnvironment(
  'OPENAI_ENDPOINT',
  defaultValue: 'https://api.openai.com/v1/chat/completions',
);

const String openaiModel = String.fromEnvironment(
  'OPENAI_MODEL',
  defaultValue: 'gpt-4o-mini',
);

const int openaiTimeoutMs = int.fromEnvironment(
  'OPENAI_TIMEOUT_MS',
  defaultValue: 25000,
);

