import 'models.dart';

/// Canonical geography records used by imports, field assignments and
/// election-day result capture.
///
/// The catalog intentionally ships with the 23 verified Benue LGA names only.
/// Ward and polling-unit records must be imported from an approved source and
/// pass validation before they become available to production workflows.
class LgaRecord {
  const LgaRecord({
    required this.id,
    required this.name,
    required this.state,
    this.sourceReference,
  });

  final String id;
  final String name;
  final String state;
  final String? sourceReference;

  GeographicScope get scope => GeographicScope(
        level: GeographyLevel.lga,
        state: state,
        lgaId: id,
        lga: name,
      );
}

class WardRecord {
  const WardRecord({
    required this.id,
    required this.name,
    required this.lgaId,
    required this.lgaName,
    this.registrationAreaCode,
    this.sourceReference,
  });

  final String id;
  final String name;
  final String lgaId;
  final String lgaName;
  final String? registrationAreaCode;
  final String? sourceReference;

  GeographicScope get scope => GeographicScope(
        level: GeographyLevel.ward,
        state: 'Benue',
        lgaId: lgaId,
        lga: lgaName,
        wardId: id,
        ward: name,
      );
}

class PollingUnitRecord {
  const PollingUnitRecord({
    required this.id,
    required this.name,
    required this.wardId,
    required this.wardName,
    required this.lgaId,
    required this.lgaName,
    this.code,
    this.sourceReference,
  });

  final String id;
  final String name;
  final String wardId;
  final String wardName;
  final String lgaId;
  final String lgaName;
  final String? code;
  final String? sourceReference;

  GeographicScope get scope => GeographicScope(
        level: GeographyLevel.pollingUnit,
        state: 'Benue',
        lgaId: lgaId,
        lga: lgaName,
        wardId: wardId,
        ward: wardName,
        pollingUnitId: id,
        pollingUnit: name,
      );
}

class GeographyCatalog {
  const GeographyCatalog({
    required this.lgas,
    required this.wards,
    required this.pollingUnits,
    required this.version,
    required this.importedAt,
    required this.sourceName,
  });

  final List<LgaRecord> lgas;
  final List<WardRecord> wards;
  final List<PollingUnitRecord> pollingUnits;
  final String version;
  final DateTime importedAt;
  final String sourceName;

  List<WardRecord> wardsForLga(String lgaId) =>
      wards.where((ward) => ward.lgaId == lgaId).toList(growable: false);

  List<PollingUnitRecord> pollingUnitsForWard(String wardId) => pollingUnits
      .where((unit) => unit.wardId == wardId)
      .toList(growable: false);

  List<PollingUnitRecord> pollingUnitsForLga(String lgaId) => pollingUnits
      .where((unit) => unit.lgaId == lgaId)
      .toList(growable: false);

  LgaRecord? lgaByName(String name) {
    final normalized = name.trim().toLowerCase();
    for (final lga in lgas) {
      if (lga.name.toLowerCase() == normalized) return lga;
    }
    return null;
  }
}

class GeographyImportIssue {
  const GeographyImportIssue({
    required this.code,
    required this.message,
    required this.severity,
    this.recordId,
  });

  final String code;
  final String message;
  final GeographyImportIssueSeverity severity;
  final String? recordId;
}

enum GeographyImportIssueSeverity { warning, error }

class GeographyValidationResult {
  const GeographyValidationResult({required this.issues});

  final List<GeographyImportIssue> issues;

  bool get isValid =>
      !issues.any((issue) => issue.severity == GeographyImportIssueSeverity.error);

  int get errorCount => issues
      .where((issue) => issue.severity == GeographyImportIssueSeverity.error)
      .length;

  int get warningCount => issues
      .where((issue) => issue.severity == GeographyImportIssueSeverity.warning)
      .length;
}

class GeographyCatalogValidator {
  const GeographyCatalogValidator._();

