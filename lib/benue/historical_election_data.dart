class HistoricalCandidateResult {
  const HistoricalCandidateResult({
    required this.name,
    required this.party,
    required this.votes,
    this.elected = false,
  });

  final String name;
  final String party;
  final int votes;
  final bool elected;
}

class HistoricalElectionSource {
  const HistoricalElectionSource({
    required this.label,
    required this.reference,
    required this.coverage,
    required this.quality,
  });

  final String label;
  final String reference;
  final String coverage;
  final String quality;
}

class BenueHistoricalElection {
  const BenueHistoricalElection({
    required this.year,
    required this.electionDateLabel,
    required this.winnerName,
    required this.winnerParty,
    required this.runnerUpName,
    required this.runnerUpParty,
    required this.winnerVotes,
    required this.runnerUpVotes,
    required this.registeredVoters,
    required this.candidates,
    required this.sources,
    required this.context,
    this.accreditedVoters,
    this.validVotes,
    this.rejectedVotes,
    this.totalVotesCast,
    this.pollingUnits,
    this.registrationAreas,
    this.lgas = 23,
    this.pvcsCollected,
    this.supplementary = false,
  });

  final int year;
  final String electionDateLabel;
  final String winnerName;
  final String winnerParty;
  final String runnerUpName;
  final String runnerUpParty;
  final int winnerVotes;
  final int runnerUpVotes;
  final int registeredVoters;
  final int? accreditedVoters;
  final int? validVotes;
  final int? rejectedVotes;
  final int? totalVotesCast;
  final int? pollingUnits;
  final int? registrationAreas;
  final int lgas;
  final int? pvcsCollected;
  final bool supplementary;
  final List<HistoricalCandidateResult> candidates;
  final List<HistoricalElectionSource> sources;
  final String context;

  int get margin => winnerVotes - runnerUpVotes;

  double? get turnoutPercent {
    final numerator = accreditedVoters ?? totalVotesCast;
    if (numerator == null || registeredVoters == 0) return null;
    return numerator / registeredVoters * 100;
  }

  double get winnerShareOfKnownValidVotes {
    final denominator = validVotes ?? candidates.fold<int>(0, (sum, item) => sum + item.votes);
    if (denominator == 0) return 0;
    return winnerVotes / denominator * 100;
  }

  int get knownCandidateVoteTotal =>
      candidates.fold<int>(0, (sum, item) => sum + item.votes);
}

