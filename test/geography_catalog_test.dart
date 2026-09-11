import 'package:flutter_test/flutter_test.dart';
import 'package:polisphere/benue/domain/geography_catalog.dart';

void main() {
  group('GeographyCatalogValidator', () {
    test('accepts the 23-LGA base skeleton with import warnings only', () {
      final catalog = BenueBaseGeography.emptyVerifiedSkeleton();
      final result = GeographyCatalogValidator.validate(catalog);

      expect(catalog.lgas.length, 23);
      expect(result.isValid, isTrue);
      expect(result.errorCount, 0);
      expect(result.warningCount, 2);
      expect(
        result.issues.map((issue) => issue.code),
        containsAll(['NO_WARDS_IMPORTED', 'NO_POLLING_UNITS_IMPORTED']),
      );
    });

    test('rejects a ward that references an unknown LGA', () {
      final catalog = GeographyCatalog(
        lgas: BenueBaseGeography.lgas,
        wards: const [
          WardRecord(
            id: 'WARD-001',
            name: 'Example Ward',
            lgaId: 'UNKNOWN-LGA',
            lgaName: 'Unknown',
          ),
        ],
        pollingUnits: const [],
        version: 'test-1',
        importedAt: DateTime.utc(2026, 9, 11),
        sourceName: 'Unit test',
      );

      final result = GeographyCatalogValidator.validate(catalog);

      expect(result.isValid, isFalse);
      expect(
        result.issues.any((issue) => issue.code == 'UNKNOWN_WARD_LGA'),
        isTrue,
      );
    });

    test('rejects a polling unit whose LGA conflicts with its ward parent', () {
      final catalog = GeographyCatalog(
        lgas: BenueBaseGeography.lgas,
        wards: const [
          WardRecord(
            id: 'WARD-001',
            name: 'Example Ward',
            lgaId: 'BEN-LGA-13',
            lgaName: 'Makurdi',
          ),
        ],
        pollingUnits: const [
          PollingUnitRecord(
            id: 'PU-001',
            name: 'Example Polling Unit',
            wardId: 'WARD-001',
            wardName: 'Example Ward',
            lgaId: 'BEN-LGA-05',
            lgaName: 'Gboko',
          ),
        ],
        version: 'test-2',
        importedAt: DateTime.utc(2026, 9, 11),
        sourceName: 'Unit test',
      );

      final result = GeographyCatalogValidator.validate(catalog);

      expect(result.isValid, isFalse);
      expect(
        result.issues.any((issue) => issue.code == 'PU_PARENT_MISMATCH'),
        isTrue,
      );
    });
  });
}
