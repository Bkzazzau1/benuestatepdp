import '../app_scope.dart';
import '../domain/models.dart';

GeographicScope geographicScopeFromCampaignScope(CampaignScopeController scope) {
  if (scope.pollingUnitId != null) {
    return GeographicScope(
      level: GeographyLevel.pollingUnit,
      state: 'Benue',
      lgaId: scope.lgaId,
      lga: scope.lgaName,
      wardId: scope.wardId,
      ward: scope.wardName,
      pollingUnitId: scope.pollingUnitId,
      pollingUnit: scope.pollingUnitName,
    );
  }
  if (scope.wardId != null) {
    return GeographicScope(
      level: GeographyLevel.ward,
      state: 'Benue',
      lgaId: scope.lgaId,
      lga: scope.lgaName,
      wardId: scope.wardId,
      ward: scope.wardName,
    );
  }
  if (scope.lgaId != null) {
    return GeographicScope(
      level: GeographyLevel.lga,
      state: 'Benue',
      lgaId: scope.lgaId,
      lga: scope.lgaName,
    );
  }
  return GeographicScope.benueState;
}

/// Prototype session-to-account bridge.
///
/// LGA coordinator sessions reuse the stable seeded coordinator ID whenever an
/// LGA is active. Other roles use a deterministic role seat until real account
/// IDs arrive from the backend.
String communityActorId(CampaignRole role, GeographicScope scope) {
  if (role == CampaignRole.lgaCoordinator && scope.lgaId != null) {
    return 'USR-${scope.lgaId}-COORD';
  }
  return 'ROLE-${role.name}';
}
