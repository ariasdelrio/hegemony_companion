import 'package:hegemony_helper/model/automa/priority.dart';
import 'package:test/test.dart';

void main() {
  test('constructor', () {
    expect(() => PriorityState([]), throwsArgumentError);
    expect(() => PriorityState([(Priority.laborMarket, -1)]), throwsArgumentError);
  });

  test('maxLevel', () {
    final ps1 = PriorityState(
        [(Priority.education, 1), (Priority.fiscalPolicy, 5), (Priority.taxation, 2), (Priority.laborMarket, 0)]);
    expect(ps1.maxLevel, 5);

    final ps2 = PriorityState([(Priority.laborMarket, 10)]);
    expect(ps2.maxLevel, 10);
  });

  test('getPriorities', () {
    final ps = PriorityState([
      (Priority.education, 1),
      (Priority.fiscalPolicy, 5),
      (Priority.taxation, 2),
      (Priority.lobby, 2),
      (Priority.laborMarket, 0),
      (Priority.healthcare, 2),
      (Priority.sellToTheForeignMarket, 2),
      (Priority.immigration, 2)
    ]);

    expect(ps.getPriorities(PriorityType.policy, 1), [Priority.education]);
    expect(ps.getPriorities(PriorityType.policy, 2), [Priority.taxation, Priority.healthcare, Priority.immigration]);
    expect(ps.getPriorities(PriorityType.policy, 2), [Priority.taxation, Priority.healthcare, Priority.immigration]);
    expect(ps.getPriorities(PriorityType.action, 2), [Priority.lobby, Priority.sellToTheForeignMarket]);
  });

  test('adjustPriority', () {
    final ps1 = PriorityState([
      (Priority.education, 1),
      (Priority.fiscalPolicy, 5),
      (Priority.taxation, 2),
      (Priority.immigration, 3),
    ]);

    final ps2 = ps1.adjustPriority(Priority.education, 3);
    expect(ps2.getPriorities(PriorityType.policy, 2), [Priority.taxation]);
    expect(ps2.getPriorities(PriorityType.policy, 5), [Priority.fiscalPolicy]);
    expect(ps2.getPriorities(PriorityType.policy, 1), []);
    expect(ps2.getPriorities(PriorityType.policy, 3), [Priority.immigration, Priority.education]);

    expect(() => PriorityState([(Priority.education, -1)]), throwsArgumentError);
  });

  test('collapse', () {
    final ps1 = PriorityState([
      (Priority.education, 1),
      (Priority.lobby, 2),
      (Priority.buildCompany, 2),
      (Priority.taxation, 2),
      (Priority.immigration, 3),
      (Priority.fiscalPolicy, 5),
      (Priority.sellToTheForeignMarket, 4),
    ]);

    final PriorityState ps2 = ps1.collapse();
    expect(ps2.getPriorities(PriorityType.policy, 1), [Priority.education]);
    expect(ps2.getPriorities(PriorityType.policy, 2), [Priority.taxation]);
    expect(ps2.getPriorities(PriorityType.policy, 3), [Priority.immigration]);
    expect(ps2.getPriorities(PriorityType.policy, 4), [Priority.fiscalPolicy]);
    expect(ps2.getPriorities(PriorityType.action, 1), [Priority.lobby, Priority.buildCompany]);
    expect(ps2.getPriorities(PriorityType.action, 2), [Priority.sellToTheForeignMarket]);
    expect(ps2.maxLevel, 4);
  });
}
