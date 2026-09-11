import 'package:flutter_test/flutter_test.dart';
import 'package:polisphere/benue/app_scope.dart';

void main() {
  test('campaign scope moves through state, LGA, ward and polling unit', () {
    final scope = CampaignScopeController();

    expect(scope.isStatewide, isTrue);
    expect(scope.label, 'Benue State');

    scope.selectLga(id: 'BEN-LGA-13', name: 'Makurdi');
    expect(scope.isLga, isTrue);
    expect(scope.lgaName, 'Makurdi');
    expect(scope.label, 'Makurdi LGA');

    scope.selectWard(
      lgaId: 'BEN-LGA-13',
      lgaName: 'Makurdi',
      wardId: 'WARD-VERIFIED-ID',
      wardName: 'Verified Ward',
    );
    expect(scope.isWard, isTrue);
    expect(scope.label, 'Verified Ward • Makurdi LGA');

    scope.selectPollingUnit(
      lgaId: 'BEN-LGA-13',
      lgaName: 'Makurdi',
      wardId: 'WARD-VERIFIED-ID',
      wardName: 'Verified Ward',
      pollingUnitId: 'PU-VERIFIED-ID',
      pollingUnitName: 'Verified Polling Unit',
    );
    expect(scope.isPollingUnit, isTrue);
    expect(scope.label, 'Verified Polling Unit • Verified Ward • Makurdi');

    scope.clearToLga();
    expect(scope.isLga, isTrue);
    expect(scope.label, 'Makurdi LGA');

    scope.clearToStatewide();
    expect(scope.isStatewide, isTrue);
    expect(scope.label, 'Benue State');

    scope.dispose();
  });
}
