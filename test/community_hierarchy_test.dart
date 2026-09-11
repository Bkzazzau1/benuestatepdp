import 'package:flutter_test/flutter_test.dart';
import 'package:polisphere/benue/community/role_hierarchy.dart';
import 'package:polisphere/benue/domain/models.dart';
import 'package:polisphere/benue/session.dart';

void main() {
  test('every authenticated role can access forum and meeting room', () {
    for (final role in CampaignRole.values) {
      final modules = allowedModules(role);
      expect(modules.contains(AppModule.discussionForum), isTrue,
          reason: '${role.name} should have forum access');
      expect(modules.contains(AppModule.meetingRoom), isTrue,
          reason: '${role.name} should have meeting-room access');
    }
  });

  test('coordination rank controls coordinator creation', () {
    expect(
      canCreateCoordinatorRank(
        CampaignRole.directorGeneral,
        CoordinationRank.stateCoordinator,
      ),
      isTrue,
    );
    expect(
      canCreateCoordinatorRank(
        CampaignRole.stateAdministrator,
        CoordinationRank.lgaCoordinator,
      ),
      isTrue,
    );
    expect(
      canCreateCoordinatorRank(
        CampaignRole.lgaCoordinator,
        CoordinationRank.wardCoordinator,
      ),
      isTrue,
    );
    expect(
      canCreateCoordinatorRank(
        CampaignRole.lgaCoordinator,
        CoordinationRank.stateCoordinator,
      ),
      isFalse,
    );
    expect(
      canCreateCoordinatorRank(
        CampaignRole.wardCoordinator,
        CoordinationRank.lgaCoordinator,
      ),
      isFalse,
    );
  });

  test('LGA coordinator cannot invite another LGA by location', () {
    const makurdi = GeographicScope(
      level: GeographyLevel.lga,
      state: 'Benue',
      lgaId: 'BEN-LGA-13',
      lga: 'Makurdi',
    );
    const gboko = GeographicScope(
      level: GeographyLevel.lga,
      state: 'Benue',
      lgaId: 'BEN-LGA-05',
      lga: 'Gboko',
    );

    expect(
      canInviteByLocation(
        actorRole: CampaignRole.lgaCoordinator,
        actorScope: makurdi,
        candidate: makurdi,
      ),
      isTrue,
    );
    expect(
      canInviteByLocation(
        actorRole: CampaignRole.lgaCoordinator,
        actorScope: makurdi,
        candidate: gboko,
      ),
      isFalse,
    );
  });

  test('state-assigned account may convene within Benue but has no creation rank', () {
    const gboko = GeographicScope(
      level: GeographyLevel.lga,
      state: 'Benue',
      lgaId: 'BEN-LGA-05',
      lga: 'Gboko',
    );

    expect(
      canInviteByLocation(
        actorRole: CampaignRole.mediaIntelligenceOfficer,
        actorScope: GeographicScope.benueState,
        candidate: gboko,
      ),
      isTrue,
    );
    expect(
      creatableCoordinatorRanks(CampaignRole.mediaIntelligenceOfficer),
      isEmpty,
    );
  });
}
