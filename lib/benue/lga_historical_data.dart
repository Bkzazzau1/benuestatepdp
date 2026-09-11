enum LgaHistoricalQuality {
  reconciledMajorParties,
  publishedUnreconciled,
  partialPublished,
  noElection,
}

class LgaHistoricalResult {
  const LgaHistoricalResult({
    required this.year,
    required this.lga,
    required this.apcVotes,
    required this.pdpVotes,
    this.lpVotes = 0,
    this.otherVotes = 0,
    this.totalValidVotes,
    this.turnoutPercent,
    required this.quality,
    required this.sourceLabel,
    required this.sourceNote,
  });

  final int year;
  final String lga;
  final int apcVotes;
  final int pdpVotes;
  final int lpVotes;
  final int otherVotes;
  final int? totalValidVotes;
  final double? turnoutPercent;
  final LgaHistoricalQuality quality;
  final String sourceLabel;
  final String sourceNote;

  bool get hasElection => quality != LgaHistoricalQuality.noElection;

  Map<String, int> get knownPartyVotes => {
        'APC': apcVotes,
        'PDP': pdpVotes,
        if (lpVotes > 0) 'LP': lpVotes,
        if (otherVotes > 0) 'OTHERS': otherVotes,
      };

  String get leadingParty {
    if (!hasElection) return 'NO ELECTION';
    final entries = knownPartyVotes.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return entries.isEmpty ? 'N/A' : entries.first.key;
  }

  int get leadingVotes {
    if (!hasElection) return 0;
    final values = knownPartyVotes.values.toList()..sort((a, b) => b.compareTo(a));
    return values.isEmpty ? 0 : values.first;
  }

  int get runnerUpVotes {
    if (!hasElection) return 0;
    final values = knownPartyVotes.values.toList()..sort((a, b) => b.compareTo(a));
    return values.length < 2 ? 0 : values[1];
  }

  int get leadingMargin => leadingVotes - runnerUpVotes;

  double? get pdpKnownShare {
    final denominator = totalValidVotes ?? knownPartyVotes.values.fold<int>(0, (a, b) => a + b);
    if (denominator == 0) return null;
    return pdpVotes / denominator * 100;
  }
}

class LgaHistoricalDatasetMeta {
  const LgaHistoricalDatasetMeta({
    required this.year,
    required this.title,
    required this.source,
    required this.qualityLabel,
    required this.note,
    required this.recordsExpected,
    required this.recordsLoaded,
    required this.stateApcVotes,
    required this.statePdpVotes,
  });

  final int year;
  final String title;
  final String source;
  final String qualityLabel;
  final String note;
  final int recordsExpected;
  final int recordsLoaded;
  final int stateApcVotes;
  final int statePdpVotes;
}

const lgaHistoricalDatasetMeta = <int, LgaHistoricalDatasetMeta>{
  2015: LgaHistoricalDatasetMeta(
    year: 2015,
    title: '2015 published LGA collation extract',
    source: 'Guardian Nigeria live collation archive; statewide baseline reconciled separately to INEC declaration-derived totals.',
    qualityLabel: 'PARTIAL SECONDARY',
    note: 'Only 15 unique Benue LGA rows were recovered from the published archive. These rows are not used to manufacture statewide or missing-LGA figures.',
    recordsExpected: 23,
    recordsLoaded: 15,
    stateApcVotes: 422932,
    statePdpVotes: 313878,
  ),
  2019: LgaHistoricalDatasetMeta(
    year: 2019,
    title: '2019 LGA major-party result table',
    source: 'Published LGA collation tables cross-checked against contemporaneous INEC collation reporting; final statewide totals are from INEC EC8E.',
    qualityLabel: 'UNRECONCILED LGA TABLE',
    note: 'All 23 LGA rows are loaded, but their APC/PDP row sums do not fully reconcile to the final INEC EC8E totals because supplementary-election increments are not consistently allocated in the published LGA table. Use for geographic direction, not exact official swing.',
    recordsExpected: 23,
    recordsLoaded: 23,
    stateApcVotes: 345155,
    statePdpVotes: 434473,
  ),
  2023: LgaHistoricalDatasetMeta(
    year: 2023,
    title: '2023 LGA result table',
    source: 'Published Benue LGA result compilation cross-checked to INEC statewide declaration totals and INEC 2023 election structure.',
    qualityLabel: 'MAJOR PARTIES RECONCILED',
    note: 'APC, PDP and LP LGA columns reconcile exactly to the declared statewide totals. Kwande recorded no governorship election because of a ballot-paper error. The published Others/total-valid columns contain a 39-vote reconciliation difference and are kept as reported.',
    recordsExpected: 23,
    recordsLoaded: 23,
    stateApcVotes: 473933,
    statePdpVotes: 223913,
  ),
};

