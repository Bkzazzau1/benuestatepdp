import 'models.dart';

enum CampaignCapability {
  viewExecutiveDashboard,
  viewElectionIntelligence,
  viewHistoricalResults,
  viewCampaignTrends,
  viewSituationRoom,
  viewCommunications,
  sendOperationalMessage,
  sendBroadcast,
  createIncident,
  acknowledgeIncident,
  assignIncident,
  closeIncident,
  createTask,
  assignTask,
  manageFieldTeams,
  manageLogistics,
  viewMediaIntelligence,
  manageMediaVerification,
  viewCommunityIssues,
  manageDocuments,
  submitFieldReport,
  verifyFieldReport,
  submitElectionResult,
  verifyElectionResult,
  disputeElectionResult,
  viewLegalEvidence,
  exportReports,
  manageUsers,
  manageSystemSettings,
}

/// Central role policy used by UI visibility and backend authorization planning.
///
/// Production APIs must enforce the same permissions server-side; hiding a
/// button in Flutter is never sufficient authorization.
class CampaignPermissionPolicy {
  const CampaignPermissionPolicy._();

  static const Map<CampaignRole, Set<CampaignCapability>> _roleCapabilities = {
    CampaignRole.candidate: {
      CampaignCapability.viewExecutiveDashboard,
      CampaignCapability.viewElectionIntelligence,
      CampaignCapability.viewHistoricalResults,
      CampaignCapability.viewCampaignTrends,
      CampaignCapability.viewSituationRoom,
      CampaignCapability.viewCommunications,
      CampaignCapability.viewMediaIntelligence,
      CampaignCapability.viewCommunityIssues,
      CampaignCapability.viewLegalEvidence,
      CampaignCapability.exportReports,
    },
    CampaignRole.directorGeneral: {
      ...CampaignCapability.values,
    },
    CampaignRole.situationRoomDirector: {
      CampaignCapability.viewExecutiveDashboard,
      CampaignCapability.viewElectionIntelligence,
      CampaignCapability.viewSituationRoom,
      CampaignCapability.viewCommunications,
      CampaignCapability.sendOperationalMessage,
      CampaignCapability.sendBroadcast,
      CampaignCapability.createIncident,
      CampaignCapability.acknowledgeIncident,
      CampaignCapability.assignIncident,
      CampaignCapability.closeIncident,
      CampaignCapability.createTask,
      CampaignCapability.assignTask,
      CampaignCapability.verifyFieldReport,
      CampaignCapability.verifyElectionResult,
      CampaignCapability.disputeElectionResult,
      CampaignCapability.viewLegalEvidence,
      CampaignCapability.exportReports,
    },
    CampaignRole.stateAdministrator: {
      ...CampaignCapability.values,
    },
    CampaignRole.operationsOfficer: {
      CampaignCapability.viewExecutiveDashboard,
      CampaignCapability.viewSituationRoom,
      CampaignCapability.viewCommunications,
      CampaignCapability.sendOperationalMessage,
      CampaignCapability.sendBroadcast,
      CampaignCapability.createIncident,
      CampaignCapability.acknowledgeIncident,
      CampaignCapability.assignIncident,
      CampaignCapability.createTask,
      CampaignCapability.assignTask,
      CampaignCapability.manageFieldTeams,
      CampaignCapability.manageLogistics,
      CampaignCapability.submitFieldReport,
      CampaignCapability.verifyFieldReport,
      CampaignCapability.exportReports,
    },
    CampaignRole.mediaIntelligenceOfficer: {
      CampaignCapability.viewExecutiveDashboard,
      CampaignCapability.viewElectionIntelligence,
      CampaignCapability.viewCampaignTrends,
      CampaignCapability.viewCommunications,
      CampaignCapability.sendOperationalMessage,
      CampaignCapability.viewMediaIntelligence,
      CampaignCapability.manageMediaVerification,
      CampaignCapability.viewCommunityIssues,
      CampaignCapability.manageDocuments,
      CampaignCapability.exportReports,
    },
    CampaignRole.legalOfficer: {
      CampaignCapability.viewSituationRoom,
      CampaignCapability.viewCommunications,
      CampaignCapability.sendOperationalMessage,
      CampaignCapability.createIncident,
      CampaignCapability.acknowledgeIncident,
      CampaignCapability.disputeElectionResult,
      CampaignCapability.viewLegalEvidence,
      CampaignCapability.manageDocuments,
      CampaignCapability.exportReports,
    },
    CampaignRole.logisticsOfficer: {
      CampaignCapability.viewExecutiveDashboard,
      CampaignCapability.viewSituationRoom,
      CampaignCapability.viewCommunications,
      CampaignCapability.sendOperationalMessage,
      CampaignCapability.createIncident,
      CampaignCapability.createTask,
      CampaignCapability.assignTask,
      CampaignCapability.manageLogistics,
      CampaignCapability.submitFieldReport,
      CampaignCapability.exportReports,
    },
    CampaignRole.financeOfficer: {
      CampaignCapability.viewExecutiveDashboard,
      CampaignCapability.viewCommunications,
      CampaignCapability.sendOperationalMessage,
      CampaignCapability.manageDocuments,
      CampaignCapability.exportReports,
    },
    CampaignRole.lgaCoordinator: {
      CampaignCapability.viewExecutiveDashboard,
      CampaignCapability.viewSituationRoom,
      CampaignCapability.viewCommunications,
      CampaignCapability.sendOperationalMessage,
      CampaignCapability.createIncident,
      CampaignCapability.acknowledgeIncident,
      CampaignCapability.createTask,
      CampaignCapability.manageFieldTeams,
      CampaignCapability.manageLogistics,
      CampaignCapability.submitFieldReport,
      CampaignCapability.submitElectionResult,
      CampaignCapability.viewCommunityIssues,
    },
    CampaignRole.wardCoordinator: {
      CampaignCapability.viewSituationRoom,
      CampaignCapability.viewCommunications,
      CampaignCapability.sendOperationalMessage,
      CampaignCapability.createIncident,
      CampaignCapability.createTask,
      CampaignCapability.manageFieldTeams,
      CampaignCapability.submitFieldReport,
      CampaignCapability.submitElectionResult,
      CampaignCapability.viewCommunityIssues,
    },
    CampaignRole.pollingUnitAgent: {
      CampaignCapability.viewCommunications,
      CampaignCapability.sendOperationalMessage,
      CampaignCapability.createIncident,
      CampaignCapability.submitFieldReport,
      CampaignCapability.submitElectionResult,
    },
    CampaignRole.fieldReporter: {
      CampaignCapability.viewCommunications,
      CampaignCapability.sendOperationalMessage,
      CampaignCapability.createIncident,
      CampaignCapability.submitFieldReport,
    },
    CampaignRole.readOnlyExecutive: {
      CampaignCapability.viewExecutiveDashboard,
      CampaignCapability.viewElectionIntelligence,
      CampaignCapability.viewHistoricalResults,
      CampaignCapability.viewCampaignTrends,
      CampaignCapability.viewSituationRoom,
      CampaignCapability.viewMediaIntelligence,
      CampaignCapability.viewCommunityIssues,
      CampaignCapability.exportReports,
    },
  };

  static bool allows(CampaignRole role, CampaignCapability capability) =>
      _roleCapabilities[role]?.contains(capability) ?? false;

  static Set<CampaignCapability> capabilitiesFor(CampaignRole role) =>
      Set.unmodifiable(_roleCapabilities[role] ?? const {});

  /// Checks whether a user may operate on a record at [target].
  /// State-scoped users can reach all Benue records. LGA, ward and polling-unit
  /// accounts are restricted to their assigned hierarchy.
  static bool scopeAllows(GeographicScope user, GeographicScope target) {
    if (user.state != target.state) return false;
    if (user.level == GeographyLevel.state) return true;

    if (user.lga != target.lga) return false;
    if (user.level == GeographyLevel.lga) return true;

    if (user.ward != target.ward) return false;
    if (user.level == GeographyLevel.ward) return true;

    return user.pollingUnit == target.pollingUnit;
  }

  static bool may(
    CampaignUser user,
    CampaignCapability capability, {
    GeographicScope? targetScope,
  }) {
    if (!user.isActive || !allows(user.role, capability)) return false;
    if (targetScope == null) return true;
    return scopeAllows(user.scope, targetScope);
  }
}
