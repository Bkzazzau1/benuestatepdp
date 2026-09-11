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
    detail:
        'The sitting governor carries the advantages and pressures of incumbency. Historical party loyalty should not be treated as fixed.',
  ),
  IntelligenceFactor(
    title: 'Ruling-party cohesion',
    status: 'Contested',
    importance: 'High',
    confidence: 'Medium',
    detail:
        'Public reporting in 2026 describes a significant Alia–Akume political rift. Its electoral effect remains uncertain and should be judged against current campaign evidence.',
  ),
  IntelligenceFactor(
    title: 'Security environment',
    status: 'Major public issue',
    importance: 'Very high',
    confidence: 'High',
    detail:
        'Security, displacement and freedom of movement remain major statewide concerns, especially in farming communities.',
  ),
  IntelligenceFactor(
    title: 'Cost of living',
    status: 'High salience',
    importance: 'High',
    confidence: 'High',
    detail:
        'Household living costs, food prices and wider economic pressure are important context for the 2027 campaign.',
  ),
  IntelligenceFactor(
    title: 'PDP organization',
    status: 'Building strength',
    importance: 'Very high',
    confidence: 'Low',
    detail:
        'Ward structure, agent coverage, volunteer activity, events and internal coordination will be central to statewide competitiveness.',
  ),
  IntelligenceFactor(
    title: 'Turnout',
    status: 'Uncertain',
    importance: 'Very high',
    confidence: 'Low',
    detail:
        'Turnout may vary substantially by geography, security conditions, mobilization and public enthusiasm.',
  ),
];

const campaignChallenges = <CampaignChallenge>[
  CampaignChallenge(
    title: 'Recover the 2023 PDP vote decline',
    severity: 'Critical',
    owner: 'Election Intelligence',
    detail:
        'PDP governorship votes fell from 434,473 in 2019 to 223,913 in 2023. Priority attention should go to the LGAs where the decline was deepest and recovery potential is strongest.',
  ),
  CampaignChallenge(
    title: 'Statewide field coverage',
    severity: 'High',
    owner: 'Operations',
    detail:
        'Every one of the 23 LGAs, 276 wards and 5,102 polling units should have clear campaign ownership, readiness and reporting visibility.',
  ),
  CampaignChallenge(
    title: 'Evidence quality',
    severity: 'High',
    owner: 'Data & Analytics',
    detail:
        'Campaign decisions should rely on current polling, field reports, historical results and clearly dated evidence.',
  ),
  CampaignChallenge(
    title: 'Rapid incident escalation',
    severity: 'High',
    owner: 'Situation Room',
    detail:
        'Critical security, logistics, legal and election-day issues should move quickly from reporting to ownership, action and closure.',
  ),
  CampaignChallenge(
    title: 'Narrative verification',
    severity: 'Medium',
    owner: 'Media Intelligence',
    detail:
        'Important public claims should be checked carefully before the campaign responds or amplifies them.',
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