const benueLgaResults2015 = <LgaHistoricalResult>[
  LgaHistoricalResult(year: 2015, lga: 'Agatu', apcVotes: 5850, pdpVotes: 15032, quality: LgaHistoricalQuality.partialPublished, sourceLabel: 'Guardian 2015 live collation', sourceNote: 'Published LGA figure; statewide total validated separately.'),
  LgaHistoricalResult(year: 2015, lga: 'Apa', apcVotes: 7571, pdpVotes: 7132, quality: LgaHistoricalQuality.partialPublished, sourceLabel: 'Guardian 2015 live collation', sourceNote: 'Published LGA figure; statewide total validated separately.'),
  LgaHistoricalResult(year: 2015, lga: 'Gboko', apcVotes: 55002, pdpVotes: 17042, quality: LgaHistoricalQuality.partialPublished, sourceLabel: 'Guardian 2015 live collation', sourceNote: 'Published LGA figure; statewide total validated separately.'),
  LgaHistoricalResult(year: 2015, lga: 'Gwer East', apcVotes: 23831, pdpVotes: 12657, quality: LgaHistoricalQuality.partialPublished, sourceLabel: 'Guardian 2015 live collation', sourceNote: 'Published LGA figure; statewide total validated separately.'),
  LgaHistoricalResult(year: 2015, lga: 'Gwer West', apcVotes: 11844, pdpVotes: 13033, quality: LgaHistoricalQuality.partialPublished, sourceLabel: 'Guardian 2015 live collation', sourceNote: 'Published LGA figure; statewide total validated separately.'),
  LgaHistoricalResult(year: 2015, lga: 'Katsina-Ala', apcVotes: 17222, pdpVotes: 25192, quality: LgaHistoricalQuality.partialPublished, sourceLabel: 'Guardian 2015 live collation', sourceNote: 'Source labels the LGA as “K/Ala/Kala”; normalized to Katsina-Ala.'),
  LgaHistoricalResult(year: 2015, lga: 'Logo', apcVotes: 8852, pdpVotes: 26964, quality: LgaHistoricalQuality.partialPublished, sourceLabel: 'Guardian 2015 live collation', sourceNote: 'Published LGA figure; statewide total validated separately.'),
  LgaHistoricalResult(year: 2015, lga: 'Makurdi', apcVotes: 33245, pdpVotes: 23550, quality: LgaHistoricalQuality.partialPublished, sourceLabel: 'Guardian 2015 live collation', sourceNote: 'Published LGA figure; statewide total validated separately.'),
  LgaHistoricalResult(year: 2015, lga: 'Obi', apcVotes: 7786, pdpVotes: 8446, quality: LgaHistoricalQuality.partialPublished, sourceLabel: 'Guardian 2015 live collation', sourceNote: 'Published LGA figure; statewide total validated separately.'),
  LgaHistoricalResult(year: 2015, lga: 'Ogbadibo', apcVotes: 7892, pdpVotes: 7357, quality: LgaHistoricalQuality.partialPublished, sourceLabel: 'Guardian 2015 live collation', sourceNote: 'Source spelling normalized from Ogbadio/Ogbadibo.'),
  LgaHistoricalResult(year: 2015, lga: 'Oju', apcVotes: 16948, pdpVotes: 10491, quality: LgaHistoricalQuality.partialPublished, sourceLabel: 'Guardian 2015 live collation', sourceNote: 'Published LGA figure; statewide total validated separately.'),
  LgaHistoricalResult(year: 2015, lga: 'Okpokwu', apcVotes: 7209, pdpVotes: 10849, quality: LgaHistoricalQuality.partialPublished, sourceLabel: 'Guardian 2015 live collation', sourceNote: 'Published LGA figure; duplicate source row de-duplicated.'),
  LgaHistoricalResult(year: 2015, lga: 'Otukpo', apcVotes: 15751, pdpVotes: 14519, quality: LgaHistoricalQuality.partialPublished, sourceLabel: 'Guardian 2015 live collation', sourceNote: 'Published LGA figure; statewide total validated separately.'),
  LgaHistoricalResult(year: 2015, lga: 'Tarka', apcVotes: 14888, pdpVotes: 3571, quality: LgaHistoricalQuality.partialPublished, sourceLabel: 'Guardian 2015 live collation', sourceNote: 'Published LGA figure; statewide total validated separately.'),
  LgaHistoricalResult(year: 2015, lga: 'Vandeikya', apcVotes: 33175, pdpVotes: 15228, quality: LgaHistoricalQuality.partialPublished, sourceLabel: 'Guardian 2015 live collation', sourceNote: 'Published LGA figure; statewide total validated separately.'),
];

