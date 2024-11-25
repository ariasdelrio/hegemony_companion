import 'package:flutter/material.dart';
import 'package:hegemony_helper/model/automa/priority.dart';
import 'package:hegemony_helper/view/priority_editor/priority_chart.dart';
import 'package:hegemony_helper/view/priority_editor/priority_state_editor.dart';

void main() {
  runApp(const HegemonCompanion());
}

class HegemonCompanion extends StatelessWidget {
  const HegemonCompanion({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hegemon Companion',
      theme: ThemeData(
        // colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF5C5A5A)),
        useMaterial3: true,
      ),
      home: const PriorityStateEditor(),
    );
  }
}

