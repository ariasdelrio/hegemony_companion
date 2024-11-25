import 'dart:math';
import 'package:collection/collection.dart';

enum PriorityType {
  action,
  policy,
}

enum Priority {
  buildCompany(PriorityType.action, 'BC', 'Build Company', 0xFF22A3DB),
  proposeBill(PriorityType.action, 'PB', 'Propose Bill', 0xFFAEB0AF),
  specialAction(PriorityType.action, 'SA', 'Special Action', 0xFFED66A8),
  lobby(PriorityType.action, 'LOB', 'Lobby', 0xFFC057B1),
  sellCompany(PriorityType.action, 'SC', 'Sell Company', 0xFFFFAA55),
  sellToTheForeignMarket(PriorityType.action, 'SFM', 'Sell to the Foreign Market', 0xFFFF7074),
  fiscalPolicy(PriorityType.policy, '1', '1 - Fiscal Policy', 0xFF88AECE),
  laborMarket(PriorityType.policy, '2', '2 - Labor Market', 0xFFB5A4C6),
  taxation(PriorityType.policy, '3', '3 - Taxation', 0xFFDCA8CE),
  healthcare(PriorityType.policy, '4', '4 - Healthcare', 0xFFDC493F),
  education(PriorityType.policy, '5', '5 - Education', 0xFFD9884E),
  foreignTrade(PriorityType.policy, '6', '6 - Foreign Trade', 0xFFBDA692),
  immigration(PriorityType.policy, '7', '7 - Immigration', 0xFFAAA198);

  const Priority(this.type, this.code, this.name, this.colorARGB);

  final PriorityType type;
  final String code;
  final String name;
  final int colorARGB;
}

class PriorityState {
  final List<(Priority, int)> pl;

  const PriorityState._internal(this.pl);

  factory PriorityState(Iterable<(Priority, int)> pl) {
    if (pl.isEmpty) {
      throw ArgumentError('No priorities provided');
    }
    if (pl.any((x) => x.$2 < 0)) {
      throw ArgumentError('Level must be a positive number or zero');
    }
    return PriorityState._internal(List.unmodifiable(pl));
  }

  int get maxLevel => pl.map((x) => x.$2).reduce(max);

  List<Priority> getPriorities(PriorityType type, int level) =>
      pl.where((x) => x.$2 == level && x.$1.type == type).toList().map((x) => x.$1).toList();

  PriorityState adjustPriority(Priority priority, int newLevel) {
    return PriorityState(
        CombinedIterableView([pl.where((x) => x.$1 != priority), [(priority, newLevel)]]));
  }

  PriorityState collapse() {
    var occupiedLevels = {
      PriorityType.action: <int>{},
      PriorityType.policy: <int>{},
    };
    var maxLevel = {
      PriorityType.action: 0,
      PriorityType.policy: 0,
    };
    for (var (priority, level) in pl) {
      if (level > 0) {
        occupiedLevels[priority.type]?.add(level);
        maxLevel[priority.type] = max(maxLevel[priority.type] ?? 0, level);
      }
    }
    var levelMapping = {
      PriorityType.action: <int, int>{},
      PriorityType.policy: <int, int>{},
    };
    var nextLevel = {
      PriorityType.action: 1,
      PriorityType.policy: 1,
    };
    for (var type in PriorityType.values) {
      for (var level = 1; level <= maxLevel[type]!; level++) {
        if (occupiedLevels[type]!.contains(level)) {
          levelMapping[type]![level] = nextLevel[type]!;
          nextLevel[type] = nextLevel[type]! + 1;
        }
      }
    }

    return PriorityState(
        [for (var (priority, level) in pl) (priority, levelMapping[priority.type]![level] ?? 0)]);
  }
}