const benueLgaResults2019 = <LgaHistoricalResult>[
  LgaHistoricalResult(year: 2019, lga: 'Ado', apcVotes: 10135, pdpVotes: 10258, quality: LgaHistoricalQuality.publishedUnreconciled, sourceLabel: '2019 published LGA table', sourceNote: 'Final statewide EC8E totals remain authoritative.'),
  LgaHistoricalResult(year: 2019, lga: 'Agatu', apcVotes: 7538, pdpVotes: 10079, quality: LgaHistoricalQuality.publishedUnreconciled, sourceLabel: '2019 published LGA table', sourceNote: 'Final statewide EC8E totals remain authoritative.'),
  LgaHistoricalResult(year: 2019, lga: 'Apa', apcVotes: 8636, pdpVotes: 8725, quality: LgaHistoricalQuality.publishedUnreconciled, sourceLabel: '2019 published LGA table', sourceNote: 'Final statewide EC8E totals remain authoritative.'),
  LgaHistoricalResult(year: 2019, lga: 'Buruku', apcVotes: 13404, pdpVotes: 29656, quality: LgaHistoricalQuality.publishedUnreconciled, sourceLabel: '2019 published LGA table', sourceNote: 'Final statewide EC8E totals remain authoritative.'),
  LgaHistoricalResult(year: 2019, lga: 'Gboko', apcVotes: 29802, pdpVotes: 38241, quality: LgaHistoricalQuality.publishedUnreconciled, sourceLabel: '2019 published LGA table', sourceNote: 'Final statewide EC8E totals remain authoritative.'),
  LgaHistoricalResult(year: 2019, lga: 'Guma', apcVotes: 12005, pdpVotes: 29693, quality: LgaHistoricalQuality.publishedUnreconciled, sourceLabel: '2019 published LGA table', sourceNote: 'Final statewide EC8E totals remain authoritative.'),
  LgaHistoricalResult(year: 2019, lga: 'Gwer East', apcVotes: 15291, pdpVotes: 19596, quality: LgaHistoricalQuality.publishedUnreconciled, sourceLabel: '2019 published LGA table', sourceNote: 'Final statewide EC8E totals remain authoritative.'),
  LgaHistoricalResult(year: 2019, lga: 'Gwer West', apcVotes: 7429, pdpVotes: 14856, quality: LgaHistoricalQuality.publishedUnreconciled, sourceLabel: '2019 published LGA table', sourceNote: 'Final statewide EC8E totals remain authoritative.'),
  LgaHistoricalResult(year: 2019, lga: 'Katsina-Ala', apcVotes: 21614, pdpVotes: 17980, quality: LgaHistoricalQuality.publishedUnreconciled, sourceLabel: '2019 published LGA table', sourceNote: 'Final statewide EC8E totals remain authoritative.'),
  LgaHistoricalResult(year: 2019, lga: 'Konshisha', apcVotes: 13802, pdpVotes: 21980, quality: LgaHistoricalQuality.publishedUnreconciled, sourceLabel: '2019 published LGA table', sourceNote: 'Final statewide EC8E totals remain authoritative.'),
  LgaHistoricalResult(year: 2019, lga: 'Kwande', apcVotes: 22786, pdpVotes: 29241, quality: LgaHistoricalQuality.publishedUnreconciled, sourceLabel: '2019 published LGA table', sourceNote: 'Final statewide EC8E totals remain authoritative.'),
  LgaHistoricalResult(year: 2019, lga: 'Logo', apcVotes: 4586, pdpVotes: 30803, quality: LgaHistoricalQuality.publishedUnreconciled, sourceLabel: '2019 published LGA table', sourceNote: 'Final statewide EC8E totals remain authoritative.'),
  LgaHistoricalResult(year: 2019, lga: 'Makurdi', apcVotes: 36517, pdpVotes: 29414, quality: LgaHistoricalQuality.publishedUnreconciled, sourceLabel: '2019 published LGA table', sourceNote: 'Final statewide EC8E totals remain authoritative.'),
  LgaHistoricalResult(year: 2019, lga: 'Obi', apcVotes: 10247, pdpVotes: 9576, quality: LgaHistoricalQuality.publishedUnreconciled, sourceLabel: '2019 published LGA table', sourceNote: 'Final statewide EC8E totals remain authoritative.'),
  LgaHistoricalResult(year: 2019, lga: 'Ogbadibo', apcVotes: 9259, pdpVotes: 8985, quality: LgaHistoricalQuality.publishedUnreconciled, sourceLabel: '2019 published LGA table', sourceNote: 'Final statewide EC8E totals remain authoritative.'),
  LgaHistoricalResult(year: 2019, lga: 'Ohimini', apcVotes: 8675, pdpVotes: 7577, quality: LgaHistoricalQuality.publishedUnreconciled, sourceLabel: '2019 published LGA table', sourceNote: 'Final statewide EC8E totals remain authoritative.'),
  LgaHistoricalResult(year: 2019, lga: 'Oju', apcVotes: 19134, pdpVotes: 13330, quality: LgaHistoricalQuality.publishedUnreconciled, sourceLabel: '2019 published LGA table', sourceNote: 'Final statewide EC8E totals remain authoritative.'),
  LgaHistoricalResult(year: 2019, lga: 'Okpokwu', apcVotes: 9641, pdpVotes: 11957, quality: LgaHistoricalQuality.publishedUnreconciled, sourceLabel: '2019 published LGA table', sourceNote: 'Final statewide EC8E totals remain authoritative.'),
  LgaHistoricalResult(year: 2019, lga: 'Otukpo', apcVotes: 21785, pdpVotes: 13153, quality: LgaHistoricalQuality.publishedUnreconciled, sourceLabel: '2019 published LGA table', sourceNote: 'Final statewide EC8E totals remain authoritative.'),
  LgaHistoricalResult(year: 2019, lga: 'Tarka', apcVotes: 16600, pdpVotes: 3177, quality: LgaHistoricalQuality.publishedUnreconciled, sourceLabel: '2019 published LGA table', sourceNote: 'Final statewide EC8E totals remain authoritative.'),
  LgaHistoricalResult(year: 2019, lga: 'Ukum', apcVotes: 11790, pdpVotes: 23156, quality: LgaHistoricalQuality.publishedUnreconciled, sourceLabel: '2019 published LGA table', sourceNote: 'Final statewide EC8E totals remain authoritative.'),
  LgaHistoricalResult(year: 2019, lga: 'Ushongo', apcVotes: 14683, pdpVotes: 22703, quality: LgaHistoricalQuality.publishedUnreconciled, sourceLabel: '2019 published LGA table', sourceNote: 'Final statewide EC8E totals remain authoritative.'),
  LgaHistoricalResult(year: 2019, lga: 'Vandeikya', apcVotes: 19079, pdpVotes: 27725, quality: LgaHistoricalQuality.publishedUnreconciled, sourceLabel: '2019 published LGA table', sourceNote: 'Final statewide EC8E totals remain authoritative.'),
];

