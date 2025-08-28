# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

### Setup and Dependencies
```bash
flutter pub get
```

### Running the App
```bash
# Requires OpenAI API key
flutter run --dart-define=OPENAI_API_KEY=sk-your-key-here

# Optional environment variables:
flutter run \
  --dart-define=OPENAI_API_KEY=sk-your-key \
  --dart-define=OPENAI_MODEL=gpt-4o-mini \
  --dart-define=OPENAI_ENDPOINT=https://api.openai.com/v1/chat/completions \
  --dart-define=OPENAI_TIMEOUT_MS=25000
```

### Code Quality
```bash
# Static analysis
flutter analyze

# Format code
dart format lib/

# Tests (if any exist)
flutter test
```

## Architecture Overview

This is a Flutter app that generates Korean memes using OpenAI's API. The architecture follows a clean separation of concerns:

### Core Structure
- **UI Layer**: `lib/ui/` - Contains all Flutter widgets and UI logic
- **Data Layer**: `lib/data/` - Handles external API calls and data processing
- **Core Layer**: `lib/core/` - Configuration and shared utilities

### Key Components

**MemeApp** (`lib/ui/main.dart`): Root widget that sets up Material 3 theming and navigation.

**MemeHomeContainer** (`lib/ui/meme_home_container.dart`): Stateful container that manages the `MemeService` lifecycle and provides the meme generation function to the UI.

**MemeHomePage** (`lib/ui/meme_home_page.dart`): Pure UI widget that receives a `MemeGenerator` function via dependency injection. Handles user input, loading states, and displaying results.

**MemeService** (`lib/data/meme_service.dart`): Handles OpenAI API communication. Generates 1-3 Korean memes based on keywords or random topics when no keyword is provided.

**Config** (`lib/core/config.dart`): Centralizes environment variables loaded via `--dart-define` flags.

### Architecture Pattern
The app uses a simple container/presentation pattern:
- Container components manage state and business logic
- Presentation components are pure UI that receive data via function injection
- The `MemeService` is dependency-injected through the widget tree

### API Integration
- Uses OpenAI's chat completions API with `gpt-4o-mini` model by default
- Implements custom prompt engineering for Korean meme generation
- Includes proper error handling and response cleanup
- API key must be provided via `--dart-define=OPENAI_API_KEY`

### Styling and Linting
- Uses Material 3 design system with Indigo color scheme
- Strict linting rules defined in `analysis_options.yaml` with Korean comments
- Enforces single quotes, trailing commas, and const constructors
- Excludes generated files from analysis