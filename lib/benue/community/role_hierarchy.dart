import '../domain/models.dart';

/// Coordination rank is intentionally separate from CampaignRole.
///
/// CampaignRole describes the person's functional job. CoordinationRank
/// describes how far that account may delegate people or convene location-
/// based meetings. Keeping the two concepts separate avoids giving a legal,
/// media or finance role accidental personnel-management power simply because
/// it is a state-level job.
enum CoordinationRank {
  member,
  pollingUnitTeam,
  wardCoordinator,
  lgaCoordinator,
  stateCoordinator,
  stateCommand,
}

int coordinationRankValue(CoordinationRank rank) => switch (rank) {
      CoordinationRank.member => 0,
      CoordinationRank.pollingUnitTeam => 10,
      CoordinationRank.wardCoordinator => 20,
      CoordinationRank.lgaCoordinator => 30,
      CoordinationRank.stateCoordinator => 40,
      CoordinationRank.stateCommand => 50,
    };

String coordinationRankLabel(CoordinationRank rank) => switch (rank) {
      CoordinationRank.member => 'Member',
      CoordinationRank.pollingUnitTeam => 'Polling Unit Team',
      CoordinationRank.wardCoordinator => 'Ward Coordinator',
      CoordinationRank.lgaCoordinator => 'LGA Coordinator',
      CoordinationRank.stateCoordinator => 'State Coordinator',
      CoordinationRank.stateCommand => 'State Command',
    };

/// Functional roles mapped to the personnel hierarchy.
///
/// Candidate/DG own state-command authority. State Administrator and
/// Operations Officer are the prototype state-coordination seats. Other
/// specialist roles remain members for personnel creation even though they may
/// have broad module visibility.
CoordinationRank coordinationRankForRole(CampaignRole role) => switch (role) {
      CampaignRole.candidate || CampaignRole.directorGeneral =>
        CoordinationRank.stateCommand,
      CampaignRole.stateAdministrator || CampaignRole.operationsOfficer =>
        CoordinationRank.stateCoordinator,
      CampaignRole.lgaCoordinator => CoordinationRank.lgaCoordinator,
      CampaignRole.wardCoordinator => CoordinationRank.wardCoordinator,
      CampaignRole.pollingUnitAgent => CoordinationRank.pollingUnitTeam,
      _ => CoordinationRank.member,
    };

/// Coordinator seats the current role may create/manage.
///
/// State Command may create State Coordinators and LGA Coordinators. A State
/// Coordinator manages LGA Coordinators. LGA manages Ward, and Ward manages PU
/// teams. This is deliberately not a generic "higher number can create any
/// lower number" rule; it keeps delegation auditable and predictable.
Set<CoordinationRank> creatableCoordinatorRanks(CampaignRole role) =>
    switch (coordinationRankForRole(role)) {
      CoordinationRank.stateCommand => {
          CoordinationRank.stateCoordinator,
          CoordinationRank.lgaCoordinator,
        },
      CoordinationRank.stateCoordinator => {
          CoordinationRank.lgaCoordinator,
        },
      CoordinationRank.lgaCoordinator => {
          CoordinationRank.wardCoordinator,
        },
      CoordinationRank.wardCoordinator => {
          CoordinationRank.pollingUnitTeam,
        },
      _ => const <CoordinationRank>{},
    };

bool canCreateCoordinatorRank(CampaignRole actor, CoordinationRank target) =>
    creatableCoordinatorRanks(actor).contains(target);

/// Returns true when [candidate] falls inside the location boundary controlled
/// by [actorRole] at [actorScope]. Explicit campaign-group membership is
/// handled separately and may deliberately cross a geographic boundary.
bool canInviteByLocation({
  required CampaignRole actorRole,
  required GeographicScope actorScope,
  required GeographicScope candidate,
}) {
  if (actorScope.state != candidate.state) return false;

  return switch (coordinationRankForRole(actorRole)) {
    CoordinationRank.stateCommand || CoordinationRank.stateCoordinator => true,
    CoordinationRank.lgaCoordinator => actorScope.lgaId != null &&
        candidate.lgaId == actorScope.lgaId,
    CoordinationRank.wardCoordinator => actorScope.lgaId != null &&
        actorScope.wardId != null &&
        candidate.lgaId == actorScope.lgaId &&
        candidate.wardId == actorScope.wardId,
    CoordinationRank.pollingUnitTeam => actorScope.lgaId != null &&
        actorScope.wardId != null &&
        actorScope.pollingUnitId != null &&
        candidate.lgaId == actorScope.lgaId &&
        candidate.wardId == actorScope.wardId &&
        candidate.pollingUnitId == actorScope.pollingUnitId,
    CoordinationRank.member => _sameAvailableScope(actorScope, candidate),
  };
}

bool _sameAvailableScope(GeographicScope a, GeographicScope b) {
  if (a.pollingUnitId != null) return a.pollingUnitId == b.pollingUnitId;
  if (a.wardId != null) {
    return a.lgaId == b.lgaId && a.wardId == b.wardId;
  }
  if (a.lgaId != null) return a.lgaId == b.lgaId;
  // A specialist account assigned at state level may convene a statewide
  // location meeting even when it has no coordinator-creation authority.
  return a.level == GeographyLevel.state && b.state == a.state;
}

/// Direct-report relationship used by the Meeting Room "My assignments" mode.
bool isDirectCoordinationReport({
  required CampaignRole actorRole,
  required CampaignRole candidateRole,
}) {
  final actor = coordinationRankForRole(actorRole);
  final candidate = coordinationRankForRole(candidateRole);
  return switch (actor) {
    CoordinationRank.stateCommand => candidate == CoordinationRank.stateCoordinator ||
        candidate == CoordinationRank.lgaCoordinator,
    CoordinationRank.stateCoordinator => candidate == CoordinationRank.lgaCoordinator,
    CoordinationRank.lgaCoordinator => candidate == CoordinationRank.wardCoordinator,
    CoordinationRank.wardCoordinator => candidate == CoordinationRank.pollingUnitTeam,
    _ => false,
  };
}
