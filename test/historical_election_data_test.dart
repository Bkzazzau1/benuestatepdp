import 'package:flutter_test/flutter_test.dart';
import 'package:polisphere/benue/historical_election_data.dart';

void main() {
  test('2015 INEC participation baseline remains intact', () {
    final election = benueHistoricalElectionsOfficial
        .firstWhere((item) => item.year == 2015);

    expect(election.registeredVoters, 1927062);
    expect(election.accreditedVoters, 797788);
    expect(election.validVotes, 744494);
    expect(election.rejectedVotes, 14903);
    expect(election.totalVotesCast, 759397);
    expect(election.winnerVotes, 422932);
    expect(election.runnerUpVotes, 313878);
    expect(election.margin, 109054);
  });

  test('2019 official EC8E candidate scores reconcile', () {
    final election = benueHistoricalElectionsOfficial
        .firstWhere((item) => item.year == 2019);

    expect(election.candidates.length, 33);
    expect(election.knownCandidateVoteTotal, 830954);
    expect(election.validVotes, 830954);
    expect(election.winnerVotes, 434473);
    expect(election.runnerUpVotes, 345155);
    expect(election.margin, 89318);
    expect(election.registeredVoters, 2480131);
    expect(election.pvcsCollected, 2244376);
    expect(election.supplementary, isTrue);
  });

  test('2023 official structural baseline remains intact', () {
    final election = benueHistoricalElectionsOfficial
        .firstWhere((item) => item.year == 2023);

    expect(election.registeredVoters, 2777727);
    expect(election.lgas, 23);
    expect(election.registrationAreas, 276);
    expect(election.pollingUnits, 5102);
    expect(election.winnerParty, 'APC');
    expect(election.winnerVotes, 473933);
    expect(election.runnerUpVotes, 223913);
    expect(election.margin, 250020);
  });
}
