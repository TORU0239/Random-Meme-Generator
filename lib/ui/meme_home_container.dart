import 'package:flutter/material.dart';
import 'package:anytalk_meme/data/meme_service.dart';
import 'package:anytalk_meme/ui/meme_home_page.dart';

/// Hosts app-level state for the home screen and owns MemeService.
class MemeHomeContainer extends StatefulWidget {
  const MemeHomeContainer({super.key});

  @override
  State<MemeHomeContainer> createState() => _MemeHomeContainerState();
}

class _MemeHomeContainerState extends State<MemeHomeContainer> {
  late final MemeService _service;

  @override
  void initState() {
    super.initState();
    _service = MemeService();
  }

  Future<List<String>> _generate(String keyword) {
    return _service.generate(keyword: keyword);
  }

  @override
  void dispose() {
    _service.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MemeHomePage(generateMemes: _generate);
  }
}

