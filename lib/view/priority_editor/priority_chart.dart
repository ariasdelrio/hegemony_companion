import 'package:flutter/material.dart';
import 'package:hegemony_helper/view/priority_editor/priority_card.dart';

import '../../model/automa/priority.dart';

class PriorityChart extends StatefulWidget {
  final PriorityState priorityState;

  const PriorityChart({
    super.key,
    required this.priorityState,
  });

  @override
  State<PriorityChart> createState() => _PriorityChartState();
}

class _PriorityChartState extends State<PriorityChart> {
  @override
  void initState() {
    super.initState();
    _priorityState = widget.priorityState;
  }

  late PriorityState _priorityState;

  void adjustLevel(Priority priority, int newLevel) {
    setState(() {
      _priorityState = _priorityState.adjustPriority(priority, newLevel);
    });
  }

  void collapse() {
    setState(() {
      _priorityState = _priorityState.collapse();
    });
  }

  @override
  Widget build(BuildContext context) {
    var maxLevel = _priorityState.maxLevel;
    var rows = [
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <Widget>[
        Center(
            child: Padding(
          padding: const EdgeInsets.all(8),
          child: GestureDetector(
              onTap: collapse,
              child: const Icon(Icons.vertical_align_bottom, size: 30, color: Color(0xFF6A7686))),
        ))
      ])
    ];
    rows.addAll(List<int>.generate(maxLevel, (i) => maxLevel - i).map(_buildPriorityRow));

    var discardedPolicies = _priorityState.getPriorities(PriorityType.policy, 0);
    if (discardedPolicies.isEmpty) {
      return Align(alignment: Alignment.bottomCenter, child: ListView(shrinkWrap: true, children: rows));
    } else {
      return Align(
          alignment: Alignment.bottomCenter,
          child: Column(children: [
            Expanded(
                child: Align(alignment: Alignment.bottomCenter, child: ListView(shrinkWrap: true, children: rows))),
            const Divider(
              indent: 10,
              color: PriorityCard.cardForegroundColor,
            ),
            _buildPriorityRow(0)
          ]));
    }
  }

  Row _buildPriorityRow(int level) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Expanded(child: _buildPriorityRowHalf(PriorityType.action, level)),
        const Center(
            child: Padding(
                padding: EdgeInsets.all(8),
                child: Stack(alignment: AlignmentDirectional.center, children: [
                  Icon(Icons.circle, size: 30, color: Color(0xFF6A7686)),
                  Icon(size: 20, Icons.radio_button_unchecked, color: Color(0xFFFFED7A)),
                ]))),
        Expanded(
          child: _buildPriorityRowHalf(PriorityType.policy, level),
        ),
      ],
    );
  }

  Row _buildPriorityRowHalf(PriorityType type, int level) {
    var priorities = _priorityState.getPriorities(type, level);
    return Row(
        mainAxisAlignment: type == PriorityType.action ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: (type == PriorityType.action ? priorities.reversed : priorities)
            .map((priority) => Flexible(
                    child: PriorityCard(
                  priority: priority,
                  level: level,
                  onAdjustLevel: (newLevel) => adjustLevel(priority, newLevel),
                )))
            .toList());
  }
}
