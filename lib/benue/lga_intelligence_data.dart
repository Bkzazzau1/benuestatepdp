enum LocalIntelConfidence { high, medium, low }

enum LocalIntelClass {
  verifiedResult,
  sourceBackedInterpretation,
  analystHypothesis,
  scenarioOutlook,
  sourceGap,
}

class LgaCycleNarrative {
  const LgaCycleNarrative({
    required this.year,
    required this.dynamic,
    required this.why,
    required this.counterfactual,
    required this.classification,
    required this.confidence,
  });

  final int year;
  final String dynamic;
  final String why;
  final String counterfactual;
  final LocalIntelClass classification;
  final LocalIntelConfidence confidence;
}

class LgaOutlook2027 {
  const LgaOutlook2027({
    required this.status,
    required this.publicIssues,
    required this.structuralFactors,
    required this.evidenceNeeds,
    required this.confidence,
  });

  final String status;
  final List<String> publicIssues;
  final List<String> structuralFactors;
  final List<String> evidenceNeeds;
  final LocalIntelConfidence confidence;
}

class LgaIntelligenceProfile {
  const LgaIntelligenceProfile({
    required this.lga,
    required this.zone,
    required this.cluster,
    required this.cycles,
    required this.outlook2027,
  });

  final String lga;
  final String zone;
  final String cluster;
  final List<LgaCycleNarrative> cycles;
  final LgaOutlook2027 outlook2027;
}

const verified2027CandidateFacts = <String>[
  'Michael Kaase Aondoakaa, SAN is publicly reported as the PDP consensus/affirmed governorship candidate for Benue in 2027.',
  'Governor Hyacinth Alia won the APC Benue governorship primary for the 2027 ticket in May 2026.',
  'Current-cycle LGA outlooks below are scenarios, not vote forecasts or individual-voter profiles.',
];

const current2027SourceRegistry = <String>[
  'TheCable, 4 May 2026 — Benue PDP picks Michael Kaase Aondoakaa as consensus governorship candidate.',
  'Vanguard, 24 May 2026 — Benue PDP affirms Aondoakaa as 2027 governorship candidate.',
  'Punch, 22 May 2026 — Hyacinth Alia wins APC Benue governorship primary with 367,786 votes.',
  'Channels Television, 21 May 2026 — Alia wins APC governorship primary in Benue.',
  'Guardian, 15 July 2026 — reported continuing APC power struggle around Benue candidate lists, relevant only as a party-cohesion risk signal.',
];

const _zoneA = 'Zone A • Benue North-East';
const _zoneB = 'Zone B • Benue North-West';
const _zoneC = 'Zone C • Benue South';

LgaCycleNarrative _c(
  int year,
  String dynamic,
  String why,
  String counterfactual, {
  LocalIntelClass classification = LocalIntelClass.analystHypothesis,
  LocalIntelConfidence confidence = LocalIntelConfidence.medium,
}) =>
    LgaCycleNarrative(
      year: year,
      dynamic: dynamic,
      why: why,
      counterfactual: counterfactual,
      classification: classification,
      confidence: confidence,
    );

LgaOutlook2027 _o(
  String status,
  List<String> issues,
  List<String> factors,
  List<String> needs, {
  LocalIntelConfidence confidence = LocalIntelConfidence.low,
}) =>
    LgaOutlook2027(
      status: status,
      publicIssues: issues,
      structuralFactors: factors,
      evidenceNeeds: needs,
      confidence: confidence,
    );