  static GeographyValidationResult validate(GeographyCatalog catalog) {
    final issues = <GeographyImportIssue>[];
    final lgaIds = <String>{};
    final lgaNames = <String>{};
    final wardIds = <String>{};
    final pollingUnitIds = <String>{};

    if (catalog.lgas.length != 23) {
      issues.add(GeographyImportIssue(
        code: 'LGA_COUNT_MISMATCH',
        message:
            'Expected 23 Benue LGAs but received ${catalog.lgas.length}.',
        severity: GeographyImportIssueSeverity.error,
      ));
    }

    for (final lga in catalog.lgas) {
      final id = lga.id.trim();
      final name = lga.name.trim();
      if (id.isEmpty || name.isEmpty) {
        issues.add(GeographyImportIssue(
          code: 'LGA_REQUIRED_FIELD',
          message: 'LGA id and name are required.',
          severity: GeographyImportIssueSeverity.error,
          recordId: lga.id,
        ));
      }
      if (!lgaIds.add(id)) {
        issues.add(GeographyImportIssue(
          code: 'DUPLICATE_LGA_ID',
          message: 'Duplicate LGA id: $id',
          severity: GeographyImportIssueSeverity.error,
          recordId: id,
        ));
      }
      final normalizedName = name.toLowerCase();
      if (!lgaNames.add(normalizedName)) {
        issues.add(GeographyImportIssue(
          code: 'DUPLICATE_LGA_NAME',
          message: 'Duplicate LGA name: $name',
          severity: GeographyImportIssueSeverity.error,
          recordId: id,
        ));
      }
      if (lga.state.trim().toLowerCase() != 'benue') {
        issues.add(GeographyImportIssue(
          code: 'INVALID_STATE',
          message: 'LGA $name is not assigned to Benue State.',
          severity: GeographyImportIssueSeverity.error,
          recordId: id,
        ));
      }
    }

    for (final ward in catalog.wards) {
      if (ward.id.trim().isEmpty || ward.name.trim().isEmpty) {
        issues.add(GeographyImportIssue(
          code: 'WARD_REQUIRED_FIELD',
          message: 'Ward id and name are required.',
          severity: GeographyImportIssueSeverity.error,
          recordId: ward.id,
        ));
      }
      if (!wardIds.add(ward.id)) {
        issues.add(GeographyImportIssue(
          code: 'DUPLICATE_WARD_ID',
          message: 'Duplicate ward id: ${ward.id}',
          severity: GeographyImportIssueSeverity.error,
          recordId: ward.id,
        ));
      }
      if (!lgaIds.contains(ward.lgaId)) {
        issues.add(GeographyImportIssue(
          code: 'UNKNOWN_WARD_LGA',
          message:
              'Ward ${ward.name} references unknown LGA id ${ward.lgaId}.',
          severity: GeographyImportIssueSeverity.error,
          recordId: ward.id,
        ));
      }
      final parent = catalog.lgas
          .where((lga) => lga.id == ward.lgaId)
          .cast<LgaRecord?>()
          .firstOrNull;
      if (parent != null && parent.name != ward.lgaName) {
        issues.add(GeographyImportIssue(
          code: 'WARD_PARENT_NAME_MISMATCH',
          message:
              'Ward ${ward.name} says ${ward.lgaName}, but parent id resolves to ${parent.name}.',
          severity: GeographyImportIssueSeverity.error,
          recordId: ward.id,
        ));
      }
    }

    for (final unit in catalog.pollingUnits) {
      if (unit.id.trim().isEmpty || unit.name.trim().isEmpty) {
        issues.add(GeographyImportIssue(
          code: 'PU_REQUIRED_FIELD',
          message: 'Polling-unit id and name are required.',
          severity: GeographyImportIssueSeverity.error,
          recordId: unit.id,
        ));
      }
      if (!pollingUnitIds.add(unit.id)) {
        issues.add(GeographyImportIssue(
          code: 'DUPLICATE_PU_ID',
          message: 'Duplicate polling-unit id: ${unit.id}',
          severity: GeographyImportIssueSeverity.error,
          recordId: unit.id,
        ));
      }
      if (!wardIds.contains(unit.wardId)) {
        issues.add(GeographyImportIssue(
          code: 'UNKNOWN_PU_WARD',
          message:
              'Polling unit ${unit.name} references unknown ward id ${unit.wardId}.',
          severity: GeographyImportIssueSeverity.error,
          recordId: unit.id,
        ));
      }
      if (!lgaIds.contains(unit.lgaId)) {
        issues.add(GeographyImportIssue(
          code: 'UNKNOWN_PU_LGA',
          message:
              'Polling unit ${unit.name} references unknown LGA id ${unit.lgaId}.',
          severity: GeographyImportIssueSeverity.error,
          recordId: unit.id,
        ));
      }
      final parentWard = catalog.wards
          .where((ward) => ward.id == unit.wardId)
          .cast<WardRecord?>()
          .firstOrNull;
      if (parentWard != null && parentWard.lgaId != unit.lgaId) {
        issues.add(GeographyImportIssue(
          code: 'PU_PARENT_MISMATCH',
          message:
              'Polling unit ${unit.name} has an LGA that does not match its parent ward.',
          severity: GeographyImportIssueSeverity.error,
          recordId: unit.id,
        ));
      }
    }

    if (catalog.wards.isEmpty) {
      issues.add(const GeographyImportIssue(
        code: 'NO_WARDS_IMPORTED',
        message: 'No ward records have been imported yet.',
        severity: GeographyImportIssueSeverity.warning,
      ));
    }

    if (catalog.pollingUnits.isEmpty) {
      issues.add(const GeographyImportIssue(
        code: 'NO_POLLING_UNITS_IMPORTED',
        message: 'No polling-unit records have been imported yet.',
        severity: GeographyImportIssueSeverity.warning,
      ));
    }

    return GeographyValidationResult(issues: List.unmodifiable(issues));
  }
}

