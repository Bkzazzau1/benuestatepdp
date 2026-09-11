import 'package:flutter/material.dart';

import 'domain/models.dart';
import 'polished_role_commands.dart';
import 'session.dart';

export 'polished_role_commands.dart';

class RoleCommandRouter extends StatelessWidget {
  const RoleCommandRouter({
    super.key,
    required this.role,
    required this.onOpenModule,
  });

  final CampaignRole role;
  final ValueChanged<AppModule> onOpenModule;

  @override
  Widget build(BuildContext context) => switch (role) {
        CampaignRole.candidate =>
          CandidateCommandView(onOpenModule: onOpenModule),
        CampaignRole.directorGeneral =>
          DirectorGeneralCommandView(onOpenModule: onOpenModule),
        CampaignRole.situationRoomDirector =>
          SituationRoomCommandView(onOpenModule: onOpenModule),
        CampaignRole.stateAdministrator =>
          StateAdministratorCommandView(onOpenModule: onOpenModule),
        CampaignRole.operationsOfficer =>
          OperationsCommandView(onOpenModule: onOpenModule),
        CampaignRole.mediaIntelligenceOfficer =>
          MediaIntelligenceCommandView(onOpenModule: onOpenModule),
        CampaignRole.legalOfficer =>
          LegalCommandView(onOpenModule: onOpenModule),
        CampaignRole.logisticsOfficer =>
          LogisticsCommandView(onOpenModule: onOpenModule),
        CampaignRole.financeOfficer =>
          FinanceCommandView(onOpenModule: onOpenModule),
        CampaignRole.lgaCoordinator =>
          LgaCommandView(onOpenModule: onOpenModule),
        CampaignRole.wardCoordinator =>
          WardCommandView(onOpenModule: onOpenModule),
        CampaignRole.pollingUnitAgent =>
          PollingUnitAgentCommandView(onOpenModule: onOpenModule),
        CampaignRole.fieldReporter =>
          FieldReporterCommandView(onOpenModule: onOpenModule),
        CampaignRole.readOnlyExecutive =>
          ExecutiveViewerCommandView(onOpenModule: onOpenModule),
      };
}