final lgaIntelligenceProfiles = <LgaIntelligenceProfile>[
  LgaIntelligenceProfile(
    lga: 'Katsina-Ala',
    zone: _zoneA,
    cluster: 'Sankera belt',
    cycles: [
      _c(2015, 'PDP retained a locally resilient base despite the statewide APC swing.', 'The historical hypothesis is that Sankera political networks and proximity to the outgoing Suswam political structure softened the anti-incumbency wave.', 'A stronger opposition case around local security, agriculture and state-service performance might have narrowed the PDP advantage.'),
      _c(2019, 'The published LGA table shows APC ahead in a reversal from 2015.', 'Local insecurity and desire for stronger federal alignment may have offset the statewide pro-Ortom security narrative here.', 'PDP would have needed a more locally credible security and rural-recovery proposition.'),
      _c(2023, 'APC recorded a large advantage in the loaded LGA result.', 'The working interpretation combines anti-incumbency, persistent insecurity and the statewide Alia wave.', 'Earlier measurable security and rural economic recovery by the incumbent party might have reduced the scale of the swing.'),
    ],
    outlook2027: _o('HIGHLY COMPETITIVE / SECURITY-SENSITIVE', ['Rural security', 'Agricultural recovery', 'Road access', 'Displacement'], ['Incumbency resources', 'Opposition consolidation', 'Sankera security experience'], ['Fresh ward-level incident trends', 'Farmer-access indicators', 'Methodological polling', 'Verified organization readiness']),
  ),
  LgaIntelligenceProfile(
    lga: 'Logo', zone: _zoneA, cluster: 'Sankera belt',
    cycles: [
      _c(2015, 'PDP posted one of its strongest loaded 2015 LGA performances.', 'Suswam-era home-zone political machinery and local solidarity are the main historical interpretation.', 'Opposition gains would have required earlier penetration beyond central party structures and stronger issue-based rural outreach.'),
      _c(2019, 'PDP dominated the published LGA table.', 'Logo had experienced severe rural violence; Ortom’s anti-open-grazing and land-protection positioning had unusually strong local resonance.', 'APC needed an independently credible local security position distinct from unpopular federal-security perceptions.'),
      _c(2023, 'PDP remained competitive and narrowly led in the loaded major-party table.', 'Residual local networks and historical alignment appear to have survived the statewide APC landslide better here than in many Tiv LGAs.', 'APC could have improved through stronger local trust and evidence of rural-security delivery.'),
    ],
    outlook2027: _o('BATTLEGROUND', ['Security', 'Farm access', 'Displacement', 'Rural livelihoods'], ['Historic PDP resilience', 'Incumbency', 'Sankera volatility'], ['Ward-level security evidence', 'Return-to-farm data', 'Current party organization', 'Turnout-risk analysis']),
  ),
  LgaIntelligenceProfile(
    lga: 'Ukum', zone: _zoneA, cluster: 'Sankera belt',
    cycles: [
      _c(2015, 'Analyst narrative places Ukum inside the PDP-leaning Sankera defensive bloc; the current project does not yet hold a verified 2015 LGA row.', 'Political and economic links to Katsina-Ala and Logo are the main hypothesis.', 'Any retrospective conclusion should remain provisional until a source-quality 2015 LGA result is imported.', classification: LocalIntelClass.sourceGap, confidence: LocalIntelConfidence.low),
      _c(2019, 'Published LGA data shows a clear PDP lead.', 'Security identity, local organization and Sankera solidarity are the leading interpretations.', 'APC needed locally trusted security and agricultural-economic credibility.'),
      _c(2023, 'The loaded result shows APC ahead.', 'The statewide anti-incumbency/Alia wave appears to have broken the 2019 PDP hold.', 'PDP required stronger evidence of security, rural governance and organizational renewal.'),
    ],
    outlook2027: _o('HIGHLY COMPETITIVE', ['Banditry/security', 'Agriculture', 'Market access'], ['Incumbency', 'Opposition rebuilding', 'Local security performance'], ['Current ward security map', 'Agricultural production data', 'Organization coverage', 'Independent polling']),
  ),
  LgaIntelligenceProfile(
    lga: 'Konshisha', zone: _zoneA, cluster: 'Jechira / Vandeikya axis',
    cycles: [
      _c(2015, 'The user-supplied narrative describes an APC-leaning change election; no verified 2015 LGA row is loaded in the current source layer.', 'Anti-incumbency and infrastructure dissatisfaction are the working hypotheses.', 'A source-quality 2015 result is required before the system labels the LGA winner as verified.', classification: LocalIntelClass.sourceGap, confidence: LocalIntelConfidence.low),
      _c(2019, 'Published table shows PDP ahead.', 'State-level incumbent structure and security-era coalition recovery likely mattered.', 'APC needed stronger local coalition and visible high-trust messengers.'),
      _c(2023, 'The loaded data shows the Labour Party as the strongest local force among the major parties captured.', 'Herman Hembe’s local political identity appears to have created a powerful hometown effect that split the anti-PDP vote.', 'Major parties needed stronger local candidate integration rather than relying on statewide waves alone.', classification: LocalIntelClass.sourceBackedInterpretation),
    ],
    outlook2027: _o('MULTI-BLOC BATTLEGROUND', ['Local representation', 'Roads', 'Agriculture', 'Security'], ['Strong local-personality effects', 'APC incumbency', 'PDP consolidation'], ['Current local-elite alignment', 'Ward-level organization', 'Issue polling', 'Candidate favorability at aggregate level']),
  ),
  LgaIntelligenceProfile(
    lga: 'Kwande', zone: _zoneA, cluster: 'Kwande / Ushongo axis',
    cycles: [
      _c(2015, 'The historical narrative describes an APC win and a strong rejection of the PDP continuity frame; the current project still lacks a verified 2015 LGA row.', 'Independent local political behavior and resistance to perceived imposition are the main hypotheses.', 'PDP would have needed deeper local leadership ownership of the campaign.', classification: LocalIntelClass.sourceGap, confidence: LocalIntelConfidence.low),
      _c(2019, 'Published table shows PDP ahead.', 'Traditional/local leadership alignment and Ortom-era coalition rebuilding are plausible explanations.', 'APC needed a more unified local structure.'),
      _c(2023, 'APC led strongly in the loaded table.', 'The Alia wave and rejection of the outgoing administration appear to have dominated.', 'PDP required stronger local autonomy and a clearer break from unpopular statewide baggage.'),
    ],
    outlook2027: _o('COMPETITIVE / HOME-REGION RELEVANCE', ['Agriculture', 'Rural roads', 'Security', 'Public-service delivery'], ['Local-son dynamics', 'Incumbency', 'Sub-bloc leadership'], ['Verified candidate-home links', 'LGA project ledger', 'Ward organization', 'Polling']),
  ),
  LgaIntelligenceProfile(
    lga: 'Ushongo', zone: _zoneA, cluster: 'Kwande / Ushongo axis',
    cycles: [
      _c(2015, 'PDP held a strong position in the user narrative; the current 2015 source layer has no Ushongo row.', 'Local chieftains and rural mobilization are the principal hypotheses.', 'Opposition penetration would have required sustained agrarian and service-delivery engagement.', classification: LocalIntelClass.sourceGap, confidence: LocalIntelConfidence.low),
      _c(2019, 'Published table shows PDP ahead.', 'Ward-level organization and the broader 2019 Ortom coalition likely mattered.', 'APC needed a clearer rural economic proposition.'),
      _c(2023, 'APC posted a large lead in the loaded table.', 'The result is consistent with broad anti-incumbency and candidate-popularity effects.', 'PDP needed visible organizational renewal and locally credible governance differentiation.'),
    ],
    outlook2027: _o('COMPETITIVE', ['Agriculture', 'Rural infrastructure', 'Security', 'Jobs'], ['Incumbency', 'Aondoakaa regional relevance', 'Local leadership networks'], ['Project evidence', 'Ward coverage', 'Agrarian indicators', 'Aggregate polling']),
  ),
  LgaIntelligenceProfile(
    lga: 'Vandeikya', zone: _zoneA, cluster: 'Jechira / Vandeikya axis',
    cycles: [
      _c(2015, 'Loaded 2015 result shows a very large APC advantage.', 'Anti-incumbency, public-service grievances and the change narrative are the strongest working explanations.', 'PDP needed a credible separation from the outgoing fiscal record and much earlier local repair.'),
      _c(2019, 'Published table shows a PDP reversal.', 'Security politics and Ortom’s return to PDP appear to have reorganized local loyalties.', 'APC needed to replace the 2015 anti-incumbency message with a locally persuasive security/governance case.'),
      _c(2023, 'APC again recorded a very large advantage.', 'Alia’s local/religious-populist appeal and dissatisfaction with the outgoing administration are the central interpretations.', 'PDP needed a substantially more independent candidate identity and governance reset.'),
    ],
    outlook2027: _o('HIGH-VALUE COMPETITIVE LGA', ['Public service', 'Agriculture', 'Roads', 'Security'], ['Strong 2023 APC baseline', 'Regional candidate connections', 'Incumbency record'], ['Current aggregate favorability', 'Project delivery ledger', 'Ward readiness', 'Turnout modeling']),
  ),
  LgaIntelligenceProfile(
    lga: 'Buruku', zone: _zoneB, cluster: 'Jemgbagh / central agrarian belt',
    cycles: [
      _c(2015, 'The user narrative describes an APC win; the current source layer lacks a verified 2015 Buruku row.', 'Agrarian hardship and statewide anti-incumbency are the main hypotheses.', 'PDP needed locally specific rural-economic credibility.', classification: LocalIntelClass.sourceGap, confidence: LocalIntelConfidence.low),
      _c(2019, 'Published data shows a strong PDP lead.', 'Security-protection messaging and incumbent grassroots structures are the leading explanations.', 'APC needed stronger interior ward organization and a locally credible security position.'),
      _c(2023, 'APC led by a wide margin in the loaded table.', 'Administrative-change sentiment and the statewide Alia wave appear dominant.', 'PDP needed visible rural-development differentiation and stronger local network renewal.'),
    ],
    outlook2027: _o('LEAN INCUMBENT / TESTABLE', ['Agriculture', 'Roads', 'Security', 'Jobs'], ['2023 APC baseline', 'Current project delivery', 'Opposition coalition'], ['Rural project verification', 'Ward organization', 'Agricultural price/access data', 'Polling']),
  ),
  LgaIntelligenceProfile(
    lga: 'Gboko', zone: _zoneB, cluster: 'Jemgbagh heartland',
    cycles: [
      _c(2015, 'Loaded result shows a very large APC advantage.', 'The historic interpretation combines anti-incumbency, Jemgbagh alignment and dissatisfaction with PDP succession politics.', 'PDP would have needed major internal reconciliation and a less centralized succession process.'),
      _c(2019, 'Published table shows Gboko flipping to PDP.', 'Ortom’s security/identity positioning and party switch appear to have overridden the 2015 party pattern.', 'APC needed a stronger local identity bridge and a security narrative independent of federal perceptions.'),
      _c(2023, 'APC returned to a dominant position in the loaded table.', 'The Alia wave and rejection of the outgoing PDP administration appear to have reset the LGA again.', 'PDP needed a credible governance break and refreshed local coalition.'),
    ],
    outlook2027: _o('MAJOR BATTLEGROUND / HIGH VOTE VALUE', ['Urban-rural infrastructure', 'Jobs', 'Agriculture', 'Party cohesion'], ['Strong APC baseline', 'Jemgbagh power networks', 'Opposition consolidation'], ['Current ward structure', 'Project evidence', 'Aggregate voter-intent polling', 'Turnout history']),
  ),
  LgaIntelligenceProfile(
    lga: 'Guma', zone: _zoneB, cluster: 'Makurdi / Guma security belt',
    cycles: [
      _c(2015, 'No verified 2015 Guma row is currently loaded.', 'Any claim about the local winner or margin should remain unverified until sourced.', 'Import official or high-quality contemporaneous LGA collation before retrospective causal ranking.', classification: LocalIntelClass.sourceGap, confidence: LocalIntelConfidence.low),
      _c(2019, 'Published table shows a large PDP advantage.', 'Guma’s exposure to farmer-herder violence and Ortom’s anti-open-grazing stance make security identity a strong source-backed interpretation.', 'APC needed a locally credible land/security proposition distinct from federal-security criticism.'),
      _c(2023, 'Loaded data shows APC ahead.', 'The result suggests the statewide change wave overcame the 2019 security-driven PDP advantage.', 'PDP needed stronger evidence of delivery, security improvement and economic recovery.'),
    ],
    outlook2027: _o('SECURITY-DRIVEN BATTLEGROUND', ['Security', 'Displacement', 'Farm access', 'Rural roads'], ['Incumbency security record', 'Historic PDP security identity', 'Opposition coalition'], ['Current incident map', 'IDP/return data', 'Farm-access indicators', 'Polling']),
  ),
  LgaIntelligenceProfile(
    lga: 'Gwer East', zone: _zoneB, cluster: 'Gwer axis',
    cycles: [
      _c(2015, 'Loaded result shows a strong APC lead.', 'Civil-service, education-sector and anti-incumbency pressures are plausible contributors.', 'PDP needed a sharper break from the outgoing fiscal/governance record.'),
      _c(2019, 'Published data shows PDP ahead.', 'The security-era coalition and incumbent state structure appear to have reversed 2015.', 'APC needed stronger local policy differentiation.'),
      _c(2023, 'Loaded result shows APC ahead.', 'Anti-incumbency and statewide candidate effects appear to have reasserted themselves.', 'PDP needed stronger local candidate credibility and service-delivery evidence.'),
    ],
    outlook2027: _o('COMPETITIVE', ['Roads', 'Agriculture', 'Education', 'Security'], ['Mixed historical swings', 'Incumbency', 'Local institutional networks'], ['Project audit', 'Ward organization', 'Issue polling', 'Turnout model']),
  ),
  LgaIntelligenceProfile(
    lga: 'Gwer West', zone: _zoneB, cluster: 'Gwer axis',
    cycles: [
      _c(2015, 'Loaded result shows a narrow PDP lead.', 'Local leadership appears to have preserved enough PDP support to resist the statewide APC wave.', 'A relatively small opposition gain could have flipped the result.'),
      _c(2019, 'Published data shows a clearer PDP lead.', 'Security exposure and the anti-open-grazing stance are likely important local drivers.', 'APC needed a stronger locally trusted security response.'),
      _c(2023, 'Loaded result again shows PDP ahead.', 'Localized networks and security-related political identity appear more resilient here than in most Zone B LGAs.', 'APC needed better interior penetration and evidence of local security delivery.'),
    ],
    outlook2027: _o('PERSISTENT BATTLEGROUND', ['Security', 'Rural roads', 'Agriculture'], ['PDP historical resilience', 'APC incumbency', 'Local leadership'], ['Ward-level result history', 'Security trends', 'Organization readiness', 'Polling']),
  ),
  LgaIntelligenceProfile(
    lga: 'Makurdi', zone: _zoneB, cluster: 'State-capital urban hub',
    cycles: [
      _c(2015, 'Loaded result shows APC ahead in the state capital.', 'Civil servants, teachers, pensioners and urban households were directly exposed to salary/pension arrears and anti-incumbency sentiment.', 'A credible and visible fiscal repair before the election might have narrowed the opposition advantage.', classification: LocalIntelClass.sourceBackedInterpretation, confidence: LocalIntelConfidence.high),
      _c(2019, 'Published table still shows APC ahead despite the statewide PDP win.', 'Urban dissatisfaction and Jime’s technocratic/federal-alignment appeal are plausible explanations; the 2019 LGA table remains unreconciled to final EC8E totals.', 'PDP needed stronger urban-service and worker-facing credibility.'),
      _c(2023, 'Loaded result shows a very large APC advantage.', 'Anti-incumbency, public-service grievances and Alia’s statewide popularity were especially consequential in the capital.', 'PDP needed a clear administrative break from the outgoing government plus credible urban economic and service delivery evidence.'),
    ],
    outlook2027: _o('TOP-TIER BATTLEGROUND', ['Jobs', 'Cost of living', 'Urban roads', 'Public service', 'Markets'], ['Incumbency performance visibility', 'Opposition competence narrative', 'Civil-service sentiment'], ['Independent urban polling', 'Project completion audit', 'Public-service indicators', 'Ward organization']),
  ),
  LgaIntelligenceProfile(
    lga: 'Tarka', zone: _zoneB, cluster: 'Jemgbagh heartland',
    cycles: [
      _c(2015, 'Loaded result shows one of the strongest APC margins.', 'Tarka’s association with George Akume’s political structure made it a durable APC fortress.', 'PDP had limited structural room without a major local realignment.', classification: LocalIntelClass.sourceBackedInterpretation),
      _c(2019, 'Published table again shows a dominant APC lead.', 'Legacy APC machinery remained unusually resilient to Ortom’s statewide PDP coalition.', 'PDP needed a major local elite/grassroots realignment rather than ordinary campaign activity.'),
      _c(2023, 'Loaded result remains strongly APC.', 'Legacy party organization combined with the Alia wave reinforced the baseline.', 'PDP required structural rather than message-only change.'),
    ],
    outlook2027: _o('LEAN APC / STRUCTURAL', ['Agriculture', 'Roads', 'Local representation'], ['Long-run APC organization', 'Incumbency', 'Local elite alignment'], ['Current party cohesion', 'Turnout risk', 'Ward organization', 'Project data']),
  ),
  LgaIntelligenceProfile(
    lga: 'Ado', zone: _zoneC, cluster: 'Idoma border belt',
    cycles: [
      _c(2015, 'The user narrative describes a very close PDP win, but the current project does not have a verified 2015 Ado row and the supplied figures conflict with other loaded records.', 'A tightly divided local leadership structure is the useful hypothesis; the result itself must remain source-gap.', 'Do not use duplicated/uncertain 2015 figures in production intelligence.', classification: LocalIntelClass.sourceGap, confidence: LocalIntelConfidence.low),
      _c(2019, 'Published table shows PDP narrowly ahead.', 'The LGA remained highly competitive with neither party establishing a durable block advantage.', 'Small changes in mobilization and turnout could have altered the result.'),
      _c(2023, 'Loaded table shows APC clearly ahead.', 'The statewide APC swing broke the earlier near-parity pattern.', 'PDP needed stronger organizational recovery and locally visible governance differentiation.'),
    ],
    outlook2027: _o('SWING LGA', ['Roads', 'Jobs', 'Agriculture', 'Border commerce'], ['Historically close contests', 'Incumbency', 'Opposition rebuilding'], ['Reliable ward history', 'Turnout analysis', 'Organization coverage', 'Issue polling']),
  ),
  LgaIntelligenceProfile(
    lga: 'Agatu', zone: _zoneC, cluster: 'Riverine / security belt',
    cycles: [
      _c(2015, 'Loaded result shows a large PDP advantage.', 'Local political networks and community alignment appear to have resisted the statewide APC wave.', 'APC needed deeper ward penetration and stronger riverine/security credibility.'),
      _c(2019, 'Published data again shows PDP ahead.', 'Security history and Ortom’s public advocacy likely reinforced the PDP hold.', 'APC needed substantially more local trust on security and riverine development.'),
      _c(2023, 'Loaded data still shows PDP ahead.', 'Agatu remained one of the clearest examples of persistent local PDP resilience.', 'APC needed longer-term local roots and stronger evidence of security/development delivery.'),
    ],
    outlook2027: _o('PDP-RESILIENT BATTLEGROUND', ['Security', 'Flooding', 'Agriculture', 'Riverine infrastructure'], ['Historic PDP resilience', 'Incumbency', 'Community leadership'], ['Flood/security data', 'Project evidence', 'Ward organization', 'Polling']),
  ),
  LgaIntelligenceProfile(
    lga: 'Apa', zone: _zoneC, cluster: 'Idoma central / riverine edge',
    cycles: [
      _c(2015, 'The loaded 2015 row actually shows APC narrowly ahead, conflicting with the supplied narrative that labelled Apa a PDP win.', 'This conflict is exactly why the result layer remains authoritative and narrative interpretation is separated.', 'Historical analysis should be recalibrated around the sourced result before causal claims are upgraded.', classification: LocalIntelClass.verifiedResult, confidence: LocalIntelConfidence.high),
      _c(2019, 'Published table shows a razor-thin PDP lead.', 'Community leadership and local party organization likely decided a very close contest.', 'Minor turnout or organization changes could have reversed the result.'),
      _c(2023, 'Loaded result remains competitive with PDP resilience relative to the statewide pattern.', 'Localized networks appear to have limited the APC wave.', 'Both sides needed stronger evidence on rural development and security delivery.'),
    ],
    outlook2027: _o('SWING / RIVERINE BATTLEGROUND', ['Security', 'Agriculture', 'Flooding', 'Road access'], ['Close historical margins', 'Incumbency', 'Community networks'], ['Ward turnout', 'Flood/security indicators', 'Organization readiness', 'Polling']),
  ),
  LgaIntelligenceProfile(
    lga: 'Obi', zone: _zoneC, cluster: 'Igede axis',
    cycles: [
      _c(2015, 'Loaded result shows PDP narrowly ahead.', 'Localized ward and community loyalties appear to have limited the statewide APC swing.', 'APC needed stronger local coalition-building.'),
      _c(2019, 'Published table shows APC narrowly ahead.', 'The Igede axis showed greater anti-establishment behavior and local competition than PDP’s stronger Tiv-area coalition.', 'PDP needed better local conflict resolution and representation credibility.'),
      _c(2023, 'Loaded result shows APC ahead again.', 'The broader Alia wave reinforced the 2019 direction.', 'PDP needed clearer local development and representation evidence.'),
    ],
    outlook2027: _o('COMPETITIVE / IGEDE AXIS', ['Roads', 'Representation', 'Agriculture', 'Jobs'], ['APC two-cycle edge', 'Incumbency', 'Local identity politics'], ['Issue polling', 'Project data', 'Ward organization', 'Turnout history']),
  ),
  LgaIntelligenceProfile(
    lga: 'Ogbadibo', zone: _zoneC, cluster: 'Idoma border belt',
    cycles: [
      _c(2015, 'Loaded result shows APC narrowly ahead.', 'The historical interpretation is opposition breakthrough against long PDP dominance.', 'PDP needed stronger district-level containment of the opposition surge.'),
      _c(2019, 'Published table again shows a very narrow APC lead.', 'The LGA remained a classic swing council with tiny major-party separation.', 'A few hundred votes of additional organization could have reversed the outcome.'),
      _c(2023, 'Loaded data shows APC ahead.', 'The statewide swing strengthened an already competitive APC position.', 'PDP needed stronger base reactivation and visible local development credibility.'),
    ],
    outlook2027: _o('SWING LGA', ['Border commerce', 'Roads', 'Jobs', 'Agriculture'], ['Repeated narrow contests', 'Incumbency', 'Opposition organization'], ['Ward history', 'Turnout', 'Project evidence', 'Polling']),
  ),
  LgaIntelligenceProfile(
    lga: 'Ohimini', zone: _zoneC, cluster: 'Otukpo / Ohimini axis',
    cycles: [
      _c(2015, 'No verified 2015 Ohimini row is currently loaded.', 'No causal or winner claim should be promoted without a source-quality result.', 'Import the official/contemporaneous 2015 LGA collation before retrospective ranking.', classification: LocalIntelClass.sourceGap, confidence: LocalIntelConfidence.low),
      _c(2019, 'Published table shows APC narrowly ahead.', 'The LGA behaved as part of a competitive Zone C rather than a fixed party block.', 'Small organization and turnout changes could have reversed the result.'),
      _c(2023, 'Loaded result shows APC ahead.', 'The statewide APC swing appears to have reinforced the 2019 direction.', 'PDP needed stronger local organizational and development credibility.'),
    ],
    outlook2027: _o('COMPETITIVE', ['Roads', 'Jobs', 'Agriculture', 'Representation'], ['Zone C competition', 'Incumbency', 'Local networks'], ['Ward results', 'Issue polling', 'Organization coverage', 'Project audit']),
  ),
  LgaIntelligenceProfile(
    lga: 'Oju', zone: _zoneC, cluster: 'Igede axis',
    cycles: [
      _c(2015, 'Loaded result shows APC ahead.', 'Perceived marginalization and the statewide change mood are the strongest historical hypotheses.', 'PDP needed stronger representation and development credibility.'),
      _c(2019, 'Published data again shows APC ahead.', 'Anti-establishment and local-development concerns remained important despite PDP’s statewide win.', 'PDP needed a clearer Igede-focused development record.'),
      _c(2023, 'Loaded result shows APC ahead by a strong margin.', 'The Alia wave strengthened an already APC-leaning recent pattern.', 'PDP needed a stronger local reset and measurable infrastructure commitments.'),
    ],
    outlook2027: _o('LEAN APC / COMPETITIVE', ['Representation', 'Roads', 'Jobs', 'Agriculture'], ['Three-cycle APC tendency in loaded data', 'Incumbency', 'Local development perceptions'], ['Project evidence', 'Aggregate polling', 'Ward organization', 'Turnout']),
  ),
  LgaIntelligenceProfile(
    lga: 'Okpokwu', zone: _zoneC, cluster: 'Idoma south-west belt',
    cycles: [
      _c(2015, 'Loaded result shows PDP ahead.', 'Traditional party networks appear to have held despite the statewide APC win.', 'APC needed stronger peripheral market and rural development penetration.'),
      _c(2019, 'Published table again shows PDP ahead.', 'Local party organization and historical loyalty remained resilient.', 'APC needed deeper non-urban organization.'),
      _c(2023, 'Loaded result shows APC narrowly ahead.', 'The statewide change wave finally overcame the historical PDP edge, but only narrowly.', 'PDP was within reach and needed stronger local mobilization plus clearer economic differentiation.'),
    ],
    outlook2027: _o('CLASSIC SWING LGA', ['Markets', 'Roads', 'Agriculture', 'Jobs'], ['Historic PDP base', '2023 APC flip', 'Incumbency'], ['Ward swing map', 'Turnout', 'Organization readiness', 'Issue polling']),
  ),
  LgaIntelligenceProfile(
    lga: 'Otukpo', zone: _zoneC, cluster: 'Zone C political/urban hub',
    cycles: [
      _c(2015, 'Loaded result shows APC narrowly ahead, a major symbolic break in a historically PDP-dominant political hub.', 'State-level anti-incumbency and protest voting are plausible explanations.', 'PDP needed to avoid treating the urban stronghold as structurally safe.'),
      _c(2019, 'Published table shows APC clearly ahead.', 'The Jime/Ode ticket and urban/federal-alignment appeal likely strengthened APC here.', 'PDP needed much stronger urban coordination and local-ticket resonance.'),
      _c(2023, 'Loaded result again shows APC ahead.', 'The deputy-governorship factor and statewide APC wave likely reinforced the recent pattern.', 'PDP needed a more compelling Zone C development and representation record.'),
    ],
    outlook2027: _o('TOP ZONE C BATTLEGROUND', ['Jobs', 'Urban infrastructure', 'Representation', 'Business climate'], ['APC recent-cycle strength', 'PDP challenger coalition', 'Zone C ticket dynamics'], ['Urban polling', 'Project audit', 'Stakeholder map at aggregate level', 'Turnout history']),
  ),
];

LgaIntelligenceProfile intelligenceProfileFor(String lga) =>
    lgaIntelligenceProfiles.firstWhere((profile) => profile.lga == lga);

LgaCycleNarrative? cycleNarrativeFor(String lga, int year) {
  final profile = intelligenceProfileFor(lga);
  for (final cycle in profile.cycles) {
    if (cycle.year == year) return cycle;
  }
  return null;
}
