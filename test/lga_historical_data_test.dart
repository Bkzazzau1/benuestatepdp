import 'package:flutter_test/flutter_test.dart';
import 'package:polisphere/benue/lga_historical_data.dart';

void main() {
  test('2023 LGA major-party totals reconcile to statewide declaration', () {
    expect(benueLgaResults2023.length, 23);
    expect(lgaSumForParty(2023, 'APC'), 473933);
    expect(lgaSumForParty(2023, 'PDP'), 223913);
    expect(lgaSumForParty(2023, 'LP'), 41881);

    final kwande = lgaResultFor(2023, 'Kwande');
    expect(kwande, isNotNull);
    expect(kwande!.hasElection, isFalse);
    expect(kwande.quality, LgaHistoricalQuality.noElection);
  });

  test('2019 all 23 LGA rows are loaded but marked unreconciled', () {
    expect(benueLgaResults2019.length, 23);
    expect(
      benueLgaResults2019.every(
        (row) => row.quality == LgaHistoricalQuality.publishedUnreconciled,
      ),
      isTrue,
    );
    expect(lgaHistoricalDatasetMeta[2019]!.recordsLoaded, 23);
    expect(lgaHistoricalDatasetMeta[2019]!.qualityLabel,
        'UNRECONCILED LGA TABLE');
  });

  test('2015 remains explicitly partial and never fabricates missing LGAs', () {
    expect(benueLgaResults2015.length, 15);
    expect(lgaHistoricalDatasetMeta[2015]!.recordsLoaded, 15);
    expect(lgaResultFor(2015, 'Makurdi')!.pdpVotes, 23550);
    expect(lgaResultFor(2015, 'Buruku'), isNull);
  });

  test('Makurdi comparison uses the loaded LGA records', () {
    final r2019 = lgaResultFor(2019, 'Makurdi')!;
    final r2023 = lgaResultFor(2023, 'Makurdi')!;

    expect(r2019.apcVotes, 36517);
    expect(r2019.pdpVotes, 29414);
    expect(r2023.apcVotes, 56432);
    expect(r2023.pdpVotes, 12329);
    expect(r2023.turnoutPercent, 24.84);
    expect(r2023.pdpVotes - r2019.pdpVotes, -17085);
  });
}
