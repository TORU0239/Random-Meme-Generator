import 'package:flutter/material.dart';

/// A function type that generates memes for a given keyword.
typedef MemeGenerator = Future<List<String>> Function(String keyword);

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

// The demo generator is removed; generation now uses the real API via MemeService.

