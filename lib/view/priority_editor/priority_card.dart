import 'dart:math';

import 'package:flutter/material.dart';

import '../../model/automa/priority.dart';

class PriorityCard extends StatelessWidget {
  static const Color cardForegroundColor = Color(0xFFEAE8E9);

  final Priority priority;
  final int level;
  final Function(int newLevel) onAdjustLevel;

  const PriorityCard({
    super.key,
    required this.priority,
    required this.level,
    required this.onAdjustLevel,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 70),
        child: GestureDetector(
          onTap: () async {
            int? newLevel = await showDialog(
              context: context,
              builder: (BuildContext context) => ChangePriorityDialog(priority: priority, level: level),
            );
            if (newLevel != null) {
              onAdjustLevel(newLevel);
            }
          },
          child: Card(
              elevation: 5,
              color: Color(priority.colorARGB),
              child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(priority.code, style: const TextStyle(color: cardForegroundColor)),
                  ))),
        ));
  }
}

class ChangePriorityDialog extends StatefulWidget {
  final Priority priority;
  final int level;

  const ChangePriorityDialog({
    super.key,
    required this.priority,
    required this.level,
  });

  @override
  State<ChangePriorityDialog> createState() => _ChangePriorityDialogState();
}

class _ChangePriorityDialogState extends State<ChangePriorityDialog> {
  @override
  void initState() {
    super.initState();
    _priority = widget.priority;
    _level = widget.level;
  }

  late Priority _priority;
  late int _level;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Color(_priority.colorARGB),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IntrinsicHeight(
              child: Row(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.center, children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Text(_priority.name,
                      style: const TextStyle(
                          fontFeatures: [FontFeature.enable('smcp')], color: PriorityCard.cardForegroundColor)),
                ),
                const VerticalDivider(
                  indent: 10,
                  color: PriorityCard.cardForegroundColor,
                ),
                Column(mainAxisSize: MainAxisSize.min, children: [
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: GestureDetector(
                        onTap: () => {
                          setState(() {
                            _level += 1;
                          })
                        },
                        child: const Icon(Icons.arrow_drop_up, color: PriorityCard.cardForegroundColor)),
                  ),
                  Text('$_level', style: const TextStyle(color: PriorityCard.cardForegroundColor)),
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: GestureDetector(
                        onTap: () => {
                          setState(() {
                            _level = max(_level - 1, _priority.type == PriorityType.policy ? 0 : 1);
                          })
                        },
                        child: const Icon(Icons.arrow_drop_down, color: PriorityCard.cardForegroundColor)),
                  ),
                ]),
              ]),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel', style: TextStyle(color: PriorityCard.cardForegroundColor)),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, _level);
                  },
                  child: const Text('Adjust priority', style: TextStyle(color: PriorityCard.cardForegroundColor)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
