import 'package:flutter/material.dart';
import 'package:hegemony_helper/view/priority_editor/priority_chart.dart';

import '../../model/automa/priority.dart';

class PriorityStateEditor extends StatefulWidget {
  const PriorityStateEditor({super.key});

  @override
  State<PriorityStateEditor> createState() => _PriorityStateEditor();
}

class _PriorityStateEditor extends State<PriorityStateEditor> {
  static final PriorityState initialPriorities = PriorityState([
    (Priority.specialAction, 1),
    (Priority.lobby, 1),
    (Priority.sellCompany, 1),
    (Priority.laborMarket, 1),
    (Priority.healthcare, 1),
    (Priority.foreignTrade, 1),
    (Priority.immigration, 1),
    (Priority.buildCompany, 2),
    (Priority.sellToTheForeignMarket, 2),
    (Priority.proposeBill, 2),
    (Priority.taxation, 2),
    (Priority.fiscalPolicy, 0),
    (Priority.education, 0),
  ]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF434141),
      appBar: AppBar(
        backgroundColor: Color(0xFF22A3DB),
        foregroundColor: Color(0xFFEAE8E9),
        title: const Text('Hegemon Companion'),
      ),
      body: SafeArea(
        child: PriorityChart(priorityState: initialPriorities),
      ),
    );
  }
}