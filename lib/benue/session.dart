import 'package:flutter/material.dart';

import 'domain/models.dart';

enum AppModule {
  overview,
  benueMap,
  campaignOperations,
  historicalElections,
  electionIntelligence,
  campaignTrends,
  mediaIntelligence,
  communityIssues,
  situationRoom,
  communications,
  discussionForum,
  meetingRoom,
  fieldNetwork,
  logisticsTasks,
  electionDay,
  reportsDocuments,
  dataGovernance,
}

class CampaignSessionController extends ChangeNotifier {
  CampaignRole? _role;
  String _operatorName = '';

  CampaignRole? get role => _role;
  String get operatorName => _operatorName;
  bool get isAuthenticated => _role != null;

  void signIn({required CampaignRole role, required String operatorName}) {
    _role = role;
    _operatorName = operatorName.trim().isEmpty ? roleLabel(role) : operatorName.trim();
    notifyListeners();
  }

  void signOut() {
    _role = null;
    _operatorName = '';
    notifyListeners();
  }
}

class CampaignSession extends InheritedNotifier<CampaignSessionController> {
  const CampaignSession({
    super.key,
    required CampaignSessionController controller,
    required super.child,
  }) : super(notifier: controller);

  static CampaignSessionController of(BuildContext context, {bool listen = true}) {
    if (listen) {
      final value = context.dependOnInheritedWidgetOfExactType<CampaignSession>();
      assert(value != null, 'CampaignSession is missing above this context.');
      return value!.notifier!;
    }
    final element = context.getElementForInheritedWidgetOfExactType<CampaignSession>();
    final value = element?.widget as CampaignSession?;
    assert(value != null, 'CampaignSession is missing above this context.');
    return value!.notifier!;
  }
}

String roleLabel(CampaignRole role) => switch (role) {
      CampaignRole.candidate => 'Candidate / Principal',
      CampaignRole.directorGeneral => 'Director General',
      CampaignRole.situationRoomDirector => 'Situation Room Director',
      CampaignRole.stateAdministrator => 'State Administrator',
      CampaignRole.operationsOfficer => 'Operations Officer',
      CampaignRole.mediaIntelligenceOfficer => 'Media & Intelligence',
      CampaignRole.legalOfficer => 'Legal Officer',
      CampaignRole.logisticsOfficer => 'Logistics Officer',
      CampaignRole.financeOfficer => 'Finance Officer',
      CampaignRole.lgaCoordinator => 'LGA Coordinator',
      CampaignRole.wardCoordinator => 'Ward Coordinator',
      CampaignRole.pollingUnitAgent => 'Polling Unit Agent',
      CampaignRole.fieldReporter => 'Field Reporter',
      CampaignRole.readOnlyExecutive => 'Executive Viewer',
    };

String roleDescription(CampaignRole role) => switch (role) {
      CampaignRole.candidate => 'Executive campaign view, briefings, intelligence and command visibility.',
      CampaignRole.directorGeneral => 'Full campaign command, operations, intelligence and approvals.',
      CampaignRole.situationRoomDirector => 'Live incidents, field reporting, communications and election-day command.',
      CampaignRole.stateAdministrator => 'System administration, access, data governance and statewide records.',
      CampaignRole.operationsOfficer => 'Activities, field teams, tasks, logistics and statewide execution.',
      CampaignRole.mediaIntelligenceOfficer => 'Media monitoring, trends, narrative verification and campaign intelligence.',
      CampaignRole.legalOfficer => 'Incidents, evidence, election-day issues and legal review.',
      CampaignRole.logisticsOfficer => 'Assets, distribution, transport, materials and operational tasks.',
      CampaignRole.financeOfficer => 'Finance operations and executive reporting.',
      CampaignRole.lgaCoordinator => 'LGA command, field teams, incidents, activities and reporting.',
      CampaignRole.wardCoordinator => 'Ward-level coordination and reporting after verified ward import.',
      CampaignRole.pollingUnitAgent => 'Polling-unit check-in, reporting and election-day workflows.',
      CampaignRole.fieldReporter => 'Structured field reports, incidents, evidence and assigned tasks.',
      CampaignRole.readOnlyExecutive => 'Read-only campaign overview, trends, intelligence and reports.',
    };

IconData roleIcon(CampaignRole role) => switch (role) {
      CampaignRole.candidate => Icons.workspace_premium_rounded,
      CampaignRole.directorGeneral => Icons.account_balance_rounded,
      CampaignRole.situationRoomDirector => Icons.radar_rounded,
      CampaignRole.stateAdministrator => Icons.admin_panel_settings_rounded,
      CampaignRole.operationsOfficer => Icons.settings_suggest_rounded,
      CampaignRole.mediaIntelligenceOfficer => Icons.public_rounded,
      CampaignRole.legalOfficer => Icons.gavel_rounded,
      CampaignRole.logisticsOfficer => Icons.local_shipping_rounded,
      CampaignRole.financeOfficer => Icons.account_balance_wallet_rounded,
      CampaignRole.lgaCoordinator => Icons.location_city_rounded,
      CampaignRole.wardCoordinator => Icons.grid_view_rounded,
      CampaignRole.pollingUnitAgent => Icons.how_to_vote_rounded,
      CampaignRole.fieldReporter => Icons.mobile_friendly_rounded,
      CampaignRole.readOnlyExecutive => Icons.visibility_rounded,
    };