/// Extension kept private to this domain file so we do not add a package just
/// to express an optional first result.
extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull {
    final iterator = this.iterator;
    if (!iterator.moveNext()) return null;
    return iterator.current;
  }
}

class BenueBaseGeography {
  const BenueBaseGeography._();

  static const lgas = <LgaRecord>[
    LgaRecord(id: 'BEN-LGA-01', name: 'Ado', state: 'Benue'),
    LgaRecord(id: 'BEN-LGA-02', name: 'Agatu', state: 'Benue'),
    LgaRecord(id: 'BEN-LGA-03', name: 'Apa', state: 'Benue'),
    LgaRecord(id: 'BEN-LGA-04', name: 'Buruku', state: 'Benue'),
    LgaRecord(id: 'BEN-LGA-05', name: 'Gboko', state: 'Benue'),
    LgaRecord(id: 'BEN-LGA-06', name: 'Guma', state: 'Benue'),
    LgaRecord(id: 'BEN-LGA-07', name: 'Gwer East', state: 'Benue'),
    LgaRecord(id: 'BEN-LGA-08', name: 'Gwer West', state: 'Benue'),
    LgaRecord(id: 'BEN-LGA-09', name: 'Katsina-Ala', state: 'Benue'),
    LgaRecord(id: 'BEN-LGA-10', name: 'Konshisha', state: 'Benue'),
    LgaRecord(id: 'BEN-LGA-11', name: 'Kwande', state: 'Benue'),
    LgaRecord(id: 'BEN-LGA-12', name: 'Logo', state: 'Benue'),
    LgaRecord(id: 'BEN-LGA-13', name: 'Makurdi', state: 'Benue'),
    LgaRecord(id: 'BEN-LGA-14', name: 'Obi', state: 'Benue'),
    LgaRecord(id: 'BEN-LGA-15', name: 'Ogbadibo', state: 'Benue'),
    LgaRecord(id: 'BEN-LGA-16', name: 'Ohimini', state: 'Benue'),
    LgaRecord(id: 'BEN-LGA-17', name: 'Oju', state: 'Benue'),
    LgaRecord(id: 'BEN-LGA-18', name: 'Okpokwu', state: 'Benue'),
    LgaRecord(id: 'BEN-LGA-19', name: 'Otukpo', state: 'Benue'),
    LgaRecord(id: 'BEN-LGA-20', name: 'Tarka', state: 'Benue'),
    LgaRecord(id: 'BEN-LGA-21', name: 'Ukum', state: 'Benue'),
    LgaRecord(id: 'BEN-LGA-22', name: 'Ushongo', state: 'Benue'),
    LgaRecord(id: 'BEN-LGA-23', name: 'Vandeikya', state: 'Benue'),
  ];

  static GeographyCatalog emptyVerifiedSkeleton({
    String version = 'base-1',
    String sourceName = 'Benue base geography',
  }) =>
      GeographyCatalog(
        lgas: lgas,
        wards: const [],
        pollingUnits: const [],
        version: version,
        importedAt: DateTime.now().toUtc(),
        sourceName: sourceName,
      );
}
