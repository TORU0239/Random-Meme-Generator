import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:anytalk_meme/ui/meme_home_container.dart';

void main() {
  runApp(const MemeApp());
}

class MemeApp extends StatelessWidget {
  const MemeApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Define a light color scheme; adjust if you plan to support dark mode.
    final ColorScheme scheme = ColorScheme.fromSeed(seedColor: Colors.indigo);

    return MaterialApp(
      title: 'Random Meme Generator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: scheme,
        appBarTheme: AppBarTheme(
          // Ensure the top bar is visibly distinct from the background.
          backgroundColor: scheme.surface,
          foregroundColor: scheme.onSurface,
          elevation: 1, // Give a thin shadow so it reads as a bar
          surfaceTintColor: Colors
              .transparent, // Avoid Material 3 tint making it look flat/merged
          centerTitle: true,
          // Make status bar icons dark on light backgrounds.
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
      ),
      home: const MemeHomeContainer(),
    );
  }
}
