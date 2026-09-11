class ElectionResult {
  const ElectionResult({
    required this.year,
    required this.apcVotes,
    required this.pdpVotes,
    required this.winner,
    required this.note,
  });

  final int year;
  final int apcVotes;
  final int pdpVotes;
  final String winner;
  final String note;

  int get margin => (apcVotes - pdpVotes).abs();
}

class IntelligenceFactor {
  const IntelligenceFactor({
    required this.title,
    required this.status,
    required this.importance,
    required this.confidence,
    required this.detail,
  });

  final String title;
  final String status;
  final String importance;
  final String confidence;
  final String detail;
}

class CampaignChallenge {
  const CampaignChallenge({
    required this.title,
    required this.severity,
    required this.owner,
    required this.detail,
  });

  final String title;
  final String severity;
  final String owner;
  final String detail;
}

class TrendPoint {
  const TrendPoint(this.label, this.value);
  final String label;
  final double value;
}

const benueLgas = <String>[
  'Ado',
  'Agatu',
  'Apa',
  'Buruku',
  'Gboko',
  'Guma',
  'Gwer East',
  'Gwer West',
  'Katsina-Ala',
  'Konshisha',
  'Kwande',
  'Logo',
  'Makurdi',
  'Obi',
  'Ogbadibo',
  'Ohimini',
  'Oju',
  'Okpokwu',
  'Otukpo',
  'Tarka',
  'Ukum',
  'Ushongo',
  'Vandeikya',
];

const historicalElections = <ElectionResult>[
  ElectionResult(
    year: 2015,
    apcVotes: 422932,
    pdpVotes: 313878,
    winner: 'APC',
    note: 'Samuel Ortom (APC) defeated Terhemen Tarzoor (PDP).',
  ),
  ElectionResult(
    year: 2019,
    apcVotes: 345155,
    pdpVotes: 434473,
    winner: 'PDP',
    note: 'Samuel Ortom (PDP) defeated Emmanuel Jime (APC).',
  ),
  ElectionResult(
    year: 2023,
    apcVotes: 473933,
    pdpVotes: 223913,
    winner: 'APC',
    note: 'Hyacinth Alia (APC) defeated Titus Uba (PDP).',
  ),
];

const currentFactors = <IntelligenceFactor>[
  IntelligenceFactor(
    title: 'Incumbency',
    status: 'APC advantage',
    importance: 'Very high',
    confidence: 'High',
    detail: 'The sitting governor is APC; the model should explicitly account for incumbency rather than assume historical party loyalty is fixed.',
  ),
  IntelligenceFactor(
    title: 'Ruling-party cohesion',
    status: 'Contested',
    importance: 'High',
    confidence: 'Medium',
    detail: 'Public reporting in 2026 describes a significant Alia–Akume political rift. Treat the effect size as uncertain until supported by current field evidence.',
  ),
  IntelligenceFactor(
    title: 'Security environment',
    status: 'Major public issue',
    importance: 'Very high',
    confidence: 'High',
    detail: 'Security and displacement remain material statewide issues and should be tracked as public-interest indicators, not as individual voter profiles.',
  ),
  IntelligenceFactor(
    title: 'Cost of living',
    status: 'High salience',
    importance: 'High',
    confidence: 'High',
    detail: 'National economic pressure and household living costs are important context for the 2027 cycle and should be measured through transparent aggregate sources.',
  ),
  IntelligenceFactor(
    title: 'PDP organization',
    status: 'Campaign data required',
    importance: 'Very high',
    confidence: 'Low',
    detail: 'Ward structure, agent coverage, volunteer activity, events and internal coordination should come from verified campaign operations data.',
  ),
  IntelligenceFactor(
    title: 'Turnout',
    status: 'Uncertain',
    importance: 'Very high',
    confidence: 'Low',
    detail: 'Forecasts should use turnout ranges and scenario simulation instead of one fixed assumption.',
  ),
];

const campaignChallenges = <CampaignChallenge>[
  CampaignChallenge(
    title: 'Recover the 2023 PDP vote decline',
    severity: 'Critical',
    owner: 'Election Intelligence',
    detail: 'PDP raw governorship votes fell from 434,473 in 2019 to 223,913 in 2023. The system should identify where the decline was concentrated once LGA/ward results are loaded.',
  ),
  CampaignChallenge(
    title: 'Statewide field coverage',
    severity: 'High',
    owner: 'Operations',
    detail: 'Every one of the 23 LGAs, 276 wards and 5,102 polling units should have a visible readiness and reporting status.',
  ),
  CampaignChallenge(
    title: 'Evidence quality',
    severity: 'High',
    owner: 'Data & Analytics',
    detail: 'Forecast confidence must fall automatically when polling, field reports or historical granular results are missing or stale.',
  ),
  CampaignChallenge(
    title: 'Rapid incident escalation',
    severity: 'High',
    owner: 'Situation Room',
    detail: 'Critical security, logistics, legal and election-day reports must move through acknowledgement, assignment, escalation and closure with an audit trail.',
  ),
  CampaignChallenge(
    title: 'Narrative verification',
    severity: 'Medium',
    owner: 'Media Intelligence',
    detail: 'Public claims should be separated into verified, false, misleading or insufficient-evidence states before any campaign response is approved.',
  ),
];

const campaignTrend = <TrendPoint>[
  TrendPoint('W1', 42),
  TrendPoint('W2', 46),
  TrendPoint('W3', 44),
  TrendPoint('W4', 49),
  TrendPoint('W5', 53),
  TrendPoint('W6', 55),
  TrendPoint('W7', 58),
  TrendPoint('W8', 61),
];

const dataSources = <String>[
  'INEC historical election results',
  'Campaign field reports',
  'Independent polling with methodology',
  'Public media monitoring',
  'Public social-media trend aggregates',
  'Campaign operations and readiness data',
  'Analyst-reviewed current factors',
];