const benueHistoricalElectionsOfficial = <BenueHistoricalElection>[
  BenueHistoricalElection(
    year: 2015,
    electionDateLabel: '11 April 2015',
    winnerName: 'Samuel Ortom',
    winnerParty: 'APC',
    runnerUpName: 'Terhemen Tarzoor',
    runnerUpParty: 'PDP',
    winnerVotes: 422932,
    runnerUpVotes: 313878,
    registeredVoters: 1927062,
    accreditedVoters: 797788,
    validVotes: 744494,
    rejectedVotes: 14903,
    totalVotesCast: 759397,
    candidates: [
      HistoricalCandidateResult(name: 'Samuel Ortom', party: 'APC', votes: 422932, elected: true),
      HistoricalCandidateResult(name: 'Terhemen Tarzoor', party: 'PDP', votes: 313878),
      HistoricalCandidateResult(name: 'LP candidate', party: 'LP', votes: 2653),
      HistoricalCandidateResult(name: 'APA candidate', party: 'APA', votes: 1595),
      HistoricalCandidateResult(name: 'ACPN candidate', party: 'ACPN', votes: 1431),
      HistoricalCandidateResult(name: 'NNPP candidate', party: 'NNPP', votes: 767),
      HistoricalCandidateResult(name: 'APGA candidate', party: 'APGA', votes: 649),
      HistoricalCandidateResult(name: 'SDP candidate', party: 'SDP', votes: 589),
    ],
    sources: [
      HistoricalElectionSource(
        label: 'INEC 2015 Governorship Declaration Data',
        reference: 'INEC-hosted Benue voter participation paper, Table 4; source cited as INEC 2015 Governorship Election declaration of results.',
        coverage: 'Registered voters, accredited voters, party votes, valid votes, rejected votes, total votes cast and turnout.',
        quality: 'INEC-hosted / declaration-derived',
      ),
    ],
    context: 'APC won the governorship. INEC-derived figures provide a complete statewide participation baseline for this cycle.',
  ),
  BenueHistoricalElection(
    year: 2019,
    electionDateLabel: '9 & 23 March 2019',
    winnerName: 'Samuel Ioraer Ortom',
    winnerParty: 'PDP',
    runnerUpName: 'Emmanuel Jime',
    runnerUpParty: 'APC',
    winnerVotes: 434473,
    runnerUpVotes: 345155,
    registeredVoters: 2480131,
    validVotes: 830954,
    pollingUnits: 3688,
    registrationAreas: 276,
    pvcsCollected: 2244376,
    supplementary: true,
    candidates: [
      HistoricalCandidateResult(name: 'Samuel Ioraer Ortom', party: 'PDP', votes: 434473, elected: true),
      HistoricalCandidateResult(name: 'Emmanuel Jime', party: 'APC', votes: 345155),
      HistoricalCandidateResult(name: 'Frederick Ikyaan Lanshima', party: 'PRP', votes: 26786),
      HistoricalCandidateResult(name: 'Hwande Stephen Terungwa', party: 'SDP', votes: 5620),
      HistoricalCandidateResult(name: 'Angya Paul Yavershima', party: 'LP', votes: 3742),
      HistoricalCandidateResult(name: 'John Aondohemba Tseayo', party: 'APGA', votes: 3502),
      HistoricalCandidateResult(name: 'Tyohemba Simon Korape', party: 'ADC', votes: 1693),
      HistoricalCandidateResult(name: 'Stephen Akuma S', party: 'NCP', votes: 1513),
      HistoricalCandidateResult(name: 'Jim Okewu', party: 'ADP', votes: 1224),
      HistoricalCandidateResult(name: 'Apinke Torkwagh', party: 'PPN', votes: 1056),
      HistoricalCandidateResult(name: 'Clement Aondona Tyav', party: 'PPC', votes: 986),
      HistoricalCandidateResult(name: 'Ogiri Maxwell', party: 'APDA', votes: 730),
      HistoricalCandidateResult(name: 'Lady Comfort Angula', party: 'NRM', votes: 567),
      HistoricalCandidateResult(name: 'Sam Zuga', party: 'NPC', votes: 492),
      HistoricalCandidateResult(name: 'Iyah Iyah', party: 'ANN', votes: 477),
      HistoricalCandidateResult(name: 'Ayua Terhiley Emmanuel', party: 'YPP', votes: 424),
      HistoricalCandidateResult(name: 'Patrick Odeh', party: 'PPP', votes: 370),
      HistoricalCandidateResult(name: 'Agada Grace', party: 'BNPP', votes: 315),
      HistoricalCandidateResult(name: 'Caleb Ter Nyikwagh', party: 'AAC', votes: 268),
      HistoricalCandidateResult(name: 'Eije Eyum Cynthia', party: 'MPN', votes: 204),
      HistoricalCandidateResult(name: 'Sam Abah', party: 'UPP', votes: 197),
      HistoricalCandidateResult(name: 'Akpur Emmanuel Terfa', party: 'AA', votes: 191),
      HistoricalCandidateResult(name: 'Jacob Tsavtim Terhemen', party: 'ACD', votes: 156),
      HistoricalCandidateResult(name: 'Comr Richard Gbawuan', party: 'ZLP', votes: 128),
      HistoricalCandidateResult(name: 'Nyitse Richard', party: 'NEPP', votes: 123),
      HistoricalCandidateResult(name: 'Daa’gba Innocent I. D.', party: 'PT', votes: 117),
      HistoricalCandidateResult(name: 'Ahemba Godwin', party: 'ABP', votes: 112),
      HistoricalCandidateResult(name: 'Kuraun Luben Jeremiah', party: 'JMPP', votes: 78),
      HistoricalCandidateResult(name: 'Hemba Gabriel', party: 'SNP', votes: 75),
      HistoricalCandidateResult(name: 'Verem Turugh', party: 'GPN', votes: 45),
      HistoricalCandidateResult(name: 'Emmanuel Asortar', party: 'GDPN', votes: 43),
      HistoricalCandidateResult(name: 'Orgber M Collins', party: 'DA', votes: 42),
      HistoricalCandidateResult(name: 'Ojobo John Douglas', party: 'CAP', votes: 50),
    ],
    sources: [
      HistoricalElectionSource(
        label: 'INEC Benue 2019 Governorship EC8E',
        reference: 'Official Benue State governorship Results of Election sheet (EC8E).',
        coverage: 'All 33 candidate names, parties, votes and declared winner.',
        quality: 'Official INEC result sheet',
      ),
      HistoricalElectionSource(
        label: 'INEC Report of the 2019 General Election',
        reference: 'North Central delimitation table and Benue election review section.',
        coverage: 'Registered voters, PVCs collected, 23 LGAs, 276 RAs, 3,688 PUs and supplementary-election context.',
        quality: 'Official INEC election report',
      ),
    ],
    context: 'The 9 March governorship election was declared inconclusive. INEC reported an 80,550-vote lead against 121,685 registered voters in affected cancelled PUs; a supplementary election followed on 23 March.',
  ),
  BenueHistoricalElection(
    year: 2023,
    electionDateLabel: '18 March 2023',
    winnerName: 'Hyacinth Iormem Alia',
    winnerParty: 'APC',
    runnerUpName: 'Titus Uba',
    runnerUpParty: 'PDP',
    winnerVotes: 473933,
    runnerUpVotes: 223913,
    registeredVoters: 2777727,
    pollingUnits: 5102,
    registrationAreas: 276,
    candidates: [
      HistoricalCandidateResult(name: 'Hyacinth Iormem Alia', party: 'APC', votes: 473933, elected: true),
      HistoricalCandidateResult(name: 'Titus Uba', party: 'PDP', votes: 223913),
      HistoricalCandidateResult(name: 'Herman Hembe', party: 'LP', votes: 41881),
    ],
    sources: [
      HistoricalElectionSource(
        label: 'INEC Report of the 2023 General Election',
        reference: 'Table 8.8 and Annexure 3.',
        coverage: '2,777,727 registered voters; 23 LGAs; 276 RAs; 5,102 PUs; APC recorded as winning party.',
        quality: 'Official INEC election report',
      ),
      HistoricalElectionSource(
        label: 'INEC Governorship Result Declaration',
        reference: 'Benue statewide governorship declaration totals used for the leading candidates.',
        coverage: 'Leading candidate vote totals and margin used by the comparison model.',
        quality: 'Declared result totals',
      ),
    ],
    context: 'APC returned to the governorship with a substantially larger winning margin than either 2015 or 2019. The registered-voter roll was 12% larger than in 2019.',
  ),
];