const _communityModules = <AppModule>{
  AppModule.discussionForum,
  AppModule.meetingRoom,
};

Set<AppModule> allowedModules(CampaignRole role) {
  const all = <AppModule>{
    AppModule.overview,
    AppModule.benueMap,
    AppModule.campaignOperations,
    AppModule.historicalElections,
    AppModule.electionIntelligence,
    AppModule.campaignTrends,
    AppModule.mediaIntelligence,
    AppModule.communityIssues,
    AppModule.situationRoom,
    AppModule.communications,
    AppModule.discussionForum,
    AppModule.meetingRoom,
    AppModule.fieldNetwork,
    AppModule.logisticsTasks,
    AppModule.electionDay,
    AppModule.reportsDocuments,
    AppModule.dataGovernance,
  };

  final modules = switch (role) {
    CampaignRole.candidate || CampaignRole.directorGeneral || CampaignRole.stateAdministrator => all,
    CampaignRole.situationRoomDirector => <AppModule>{
        AppModule.overview,
        AppModule.benueMap,
        AppModule.electionIntelligence,
        AppModule.campaignTrends,
        AppModule.situationRoom,
        AppModule.communications,
        AppModule.fieldNetwork,
        AppModule.logisticsTasks,
        AppModule.electionDay,
        AppModule.reportsDocuments,
        AppModule.dataGovernance,
      },
    CampaignRole.operationsOfficer => <AppModule>{
        AppModule.overview,
        AppModule.benueMap,
        AppModule.campaignOperations,
        AppModule.communityIssues,
        AppModule.situationRoom,
        AppModule.communications,
        AppModule.fieldNetwork,
        AppModule.logisticsTasks,
        AppModule.electionDay,
        AppModule.reportsDocuments,
      },
    CampaignRole.mediaIntelligenceOfficer => <AppModule>{
        AppModule.overview,
        AppModule.historicalElections,
        AppModule.electionIntelligence,
        AppModule.campaignTrends,
        AppModule.mediaIntelligence,
        AppModule.communityIssues,
        AppModule.communications,
        AppModule.reportsDocuments,
      },
    CampaignRole.legalOfficer => <AppModule>{
        AppModule.overview,
        AppModule.electionIntelligence,
        AppModule.situationRoom,
        AppModule.communications,
        AppModule.electionDay,
        AppModule.reportsDocuments,
        AppModule.dataGovernance,
      },
    CampaignRole.logisticsOfficer => <AppModule>{
        AppModule.overview,
        AppModule.benueMap,
        AppModule.campaignOperations,
        AppModule.situationRoom,
        AppModule.communications,
        AppModule.fieldNetwork,
        AppModule.logisticsTasks,
        AppModule.electionDay,
        AppModule.reportsDocuments,
      },
    CampaignRole.financeOfficer => <AppModule>{
        AppModule.overview,
        AppModule.campaignOperations,
        AppModule.reportsDocuments,
        AppModule.dataGovernance,
      },
    CampaignRole.lgaCoordinator => <AppModule>{
        AppModule.overview,
        AppModule.benueMap,
        AppModule.campaignOperations,
        AppModule.communityIssues,
        AppModule.situationRoom,
        AppModule.communications,
        AppModule.fieldNetwork,
        AppModule.logisticsTasks,
        AppModule.electionDay,
        AppModule.reportsDocuments,
      },
    CampaignRole.wardCoordinator => <AppModule>{
        AppModule.overview,
        AppModule.benueMap,
        AppModule.campaignOperations,
        AppModule.situationRoom,
        AppModule.communications,
        AppModule.fieldNetwork,
        AppModule.logisticsTasks,
        AppModule.electionDay,
      },
    CampaignRole.pollingUnitAgent => <AppModule>{
        AppModule.overview,
        AppModule.communications,
        AppModule.electionDay,
      },
    CampaignRole.fieldReporter => <AppModule>{
        AppModule.overview,
        AppModule.benueMap,
        AppModule.situationRoom,
        AppModule.communications,
        AppModule.fieldNetwork,
      },
    CampaignRole.readOnlyExecutive => <AppModule>{
        AppModule.overview,
        AppModule.benueMap,
        AppModule.historicalElections,
        AppModule.electionIntelligence,
        AppModule.campaignTrends,
        AppModule.mediaIntelligence,
        AppModule.communityIssues,
        AppModule.situationRoom,
        AppModule.reportsDocuments,
      },
  };

  return {...modules, ..._communityModules};
}
