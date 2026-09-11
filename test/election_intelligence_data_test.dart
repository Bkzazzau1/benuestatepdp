import 'package:flutter_test/flutter_test.dart';
import 'package:polisphere/benue/election_intelligence_data.dart';

void main() {
  test('all three election cycles carry source-aware intelligence', () {
    expect(electionCycleIntelligence.map((e) => e.year).toList(), [2015, 2019, 2023]);

    for (final cycle in electionCycleIntelligence) {
      expect(cycle.drivers, isNotEmpty);
      expect(cycle.regionalDynamics, isNotEmpty);
      expect(cycle.winningNarrative, isNotEmpty);
      expect(cycle.losingNarrative, isNotEmpty);
      expect(cycle.lessons, isNotEmpty);
      expect(cycle.legalAftermath, isNotEmpty);
      expect(cycle.sources, isNotEmpty);

      final sourceIds = cycle.sources.map((source) => source.id).toSet();
      for (final driver in cycle.drivers) {
        expect(driver.impact, inInclusiveRange(1, 5));
        expect(driver.sourceIds, isNotEmpty);
        expect(driver.sourceIds.every(sourceIds.contains), isTrue);
      }
      for (final region in cycle.regionalDynamics) {
        expect(region.sourceIds, isNotEmpty);
        expect(region.sourceIds.every(sourceIds.contains), isTrue);
      }
      for (final legal in cycle.legalAftermath) {
        expect(legal.sourceIds, isNotEmpty);
        expect(legal.sourceIds.every(sourceIds.contains), isTrue);
      }
    }
  });

  test('2015 explanation preserves governance and party-fracture drivers', () {
    final cycle = intelligenceForYear(2015);
    expect(cycle.winnerParty, 'APC');
    expect(cycle.winnerVotes, 422932);
    expect(cycle.runnerUpVotes, 313878);
    expect(cycle.margin, 109054);
    expect(
      cycle.drivers.any((d) =>
          d.title == 'Civil-service and pension backlash' && d.impact == 5),
      isTrue,
    );
    expect(
      cycle.drivers
          .any((d) => d.title == 'PDP primary and internal-party fracture'),
      isTrue,
    );
  });

  test('2019 explanation preserves security identity and supplementary context', () {
    final cycle = intelligenceForYear(2019);
    expect(cycle.winnerParty, 'PDP');
    expect(cycle.margin, 89318);
    expect(
      cycle.drivers.any(
          (d) => d.title == 'Security identity and anti-open-grazing stance'),
      isTrue,
    );
    expect(
      cycle.legalAftermath.any((step) => step.outcome.contains('inconclusive')),
      isTrue,
    );
  });

  test('2023 explanation preserves candidate effect and geographic APC advantage', () {
    final cycle = intelligenceForYear(2023);
    expect(cycle.winnerParty, 'APC');
    expect(cycle.margin, 250020);
    expect(
      cycle.drivers
          .any((d) => d.title == 'Alia’s candidate-centered popularity'),
      isTrue,
    );
    expect(
      cycle.drivers.any((d) =>
          d.title == 'Broad geographic APC advantage' &&
          d.evidenceType == IntelligenceEvidenceType.verifiedFact),
      isTrue,
    );
  });
}
