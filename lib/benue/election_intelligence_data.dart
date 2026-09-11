enum IntelConfidence { high, medium, low }

enum IntelligenceEvidenceType {
  verifiedFact,
  sourceBackedInterpretation,
  campaignLesson,
}

class IntelligenceSourceRef {
  const IntelligenceSourceRef({
    required this.id,
    required this.publisher,
    required this.title,
    required this.reference,
    required this.quality,
  });

  final String id;
  final String publisher;
  final String title;
  final String reference;
  final String quality;
}

class ElectionDriver {
  const ElectionDriver({
    required this.title,
    required this.category,
    required this.effect,
    required this.detail,
    required this.impact,
    required this.confidence,
    required this.evidenceType,
    required this.sourceIds,
  });

  final String title;
  final String category;
  final String effect;
  final String detail;
  final int impact;
  final IntelConfidence confidence;
  final IntelligenceEvidenceType evidenceType;
  final List<String> sourceIds;
}

class RegionalDynamic {
  const RegionalDynamic({
    required this.title,
    required this.geography,
    required this.result,
    required this.interpretation,
    required this.confidence,
    required this.sourceIds,
  });

  final String title;
  final String geography;
  final String result;
  final String interpretation;
  final IntelConfidence confidence;
  final List<String> sourceIds;
}

class StrategicLesson {
  const StrategicLesson({
    required this.title,
    required this.detail,
    required this.forWinner,
  });

  final String title;
  final String detail;
  final bool forWinner;
}

class LegalMilestone {
  const LegalMilestone({
    required this.stage,
    required this.outcome,
    required this.detail,
    required this.sourceIds,
  });

  final String stage;
  final String outcome;
  final String detail;
  final List<String> sourceIds;
}

class ElectionCycleIntelligence {
  const ElectionCycleIntelligence({
    required this.year,
    required this.winnerName,
    required this.winnerParty,
    required this.winnerVotes,
    required this.runnerUpName,
    required this.runnerUpParty,
    required this.runnerUpVotes,
    required this.verdict,
    required this.drivers,
    required this.regionalDynamics,
    required this.winningNarrative,
    required this.losingNarrative,
    required this.lessons,
    required this.legalAftermath,
    required this.sources,
  });

  final int year;
  final String winnerName;
  final String winnerParty;
  final int winnerVotes;
  final String runnerUpName;
  final String runnerUpParty;
  final int runnerUpVotes;
  final String verdict;
  final List<ElectionDriver> drivers;
  final List<RegionalDynamic> regionalDynamics;
  final List<String> winningNarrative;
  final List<String> losingNarrative;
  final List<StrategicLesson> lessons;
  final List<LegalMilestone> legalAftermath;
  final List<IntelligenceSourceRef> sources;

  int get margin => winnerVotes - runnerUpVotes;
}

