import 'package:flutter_test/flutter_test.dart';
import 'package:polisphere/benue/lga_intelligence_data.dart';

void main() {
  test('covers all 23 Benue LGAs exactly once', () {
    expect(lgaIntelligenceProfiles.length, 23);
    final names = lgaIntelligenceProfiles.map((e) => e.lga).toSet();
    expect(names.length, 23);
  });

  test('uses official senatorial-zone grouping', () {
    expect(intelligenceProfileFor('Konshisha').zone, startsWith('Zone A'));
    expect(intelligenceProfileFor('Makurdi').zone, startsWith('Zone B'));
    expect(intelligenceProfileFor('Otukpo').zone, startsWith('Zone C'));
  });

  test('every LGA carries 2015 2019 2023 narrative slots and 2027 outlook', () {
    for (final profile in lgaIntelligenceProfiles) {
      expect(profile.cycles.map((e) => e.year).toSet(), {2015, 2019, 2023});
      expect(profile.outlook2027.publicIssues, isNotEmpty);
      expect(profile.outlook2027.structuralFactors, isNotEmpty);
      expect(profile.outlook2027.evidenceNeeds, isNotEmpty);
    }
  });

  test('source gaps remain explicit instead of manufacturing 2015 results', () {
    expect(
      cycleNarrativeFor('Ado', 2015)!.classification,
      LocalIntelClass.sourceGap,
    );
    expect(
      cycleNarrativeFor('Ohimini', 2015)!.classification,
      LocalIntelClass.sourceGap,
    );
  });

  test('Apa 2015 conflict is explicitly preserved for integrity review', () {
    final apa = cycleNarrativeFor('Apa', 2015)!;
    expect(apa.classification, LocalIntelClass.verifiedResult);
    expect(apa.dynamic, contains('conflicting'));
  });

  test('2027 layer remains scenario-based and source-aware', () {
    expect(verified2027CandidateFacts, isNotEmpty);
    expect(current2027SourceRegistry, isNotEmpty);
    for (final profile in lgaIntelligenceProfiles) {
      expect(profile.outlook2027.confidence, isNot(LocalIntelConfidence.high));
    }
  });
}
