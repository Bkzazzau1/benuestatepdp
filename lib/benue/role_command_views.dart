import 'package:flutter/material.dart';

import 'director_general_command.dart';
import 'domain/models.dart';
import 'role_command_views_legacy.dart' as legacy;
import 'session.dart';

export 'director_general_command.dart' show PremiumDirectorGeneralCommandView;
export 'role_command_views_legacy.dart'
    hide RoleCommandRouter, DirectorGeneralCommandView;

/// Routes Command Overview to a purpose-built command centre for the
/// authenticated role. The DG now has its own premium statewide command view;
/// other role homes continue through the established role-specific views.
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
          legacy.CandidateCommandView(onOpenModule: onOpenModule),
        CampaignRole.directorGeneral =>
          DirectorGeneralCommandView(onOpenModule: onOpenModule),
        CampaignRole.situationRoomDirector =>
          legacy.SituationRoomCommandView(onOpenModule: onOpenModule),
        CampaignRole.stateAdministrator =>
          legacy.StateAdministratorCommandView(onOpenModule: onOpenModule),
        CampaignRole.operationsOfficer =>
          legacy.OperationsCommandView(onOpenModule: onOpenModule),
        CampaignRole.mediaIntelligenceOfficer =>
          legacy.MediaIntelligenceCommandView(onOpenModule: onOpenModule),
        CampaignRole.legalOfficer =>
          legacy.LegalCommandView(onOpenModule: onOpenModule),
        CampaignRole.logisticsOfficer =>
          legacy.LogisticsCommandView(onOpenModule: onOpenModule),
        CampaignRole.financeOfficer =>
          legacy.FinanceCommandView(onOpenModule: onOpenModule),
        CampaignRole.lgaCoordinator =>
          legacy.LgaCommandView(onOpenModule: onOpenModule),
        CampaignRole.wardCoordinator =>
          legacy.WardCommandView(onOpenModule: onOpenModule),
        CampaignRole.pollingUnitAgent =>
          legacy.PollingUnitAgentCommandView(onOpenModule: onOpenModule),
        CampaignRole.fieldReporter =>
          legacy.FieldReporterCommandView(onOpenModule: onOpenModule),
        CampaignRole.readOnlyExecutive =>
          legacy.ExecutiveViewerCommandView(onOpenModule: onOpenModule),
      };
}

class DirectorGeneralCommandView extends StatelessWidget {
  const DirectorGeneralCommandView({
    super.key,
    required this.onOpenModule,
  });

  final ValueChanged<AppModule> onOpenModule;

  @override
  Widget build(BuildContext context) =>
      PremiumDirectorGeneralCommandView(onOpenModule: onOpenModule);
}