const benueLgaResults2023 = <LgaHistoricalResult>[
  LgaHistoricalResult(year: 2023, lga: 'Ado', apcVotes: 8662, pdpVotes: 4379, lpVotes: 308, otherVotes: 1006, totalValidVotes: 14355, turnoutPercent: 17.79, quality: LgaHistoricalQuality.reconciledMajorParties, sourceLabel: '2023 published Benue LGA result table', sourceNote: 'APC/PDP/LP columns reconcile to statewide declaration totals.'),
  LgaHistoricalResult(year: 2023, lga: 'Agatu', apcVotes: 7482, pdpVotes: 9934, lpVotes: 216, otherVotes: 311, totalValidVotes: 17943, turnoutPercent: 28.62, quality: LgaHistoricalQuality.reconciledMajorParties, sourceLabel: '2023 published Benue LGA result table', sourceNote: 'APC/PDP/LP columns reconcile to statewide declaration totals.'),
  LgaHistoricalResult(year: 2023, lga: 'Apa', apcVotes: 7925, pdpVotes: 7806, lpVotes: 465, otherVotes: 324, totalValidVotes: 16520, turnoutPercent: 25.49, quality: LgaHistoricalQuality.reconciledMajorParties, sourceLabel: '2023 published Benue LGA result table', sourceNote: 'APC/PDP/LP columns reconcile to statewide declaration totals.'),
  LgaHistoricalResult(year: 2023, lga: 'Buruku', apcVotes: 34713, pdpVotes: 9513, lpVotes: 1155, otherVotes: 556, totalValidVotes: 45937, turnoutPercent: 35.78, quality: LgaHistoricalQuality.reconciledMajorParties, sourceLabel: '2023 published Benue LGA result table', sourceNote: 'APC/PDP/LP columns reconcile to statewide declaration totals.'),
  LgaHistoricalResult(year: 2023, lga: 'Gboko', apcVotes: 53985, pdpVotes: 18773, lpVotes: 1493, otherVotes: 1065, totalValidVotes: 75316, turnoutPercent: 30.68, quality: LgaHistoricalQuality.reconciledMajorParties, sourceLabel: '2023 published Benue LGA result table', sourceNote: 'APC/PDP/LP columns reconcile to statewide declaration totals.'),
  LgaHistoricalResult(year: 2023, lga: 'Guma', apcVotes: 15371, pdpVotes: 22083, lpVotes: 535, otherVotes: 250, totalValidVotes: 38239, turnoutPercent: 33.97, quality: LgaHistoricalQuality.reconciledMajorParties, sourceLabel: '2023 published Benue LGA result table', sourceNote: 'APC/PDP/LP columns reconcile to statewide declaration totals.'),
  LgaHistoricalResult(year: 2023, lga: 'Gwer East', apcVotes: 20083, pdpVotes: 12085, lpVotes: 1272, otherVotes: 161, totalValidVotes: 33601, turnoutPercent: 33.97, quality: LgaHistoricalQuality.reconciledMajorParties, sourceLabel: '2023 published Benue LGA result table', sourceNote: 'APC/PDP/LP columns reconcile to statewide declaration totals.'),
  LgaHistoricalResult(year: 2023, lga: 'Gwer West', apcVotes: 10947, pdpVotes: 13609, lpVotes: 1509, otherVotes: 90, totalValidVotes: 26155, turnoutPercent: 35.31, quality: LgaHistoricalQuality.reconciledMajorParties, sourceLabel: '2023 published Benue LGA result table', sourceNote: 'APC/PDP/LP columns reconcile to statewide declaration totals.'),
  LgaHistoricalResult(year: 2023, lga: 'Katsina-Ala', apcVotes: 34347, pdpVotes: 6716, lpVotes: 178, otherVotes: 428, totalValidVotes: 41669, turnoutPercent: 25.07, quality: LgaHistoricalQuality.reconciledMajorParties, sourceLabel: '2023 published Benue LGA result table', sourceNote: 'APC/PDP/LP columns reconcile to statewide declaration totals.'),
  LgaHistoricalResult(year: 2023, lga: 'Konshisha', apcVotes: 13997, pdpVotes: 5905, lpVotes: 21606, otherVotes: 1598, totalValidVotes: 43106, turnoutPercent: 33.30, quality: LgaHistoricalQuality.reconciledMajorParties, sourceLabel: '2023 published Benue LGA result table', sourceNote: 'LP led this LGA; APC/PDP/LP columns reconcile to statewide declaration totals.'),
  LgaHistoricalResult(year: 2023, lga: 'Kwande', apcVotes: 0, pdpVotes: 0, quality: LgaHistoricalQuality.noElection, sourceLabel: '2023 Benue collation record', sourceNote: 'No governorship election held because of ballot-paper error.'),
  LgaHistoricalResult(year: 2023, lga: 'Logo', apcVotes: 15574, pdpVotes: 16385, lpVotes: 296, otherVotes: 327, totalValidVotes: 32582, turnoutPercent: 29.00, quality: LgaHistoricalQuality.reconciledMajorParties, sourceLabel: '2023 published Benue LGA result table', sourceNote: 'APC/PDP/LP columns reconcile to statewide declaration totals.'),
  LgaHistoricalResult(year: 2023, lga: 'Makurdi', apcVotes: 56432, pdpVotes: 12329, lpVotes: 3792, otherVotes: 2012, totalValidVotes: 74565, turnoutPercent: 24.84, quality: LgaHistoricalQuality.reconciledMajorParties, sourceLabel: '2023 published Benue LGA result table', sourceNote: 'APC/PDP/LP columns reconcile to statewide declaration totals.'),
  LgaHistoricalResult(year: 2023, lga: 'Obi', apcVotes: 9897, pdpVotes: 6267, lpVotes: 1185, otherVotes: 170, totalValidVotes: 17519, turnoutPercent: 25.69, quality: LgaHistoricalQuality.reconciledMajorParties, sourceLabel: '2023 published Benue LGA result table', sourceNote: 'APC/PDP/LP columns reconcile to statewide declaration totals.'),
  LgaHistoricalResult(year: 2023, lga: 'Ogbadibo', apcVotes: 7627, pdpVotes: 6032, lpVotes: 405, otherVotes: 1779, totalValidVotes: 15843, turnoutPercent: 22.49, quality: LgaHistoricalQuality.reconciledMajorParties, sourceLabel: '2023 published Benue LGA result table', sourceNote: 'APC/PDP/LP columns reconcile to statewide declaration totals.'),
  LgaHistoricalResult(year: 2023, lga: 'Ohimini', apcVotes: 7233, pdpVotes: 6785, lpVotes: 973, otherVotes: 760, totalValidVotes: 15751, turnoutPercent: 34.05, quality: LgaHistoricalQuality.reconciledMajorParties, sourceLabel: '2023 published Benue LGA result table', sourceNote: 'APC/PDP/LP columns reconcile to statewide declaration totals.'),
  LgaHistoricalResult(year: 2023, lga: 'Oju', apcVotes: 17245, pdpVotes: 8811, lpVotes: 1611, otherVotes: 475, totalValidVotes: 28142, turnoutPercent: 25.94, quality: LgaHistoricalQuality.reconciledMajorParties, sourceLabel: '2023 published Benue LGA result table', sourceNote: 'APC/PDP/LP columns reconcile to statewide declaration totals.'),
  LgaHistoricalResult(year: 2023, lga: 'Okpokwu', apcVotes: 9326, pdpVotes: 8634, lpVotes: 1039, otherVotes: 304, totalValidVotes: 19303, turnoutPercent: 25.57, quality: LgaHistoricalQuality.reconciledMajorParties, sourceLabel: '2023 published Benue LGA result table', sourceNote: 'APC/PDP/LP columns reconcile to statewide declaration totals.'),
  LgaHistoricalResult(year: 2023, lga: 'Otukpo', apcVotes: 19430, pdpVotes: 12834, lpVotes: 2187, otherVotes: 2447, totalValidVotes: 36898, turnoutPercent: 25.04, quality: LgaHistoricalQuality.reconciledMajorParties, sourceLabel: '2023 published Benue LGA result table', sourceNote: 'APC/PDP/LP columns reconcile to statewide declaration totals.'),
  LgaHistoricalResult(year: 2023, lga: 'Tarka', apcVotes: 16422, pdpVotes: 3748, lpVotes: 175, otherVotes: 287, totalValidVotes: 20632, turnoutPercent: 37.74, quality: LgaHistoricalQuality.reconciledMajorParties, sourceLabel: '2023 published Benue LGA result table', sourceNote: 'APC/PDP/LP columns reconcile to statewide declaration totals.'),
  LgaHistoricalResult(year: 2023, lga: 'Ukum', apcVotes: 28503, pdpVotes: 9418, lpVotes: 439, otherVotes: 280, totalValidVotes: 38640, turnoutPercent: 27.74, quality: LgaHistoricalQuality.reconciledMajorParties, sourceLabel: '2023 published Benue LGA result table', sourceNote: 'APC/PDP/LP columns reconcile to statewide declaration totals.'),
  LgaHistoricalResult(year: 2023, lga: 'Ushongo', apcVotes: 31946, pdpVotes: 8879, lpVotes: 913, otherVotes: 918, totalValidVotes: 42656, turnoutPercent: 36.70, quality: LgaHistoricalQuality.reconciledMajorParties, sourceLabel: '2023 published Benue LGA result table', sourceNote: 'APC/PDP/LP columns reconcile to statewide declaration totals.'),
  LgaHistoricalResult(year: 2023, lga: 'Vandeikya', apcVotes: 46786, pdpVotes: 12988, lpVotes: 129, otherVotes: 1589, totalValidVotes: 61492, turnoutPercent: 37.87, quality: LgaHistoricalQuality.reconciledMajorParties, sourceLabel: '2023 published Benue LGA result table', sourceNote: 'APC/PDP/LP columns reconcile to statewide declaration totals.'),
];

List<LgaHistoricalResult> lgaResultsForYear(int year) => switch (year) {
      2015 => benueLgaResults2015,
      2019 => benueLgaResults2019,
      2023 => benueLgaResults2023,
      _ => const <LgaHistoricalResult>[],
    };

LgaHistoricalResult? lgaResultFor(int year, String lga) {
  for (final result in lgaResultsForYear(year)) {
    if (result.lga.toLowerCase() == lga.toLowerCase()) return result;
  }
  return null;
}

int lgaSumForParty(int year, String party) {
  final rows = lgaResultsForYear(year).where((row) => row.hasElection);
  return rows.fold<int>(0, (sum, row) {
    return sum + switch (party) {
      'APC' => row.apcVotes,
      'PDP' => row.pdpVotes,
      'LP' => row.lpVotes,
      _ => 0,
    };
  });
}