const electionCycleIntelligence = <ElectionCycleIntelligence>[
  ElectionCycleIntelligence(
    year: 2015,
    winnerName: 'Samuel Ortom',
    winnerParty: 'APC',
    winnerVotes: 422932,
    runnerUpName: 'Terhemen Tarzoor',
    runnerUpParty: 'PDP',
    runnerUpVotes: 313878,
    verdict:
        'A change election that ended 16 years of PDP governorship control. The strongest evidence points to governance fatigue, salary and pension arrears, PDP internal fractures and a broader opposition-change environment combining with Ortom’s personal network.',
    drivers: [
      ElectionDriver(
        title: 'Civil-service and pension backlash',
        category: 'Governance / economy',
        effect: 'Major APC advantage',
        detail:
            'Benue is heavily dependent on the public sector. Contemporary reporting described roughly five to six months of unpaid salaries, pension arrears and teacher grievances. That converted routine economic pain into a direct anti-incumbency issue.',
        impact: 5,
        confidence: IntelConfidence.high,
        evidenceType: IntelligenceEvidenceType.sourceBackedInterpretation,
        sourceIds: ['2015-nation-loss', '2015-vanguard-impunity'],
      ),
      ElectionDriver(
        title: 'PDP primary and internal-party fracture',
        category: 'Party organization',
        effect: 'Reduced PDP cohesion',
        detail:
            'Post-primary dissatisfaction weakened the incumbent party’s ability to present a united succession campaign. Contemporary stakeholders specifically identified candidate-selection disputes and internal grievances as part of the loss.',
        impact: 4,
        confidence: IntelConfidence.medium,
        evidenceType: IntelligenceEvidenceType.sourceBackedInterpretation,
        sourceIds: ['2015-nation-loss'],
      ),
      ElectionDriver(
        title: 'National change environment',
        category: 'Political environment',
        effect: 'Amplified APC momentum',
        detail:
            'The governorship contest followed an historic national opposition victory. The APC’s change message therefore arrived in Benue with unusually strong national momentum, reinforcing local dissatisfaction with the incumbent PDP structure.',
        impact: 4,
        confidence: IntelConfidence.medium,
        evidenceType: IntelligenceEvidenceType.sourceBackedInterpretation,
        sourceIds: ['2015-vanguard-impunity'],
      ),
      ElectionDriver(
        title: 'Ortom’s cross-party personal network',
        category: 'Candidate effect',
        effect: 'Expanded APC coalition',
        detail:
            'Ortom entered the APC after a PDP nomination struggle but retained significant statewide political relationships. The result should therefore not be modeled as a simple permanent APC-versus-PDP loyalty shift.',
        impact: 4,
        confidence: IntelConfidence.medium,
        evidenceType: IntelligenceEvidenceType.sourceBackedInterpretation,
        sourceIds: ['2015-nation-loss'],
      ),
    ],
    regionalDynamics: [
      RegionalDynamic(
        title: 'Central urban / Tiv heartland breakthrough',
        geography: 'Makurdi, Gboko, Tarka, Vandeikya, Gwer East',
        result:
            'The available 2015 LGA extract shows substantial APC advantages in several of these high-value areas.',
        interpretation:
            'Public-sector grievance, opposition momentum and Ortom’s political base combined most visibly in this corridor. The 2015 LGA dataset is partial, so this is directional rather than a complete 23-LGA reconstruction.',
        confidence: IntelConfidence.medium,
        sourceIds: ['2015-lga-extract', '2015-vanguard-impunity'],
      ),
      RegionalDynamic(
        title: 'Benue South became more contestable',
        geography: 'Zone C / Benue South',
        result:
            'The partial table shows a mixed pattern rather than one uniform party sweep.',
        interpretation:
            'Traditional PDP strength remained important, but APC competitiveness in parts of the zone reduced the cushion needed to offset losses elsewhere.',
        confidence: IntelConfidence.medium,
        sourceIds: ['2015-lga-extract'],
      ),
      RegionalDynamic(
        title: 'Sankera and Jechira remained mixed',
        geography: 'Katsina-Ala, Logo and surrounding northern/eastern LGAs',
        result:
            'The available extract contains PDP-leading pockets alongside APC-leading areas.',
        interpretation:
            'Local alignments mattered. The statewide outcome was not a uniform wave; pockets resistant to Ortom’s late party switch remained visible.',
        confidence: IntelConfidence.medium,
        sourceIds: ['2015-lga-extract'],
      ),
    ],
    winningNarrative: [
      'Change and rescue from an exhausted incumbent political order.',
      'A pro-worker message that benefited from anger over salary and pension arrears.',
      'Ortom could campaign as both an experienced insider and a break from the outgoing PDP succession arrangement.',
      'The national APC change environment reinforced the local opposition message.',
    ],
    losingNarrative: [
      'PDP relied heavily on the strength of a 16-year governing structure while the electorate was showing clear fatigue.',
      'The succession process did not fully reunify aggrieved party blocs after the primary.',
      'The campaign could not detach Tarzoor sufficiently from the outgoing administration’s salary and pension crisis.',
      'Traditional strongholds were no longer strong enough to compensate for large losses in central high-population areas.',
    ],
    lessons: [
      StrategicLesson(
        title: 'Integrate legacy and new coalition structures earlier',
        detail:
            'A late party switch can win an election but still leaves organizational friction. A winning coalition should be integrated before election day, not only after victory.',
        forWinner: true,
      ),
      StrategicLesson(
        title: 'Localize the campaign deeper in resistant areas',
        detail:
            'A statewide change message should still be translated into LGA-specific economic, agricultural, security and community priorities.',
        forWinner: true,
      ),
      StrategicLesson(
        title: 'Resolve primary wounds before the general election',
        detail:
            'The losing party needed a structured reconciliation programme for aspirants, financiers and local networks immediately after candidate selection.',
        forWinner: false,
      ),
      StrategicLesson(
        title: 'Own the economic grievance instead of minimizing it',
        detail:
            'A credible salary-arrears and pension recovery plan could have reduced the anti-incumbency penalty among workers, pensioners and their households.',
        forWinner: false,
      ),
    ],
    legalAftermath: [
      LegalMilestone(
        stage: 'Election Petition Tribunal',
        outcome: 'Petition dismissed',
        detail:
            'Tarzoor challenged Ortom’s qualification and nomination after INEC declared the APC candidate winner.',
        sourceIds: ['2015-supreme-court'],
      ),
      LegalMilestone(
        stage: 'Court of Appeal',
        outcome: 'Tribunal decision affirmed',
        detail:
            'The appellate court upheld the dismissal before the dispute proceeded to the Supreme Court.',
        sourceIds: ['2015-supreme-court'],
      ),
      LegalMilestone(
        stage: 'Supreme Court',
        outcome: 'Ortom victory finally upheld',
        detail:
            'The Supreme Court dismissed Tarzoor’s appeal and affirmed the lower-court judgment.',
        sourceIds: ['2015-supreme-court'],
      ),
    ],
    sources: [
      IntelligenceSourceRef(
        id: '2015-nation-loss',
        publisher: 'The Nation',
        title: 'Why PDP lost Benue, by stakeholders',
        reference: '28 April 2015',
        quality: 'Contemporary political reporting',
      ),
      IntelligenceSourceRef(
        id: '2015-vanguard-impunity',
        publisher: 'Vanguard',
        title: 'Benue: Impunity upturned',
        reference: '14 April 2015',
        quality: 'Contemporary post-election analysis',
      ),
      IntelligenceSourceRef(
        id: '2015-supreme-court',
        publisher: 'Supreme Court of Nigeria / NigeriaLII',
        title: 'Tarzoor v Ortom & Others, SC.928/2015',
        reference: 'Judgment delivered January 2016',
        quality: 'Primary judicial record',
      ),
      IntelligenceSourceRef(
        id: '2015-lga-extract',
        publisher: 'Published LGA collation archive',
        title: '2015 Benue LGA result extract',
        reference: '15 of 23 unique LGA rows loaded in PoliSphere',
        quality: 'Partial secondary geographic dataset',
      ),
    ],
  ),
  ElectionCycleIntelligence(
    year: 2019,
    winnerName: 'Samuel Ortom',
    winnerParty: 'PDP',
    winnerVotes: 434473,
    runnerUpName: 'Emmanuel Jime',
    runnerUpParty: 'APC',
    runnerUpVotes: 345155,
    verdict:
        'A security-identity and coalition election. Ortom converted his confrontation with the federal APC over anti-open-grazing policy into a defender-of-Benue narrative, rebuilt a broad PDP coalition and retained enough support through the supplementary poll to win a second term.',
    drivers: [
      ElectionDriver(
        title: 'Security identity and anti-open-grazing stance',
        category: 'Security / identity',
        effect: 'Major PDP advantage',
        detail:
            'Contemporary analysis repeatedly identified Ortom’s anti-open-grazing law and his public confrontation with the federal government over killings as the most politically salient element of his re-election coalition.',
        impact: 5,
        confidence: IntelConfidence.high,
        evidenceType: IntelligenceEvidenceType.sourceBackedInterpretation,
        sourceIds: ['2019-thisday-allied', '2019-thisday-lifeline'],
      ),
      ElectionDriver(
        title: 'Defender-of-Benue campaign narrative',
        category: 'Narrative',
        effect: 'Reframed weak governance ratings',
        detail:
            'Ortom’s campaign consistently presented him as the leader prepared to confront threats to Benue communities. Pre-election reporting noted that this issue could overshadow criticism of his first-term performance.',
        impact: 5,
        confidence: IntelConfidence.high,
        evidenceType: IntelligenceEvidenceType.sourceBackedInterpretation,
        sourceIds: ['2019-thisday-lifeline', '2019-thisday-road'],
      ),
      ElectionDriver(
        title: 'Broad institutional and community outreach',
        category: 'Coalition building',
        effect: 'Expanded PDP retention',
        detail:
            'Post-election reporting described outreach to civil servants, pensioners, religious groups, traditional institutions and local political blocs, including renewed promises to clear salary and pension backlogs.',
        impact: 4,
        confidence: IntelConfidence.medium,
        evidenceType: IntelligenceEvidenceType.sourceBackedInterpretation,
        sourceIds: ['2019-thisday-allied'],
      ),
      ElectionDriver(
        title: 'Succession and zoning calculations',
        category: 'Elite / regional alignment',
        effect: 'Helped incumbent coalition',
        detail:
            'Contemporary analysis reported that some regional actors preferred Ortom completing a second term because it could improve their succession prospects in 2023 compared with electing a new governor from the same broad zone.',
        impact: 3,
        confidence: IntelConfidence.medium,
        evidenceType: IntelligenceEvidenceType.sourceBackedInterpretation,
        sourceIds: ['2019-thisday-allied', '2019-thisday-road'],
      ),
      ElectionDriver(
        title: 'Supplementary-election resilience',
        category: 'Election process',
        effect: 'Preserved first-round lead',
        detail:
            'INEC declared the first poll inconclusive and held supplementary voting in 204 polling units across 22 LGAs. Ortom entered that round with a substantial lead and finished with an 89,318-vote margin.',
        impact: 3,
        confidence: IntelConfidence.high,
        evidenceType: IntelligenceEvidenceType.verifiedFact,
        sourceIds: ['2019-guardian-result'],
      ),
    ],
    regionalDynamics: [
      RegionalDynamic(
        title: 'North-central / central Benue strength',
        geography: 'Guma, Gwer areas, Buruku, Gboko and allied areas',
        result:
            'The published 2019 LGA table shows strong PDP direction in several of Ortom’s core areas.',
        interpretation:
            'Security identity and the incumbent coalition translated most effectively in the governor’s political base.',
        confidence: IntelConfidence.medium,
        sourceIds: ['2019-thisday-allied', '2019-lga-table'],
      ),
      RegionalDynamic(
        title: 'Competitive urban and southern corridor',
        geography: 'Makurdi, Otukpo, Oju, Tarka and parts of Benue South',
        result:
            'APC remained highly competitive in several published LGA rows even though PDP won statewide.',
        interpretation:
            'The re-election coalition was broad enough to win statewide but not geographically uniform.',
        confidence: IntelConfidence.medium,
        sourceIds: ['2019-lga-table'],
      ),
      RegionalDynamic(
        title: 'Use the 2019 LGA table directionally',
        geography: 'All 23 LGAs',
        result:
            'All rows are loaded, but the published table does not fully reconcile to final EC8E totals after supplementary voting.',
        interpretation:
            'PoliSphere should use 2019 LGA values for geographic direction and narrative analysis, not as perfectly reconciled final official swing values.',
        confidence: IntelConfidence.high,
        sourceIds: ['2019-lga-table'],
      ),
    ],
    winningNarrative: [
      'Ortom positioned himself as the defender of Benue communities on the security and grazing question.',
      'The campaign converted conflict with the federal APC from a liability into a local political identity.',
      'Community, religious, traditional and worker outreach widened the coalition beyond formal party structures.',
      'The PDP organization was strong enough to preserve a clear lead through a supplementary election.',
    ],
    losingNarrative: [
      'APC’s national incumbency and organizational strength did not automatically translate into a local governorship majority.',
      'Jime faced an opponent who successfully localized the contest around Benue security and identity rather than a simple national-party comparison.',
      'The campaign could not sufficiently neutralize the perception that the federal APC was unsympathetic to Benue’s security grievances.',
      'APC strength in several LGAs was insufficient against PDP’s broader statewide coalition.',
    ],
    lessons: [
      StrategicLesson(
        title: 'Protect the issue coalition after victory',
        detail:
            'When one emotionally powerful issue drives a coalition, the government must convert the symbolic mandate into measurable security, resettlement and governance outcomes.',
        forWinner: true,
      ),
      StrategicLesson(
        title: 'Do not allow a single issue to conceal unresolved service-delivery weaknesses',
        detail:
            'Salary, pension and service-delivery problems remained politically dangerous even though security dominated the election.',
        forWinner: true,
      ),
      StrategicLesson(
        title: 'Localize the party brand',
        detail:
            'The losing campaign needed a clearer Benue-specific security position distinct from national-party perceptions.',
        forWinner: false,
      ),
      StrategicLesson(
        title: 'Build broader local alliances before the campaign peaks',
        detail:
            'Strong federal or party machinery cannot replace sustained relationships with traditional, religious, worker and LGA-level networks.',
        forWinner: false,
      ),
    ],
    legalAftermath: [
      LegalMilestone(
        stage: 'INEC collation',
        outcome: 'Initial election declared inconclusive',
        detail:
            'The margin was smaller than the number of registered voters in cancelled polling units, triggering supplementary voting.',
        sourceIds: ['2019-guardian-result'],
      ),
      LegalMilestone(
        stage: 'Supplementary election',
        outcome: 'Ortom declared re-elected',
        detail:
            'After supplementary voting in 204 polling units across 22 LGAs, Ortom finished on 434,473 votes to Jime’s 345,155.',
        sourceIds: ['2019-guardian-result'],
      ),
      LegalMilestone(
        stage: 'Post-election litigation',
        outcome: 'Ortom’s return ultimately sustained',
        detail:
            'The election survived the subsequent tribunal and appellate challenge process.',
        sourceIds: ['2019-guardian-result'],
      ),
    ],
    sources: [
      IntelligenceSourceRef(
        id: '2019-thisday-allied',
        publisher: 'THISDAY',
        title: 'How Allied Forces Defeated Federal Might in Benue',
        reference: '31 March 2019',
        quality: 'Contemporary post-election analysis',
      ),
      IntelligenceSourceRef(
        id: '2019-thisday-lifeline',
        publisher: 'THISDAY',
        title: 'A Lifeline for Ortom, Jime on March 23',
        reference: '17 March 2019',
        quality: 'Contemporary pre-supplementary analysis',
      ),
      IntelligenceSourceRef(
        id: '2019-thisday-road',
        publisher: 'THISDAY',
        title: 'The Road to 2019: Flashpoints to Watch',
        reference: '7 October 2018',
        quality: 'Contemporary pre-election analysis',
      ),
      IntelligenceSourceRef(
        id: '2019-guardian-result',
        publisher: 'The Guardian Nigeria',
        title: 'PDP’s Ortom declared winner of Benue guber poll',
        reference: '24 March 2019',
        quality: 'Result and supplementary-election reporting',
      ),
      IntelligenceSourceRef(
        id: '2019-lga-table',
        publisher: 'Published LGA collation table',
        title: '2019 Benue LGA major-party result table',
        reference: '23 LGA rows loaded in PoliSphere',
        quality: 'Complete LGA coverage, supplementary increments unreconciled',
      ),
    ],
  ),
  ElectionCycleIntelligence(
    year: 2023,
    winnerName: 'Hyacinth Iormem Alia',
    winnerParty: 'APC',
    winnerVotes: 473933,
    runnerUpName: 'Titus Uba',
    runnerUpParty: 'PDP',
    runnerUpVotes: 223913,
    verdict:
        'A candidate-centered change election with a very large APC margin. Alia’s personal popularity, an appetite for change after eight years of PDP government, APC momentum and visible PDP national-party fragmentation combined with a broad geographic APC performance.',
    drivers: [
      ElectionDriver(
        title: 'Alia’s candidate-centered popularity',
        category: 'Candidate effect',
        effect: 'Major APC advantage',
        detail:
            'Pre-election and post-election reporting consistently described Alia as unusually popular across Benue. His identity as a Catholic priest gave him a public profile distinct from the conventional party-establishment candidates.',
        impact: 5,
        confidence: IntelConfidence.medium,
        evidenceType: IntelligenceEvidenceType.sourceBackedInterpretation,
        sourceIds: ['2023-sbm-forecast', '2023-punch-result'],
      ),
      ElectionDriver(
        title: 'Demand for political change',
        category: 'Incumbency / governance',
        effect: 'PDP disadvantage',
        detail:
            'The outgoing PDP administration was term-limited after eight years and the winning candidate campaigned as a break from the existing political establishment. The scale of the margin is consistent with a broad change election, although causality cannot be assigned from results alone.',
        impact: 4,
        confidence: IntelConfidence.medium,
        evidenceType: IntelligenceEvidenceType.sourceBackedInterpretation,
        sourceIds: ['2023-sbm-forecast', '2023-channels-watch'],
      ),
      ElectionDriver(
        title: 'PDP national-party fracture reached Benue',
        category: 'Party cohesion',
        effect: 'Weakened PDP coherence',
        detail:
            'Governor Ortom was a leading member of the G5 governors who refused to campaign for the PDP presidential candidate. The dispute did not automatically determine the governorship result, but it created a visibly divided party environment immediately before the state election.',
        impact: 4,
        confidence: IntelConfidence.medium,
        evidenceType: IntelligenceEvidenceType.sourceBackedInterpretation,
        sourceIds: ['2023-guardian-g5', '2023-channels-watch'],
      ),
      ElectionDriver(
        title: 'APC momentum before the governorship vote',
        category: 'Political environment',
        effect: 'Reinforced APC viability',
        detail:
            'A pre-election intelligence survey projected an APC governorship win using its Benue interviews together with the presidential-election result. This is supporting evidence of momentum, not proof that national voting mechanically caused the governorship outcome.',
        impact: 3,
        confidence: IntelConfidence.medium,
        evidenceType: IntelligenceEvidenceType.sourceBackedInterpretation,
        sourceIds: ['2023-sbm-forecast'],
      ),
      ElectionDriver(
        title: 'Broad geographic APC advantage',
        category: 'Electoral geography',
        effect: 'Converted popularity into margin',
        detail:
            'The reconciled 2023 LGA table shows APC leading most LGAs, while PDP retained several pockets and LP led Konshisha. Kwande had no governorship poll because of the ballot-paper problem.',
        impact: 5,
        confidence: IntelConfidence.high,
        evidenceType: IntelligenceEvidenceType.verifiedFact,
        sourceIds: ['2023-punch-result', '2023-lga-table'],
      ),
    ],
    regionalDynamics: [
      RegionalDynamic(
        title: 'APC won across multiple zones',
        geography: 'Statewide',
        result:
            'Alia finished with 473,933 votes against Uba’s 223,913 and APC led most reporting LGAs.',
        interpretation:
            'The victory was geographically broad rather than dependent on one single stronghold.',
        confidence: IntelConfidence.high,
        sourceIds: ['2023-punch-result', '2023-lga-table'],
      ),
      RegionalDynamic(
        title: 'PDP retained identifiable pockets',
        geography: 'Guma, Gwer West, Logo and other competitive areas',
        result:
            'The reconciled LGA table shows PDP-leading pockets despite the statewide APC landslide.',
        interpretation:
            'The loss was severe but not total. These areas matter when distinguishing recoverable historic strength from places requiring deeper rebuilding.',
        confidence: IntelConfidence.high,
        sourceIds: ['2023-lga-table'],
      ),
      RegionalDynamic(
        title: 'Third-party disruption was locally concentrated',
        geography: 'Konshisha and selected LGAs',
        result:
            'LP led Konshisha and recorded meaningful votes in several other LGAs.',
        interpretation:
            'Future modeling should account for third-party vote concentration instead of treating the contest as purely APC versus PDP.',
        confidence: IntelConfidence.high,
        sourceIds: ['2023-lga-table'],
      ),
    ],
    winningNarrative: [
      'Alia offered a candidate-centered change identity rather than relying only on the APC label.',
      'His clerical public profile and pre-existing popularity made him unusually recognizable statewide.',
      'APC entered the governorship election with demonstrated electoral momentum from the preceding national cycle.',
      'The campaign converted support into a broad LGA footprint, producing the largest winning margin of the three elections in PoliSphere’s baseline.',
    ],
    losingNarrative: [
      'PDP entered the election carrying eight years of incumbency without the sitting governor being eligible to seek another term.',
      'The national G5 dispute visibly fragmented the broader PDP campaign environment in Benue.',
      'Titus Uba’s continuity position competed against an opponent with a stronger outsider/change profile.',
      'PDP retained pockets but suffered large vote contraction across many LGAs compared with 2019.',
    ],
    lessons: [
      StrategicLesson(
        title: 'Turn personal popularity into durable institutions',
        detail:
            'A candidate-centered landslide can weaken quickly if the party, local government and service-delivery structures do not become equally credible.',
        forWinner: true,
      ),
      StrategicLesson(
        title: 'Keep broad coalition management ahead of internal rivalry',
        detail:
            'The APC primary itself was highly contested; a winning campaign still needs continuous integration of former aspirants and local power centers.',
        forWinner: true,
      ),
      StrategicLesson(
        title: 'Separate the candidate from unpopular incumbency baggage',
        detail:
            'A succession campaign needs a credible renewal proposition rather than appearing only as continuation of the outgoing administration.',
        forWinner: false,
      ),
      StrategicLesson(
        title: 'Resolve party-level fractures before voter contact peaks',
        detail:
            'Conflicts at national and state party level can dilute message discipline, volunteer energy and coalition trust even when the governorship candidate remains locally viable.',
        forWinner: false,
      ),
    ],
    legalAftermath: [
      LegalMilestone(
        stage: 'Election Petition Tribunal',
        outcome: 'PDP/Uba petition dismissed',
        detail:
            'The tribunal held that it lacked jurisdiction over the pre-election qualification and nomination issues raised in the petition.',
        sourceIds: ['2023-channels-tribunal'],
      ),
      LegalMilestone(
        stage: 'Court of Appeal',
        outcome: 'Alia victory affirmed',
        detail:
            'The Court of Appeal dismissed Uba’s appeal and resolved the issues against the appellants.',
        sourceIds: ['2023-channels-appeal'],
      ),
    ],
    sources: [
      IntelligenceSourceRef(
        id: '2023-punch-result',
        publisher: 'Punch',
        title: 'How APC’s Rev Fr Alia won Benue gov election',
        reference: '20 March 2023',
        quality: 'Election-result and geographic reporting',
      ),
      IntelligenceSourceRef(
        id: '2023-sbm-forecast',
        publisher: 'SBM Intelligence / EiE',
        title: 'Governorship Election Forecast — Benue',
        reference: 'March 2023',
        quality: 'Pre-election survey/forecast with methodology limitations',
      ),
      IntelligenceSourceRef(
        id: '2023-guardian-g5',
        publisher: 'The Guardian Nigeria',
        title: 'G5 PDP governors not relenting in fight with Ayu, Atiku',
        reference: '8 November 2022',
        quality: 'Contemporary reporting on party cohesion',
      ),
      IntelligenceSourceRef(
        id: '2023-channels-watch',
        publisher: 'Channels Television',
        title: 'Governorship Elections: states to watch',
        reference: '16 March 2023',
        quality: 'Contemporary pre-election context',
      ),
      IntelligenceSourceRef(
        id: '2023-channels-tribunal',
        publisher: 'Channels Television',
        title: 'Benue Governorship Tribunal Upholds Alia’s Election',
        reference: '23 September 2023',
        quality: 'Judicial outcome reporting',
      ),
      IntelligenceSourceRef(
        id: '2023-channels-appeal',
        publisher: 'Channels Television',
        title: 'Appeal Court Dismisses Uba’s Appeal Against Alia',
        reference: '20 November 2023',
        quality: 'Appellate outcome reporting',
      ),
      IntelligenceSourceRef(
        id: '2023-lga-table',
        publisher: 'Published Benue LGA result compilation',
        title: '2023 Benue LGA result table',
        reference: '23 LGA records loaded in PoliSphere',
        quality: 'APC/PDP/LP columns reconciled to statewide declaration',
      ),
    ],
  ),
];

ElectionCycleIntelligence intelligenceForYear(int year) =>
    electionCycleIntelligence.firstWhere((cycle) => cycle.year == year);

String confidenceLabel(IntelConfidence confidence) => switch (confidence) {
      IntelConfidence.high => 'High',
      IntelConfidence.medium => 'Medium',
      IntelConfidence.low => 'Low',
    };

String evidenceTypeLabel(IntelligenceEvidenceType type) => switch (type) {
      IntelligenceEvidenceType.verifiedFact => 'Verified fact',
      IntelligenceEvidenceType.sourceBackedInterpretation => 'Source-backed interpretation',
      IntelligenceEvidenceType.campaignLesson => 'Campaign lesson',
    };
