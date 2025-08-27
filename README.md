# Random Meme Generator (아무말 생성기)

A simple Flutter app that generates short and witty one-liner memes based on any keyword.
Powered by the OpenAI API.

## Features

- Enter any keyword (e.g., "coffee", "interview", "Android developer").

- Tap the button to generate 2–3 short Korean memes.

- If no keyword is entered, the app runs in Random Mode (topics like daily life, work, coffee, dating, etc.).

- Clean and minimal UI with Material 

## Tech Stack

- **Flutter** (cross-platform mobile framework)

- **Dart**

- **HTTP package** for REST API calls

- **OpenAI API** (gpt-4o-mini by default)

## Getting Started

### 1. Clone the repository
```
git clone https://github.com/TORU0239/random-meme-generator.git
cd random-meme-generator
```

### 2. Install dependencies
```flutter pub get```

### 3. Add your OpenAI API key
The app requires an OpenAI API key.
Run the app with the key injected via ```--dart-define```:

```flutter run --dart-define=OPENAI_API_KEY=sk-yourkey```

### 4. Internet permission (Android)
Make sure your AndroidManifest.xml includes:

```
<uses-permission android:name="android.permission.INTERNET"/>
```

## License

This project is for personal and educational use.
Feel free to fork and experiment, but no guarantees of production readiness.