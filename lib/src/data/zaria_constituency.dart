/// Real ward and polling-unit data for Zaria Federal Constituency, Kaduna
/// State, sourced from the INEC ward/polling-unit register. Every sample
/// dataset in the prototype (agents, incidents, alerts, wards, maps, etc.)
/// is drawn from this constituency rather than fictional locations.
class WardInfo {
  const WardInfo({
    required this.code,
    required this.name,
    required this.pollingUnitCount,
  });

  /// Two-digit INEC ward code, e.g. '01'.
  final String code;

  /// Ward name, e.g. "Kwarbai 'A'".
  final String name;

  /// Number of polling units registered in this ward.
  final int pollingUnitCount;

  /// INEC polling-unit code prefix for this ward, e.g. '18-23-01'.
  String get inecPrefix => '18-23-$code';

  /// Full INEC polling-unit code for a given unit number in this ward,
  /// e.g. pollingUnitCode(14) => '18-23-01-014'.
  String pollingUnitCode(int number) =>
      '$inecPrefix-${number.toString().padLeft(3, '0')}';
}

class ZariaConstituency {
  const ZariaConstituency._();

  static const state = 'Kaduna';
  static const lga = 'Zaria';
  static const name = 'Zaria Federal Constituency';

  static const wards = <WardInfo>[
    WardInfo(code: '01', name: "Kwarbai 'A'", pollingUnitCount: 51),
    WardInfo(code: '02', name: "Kwarbai 'B'", pollingUnitCount: 65),
    WardInfo(code: '03', name: 'Ung. Juma', pollingUnitCount: 38),
    WardInfo(code: '04', name: 'Limancin-Kona', pollingUnitCount: 47),
    WardInfo(code: '05', name: 'Kaura', pollingUnitCount: 49),
    WardInfo(code: '06', name: 'Tudun Wada', pollingUnitCount: 71),
    WardInfo(code: '07', name: 'Gyallesu', pollingUnitCount: 41),
    WardInfo(code: '08', name: 'Ung. Fatika', pollingUnitCount: 38),
    WardInfo(code: '09', name: 'Tukur Tukur', pollingUnitCount: 45),
    WardInfo(code: '10', name: 'Dambo', pollingUnitCount: 35),
    WardInfo(code: '11', name: 'Wucicciri', pollingUnitCount: 24),
    WardInfo(code: '12', name: 'Dutsen Abba', pollingUnitCount: 38),
    WardInfo(code: '13', name: 'Kufena', pollingUnitCount: 42),
  ];

  static int get totalWards => wards.length;

  static int get totalPollingUnits =>
      wards.fold(0, (sum, w) => sum + w.pollingUnitCount);

  static WardInfo wardByName(String name) =>
      wards.firstWhere((w) => w.name == name);
}
