import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A function type that generates memes for a given keyword.
/// Replace this with your real implementation later.
typedef MemeGenerator = Future<List<String>> Function(String keyword);

void main() {
  runApp(
    const MemeApp(
      generateMemes: _demoGenerator, // Demo generator so UI runs out of the box
    ),
  );
}

class MemeApp extends StatelessWidget {
  const MemeApp({super.key, required this.generateMemes});

  /// Injected meme generator function.
  final MemeGenerator generateMemes;

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
      home: MemeHomePage(generateMemes: generateMemes),
    );
  }
}

class MemeHomePage extends StatefulWidget {
  const MemeHomePage({super.key, required this.generateMemes});

  /// Injected meme generator function.
  final MemeGenerator generateMemes;

  @override
  State<MemeHomePage> createState() => _MemeHomePageState();
}

class _MemeHomePageState extends State<MemeHomePage> {
  final TextEditingController _controller = TextEditingController();
  bool _loading = false;
  String? _error;
  List<String> _memes = const [];

  /// Triggers generation via the injected generator and updates UI state.
  Future<void> _onGeneratePressed() async {
    final String keyword = _controller.text.trim();

    setState(() {
      _loading = true;
      _error = null;
      _memes = const [];
    });

    try {
      final List<String> memes = await widget.generateMemes(keyword);
      setState(() {
        _memes = memes;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool canSubmit = !_loading;

    return Scaffold(
      appBar: AppBar(title: const Text('Random Meme Generator')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Keyword input
            TextField(
              controller: _controller,
              onSubmitted: (_) => canSubmit ? _onGeneratePressed() : null,
              decoration: const InputDecoration(
                labelText:
                    'Keyword (e.g., coffee, interview, Android developer)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            // Generate button
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: canSubmit ? _onGeneratePressed : null,
                child: const Text('Generate Meme'),
              ),
            ),

            if (_loading) const LinearProgressIndicator(),

            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(
                'Error: $_error',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],

            const SizedBox(height: 12),

            // Result list
            Expanded(
              child: _memes.isEmpty
                  ? const Center(
                      child: Text(
                        'Generated memes will appear here.',
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : ListView.separated(
                      itemCount: _memes.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, i) {
                        return Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(
                              color: Theme.of(
                                context,
                              ).colorScheme.outlineVariant,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              _memes[i],
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A simple demo generator to keep the UI runnable without backend.
///
/// Replace this function with a real implementation, e.g.:
/// - Import your service file
/// - final service = MemeService(...);
/// - return service.generate(keyword: keyword);
Future<List<String>> _demoGenerator(String keyword) async {
  await Future.delayed(const Duration(milliseconds: 300));
  final String k = keyword.isEmpty ? 'random' : keyword;
  return <String>[
    'When I searched "$k", my coffee searched me back.',
    '"$k" was trending, so I pretended I knew why.',
    'I asked "$k" for advice; it said: try turning it off and on.',
  ];
}
