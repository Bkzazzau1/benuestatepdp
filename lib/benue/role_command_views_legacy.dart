import 'package:flutter/material.dart';

import 'app_scope.dart';
import 'campaign_identity.dart';
import 'domain/models.dart';
import 'domain/records_store.dart';
import 'executive_dashboard.dart';
import 'session.dart';
import 'widgets.dart';

/// Routes Command Overview to a purpose-built command centre for the
/// authenticated role. Records stay shared; priorities and controls differ.
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
        CampaignRole.candidate => CandidateCommandView(onOpenModule: onOpenModule),
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
        CampaignRole.legalOfficer => LegalCommandView(onOpenModule: onOpenModule),
        CampaignRole.logisticsOfficer =>
          LogisticsCommandView(onOpenModule: onOpenModule),
        CampaignRole.financeOfficer => FinanceCommandView(onOpenModule: onOpenModule),
        CampaignRole.lgaCoordinator => LgaCommandView(onOpenModule: onOpenModule),
        CampaignRole.wardCoordinator => WardCommandView(onOpenModule: onOpenModule),
        CampaignRole.pollingUnitAgent =>
          PollingUnitAgentCommandView(onOpenModule: onOpenModule),
        CampaignRole.fieldReporter =>
          FieldReporterCommandView(onOpenModule: onOpenModule),
        CampaignRole.readOnlyExecutive =>
          ExecutiveViewerCommandView(onOpenModule: onOpenModule),
      };
}

class CandidateCommandView extends StatelessWidget {
  const CandidateCommandView({super.key, required this.onOpenModule});
  final ValueChanged<AppModule> onOpenModule;

  @override
  Widget build(BuildContext context) => ExecutiveDashboardPage(
        onOpenMap: () => onOpenModule(AppModule.benueMap),
        onOpenSituationRoom: () => onOpenModule(AppModule.situationRoom),
        onOpenCommunications: () => onOpenModule(AppModule.communications),
        onOpenCampaignOperations: () => onOpenModule(AppModule.campaignOperations),
        onOpenReports: () => onOpenModule(AppModule.reportsDocuments),
      );
}

class DirectorGeneralCommandView extends StatelessWidget {
  const DirectorGeneralCommandView({super.key, required this.onOpenModule});
  final ValueChanged<AppModule> onOpenModule;

  @override
  Widget build(BuildContext context) {
    final d = _RoleData.of(context);
    return _StandardRoleCommand(
      eyebrow: 'STATEWIDE CAMPAIGN CONTROL',
      title: 'Director General Command',
      subtitle:
          'Execution, escalation and cross-unit accountability for ${CampaignIdentity.candidateName} campaign operations.',
      icon: Icons.account_balance_rounded,
      accent: pdpGreen,
      metrics: [
        _MetricSpec('Readiness', '${d.summary.averageReadiness.toStringAsFixed(0)}%',
            'Average agent coverage', Icons.speed_rounded),
        _MetricSpec('Open incidents', '${d.summary.openIncidents}',
            'Requires command visibility', Icons.warning_amber_rounded),
        _MetricSpec('Open tasks', '${d.summary.openTasks}',
            'Across active command scope', Icons.task_alt_rounded),
        _MetricSpec('Checked in',
            '${d.summary.checkedInAssignments}/${d.summary.assignments}',
            'Field leadership presence', Icons.how_to_reg_rounded),
      ],
      queueTitle: 'Command priorities',
      queueSubtitle: 'Highest-impact items requiring coordination',
      queue: [
        ...d.incidents.take(3).map((e) => _ListItem(
              e.title,
              '${e.scope.label} • ${_label(e.severity.name)} severity',
              Icons.crisis_alert_outlined,
            )),
        ...d.tasks.take(2).map((e) => _ListItem(
              e.title,
              '${e.scope.label} • ${_label(e.status.name)}',
              Icons.checklist_rounded,
            )),
      ],
      actionTitle: 'DG command shortcuts',
      actions: [
        _QuickSpec('Situation Room', Icons.radar_rounded,
            () => onOpenModule(AppModule.situationRoom)),
        _QuickSpec('Election Intelligence', Icons.analytics_rounded,
            () => onOpenModule(AppModule.electionIntelligence)),
        _QuickSpec('Campaign Operations', Icons.campaign_outlined,
            () => onOpenModule(AppModule.campaignOperations)),
        _QuickSpec('Reports', Icons.description_outlined,
            () => onOpenModule(AppModule.reportsDocuments)),
      ],
      doctrineTitle: 'DG operating doctrine',
      doctrine:
          'See the whole campaign, assign clear ownership, escalate exceptions quickly and measure whether every decision closes a real operational gap.',
    );
  }
}

/// Premium response-first home for the Situation Room Director.
class SituationRoomCommandView extends StatelessWidget {
  const SituationRoomCommandView({super.key, required this.onOpenModule});
  final ValueChanged<AppModule> onOpenModule;

  @override
  Widget build(BuildContext context) {
    final d = _RoleData.of(context);
    final critical = d.incidents
        .where((e) => e.severity == IncidentSeverity.critical)
        .length;
    final high =
        d.incidents.where((e) => e.severity == IncidentSeverity.high).length;
    final newlyReported =
        d.incidents.where((e) => e.status == IncidentStatus.reported).length;
    final communicationReady =
        d.readiness.where((e) => e.communicationReady).length;
    final logisticsReady = d.readiness.where((e) => e.logisticsReady).length;
    final readinessCount = d.readiness.length;

    return ColoredBox(
      color: const Color(0xFFF2F5F3),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 22, 24, 38),
        children: [
          _SituationHero(
            scopeLabel: d.scope.label,
            operatorName: CampaignSession.of(context).operatorName,
            critical: critical,
            openIncidents: d.summary.openIncidents,
          ),
          const SizedBox(height: 16),
          _SituationKpiGrid(
            items: [
              _SituationKpi('Open incidents', '${d.summary.openIncidents}',
                  'Active response queue', Icons.radar_rounded,
                  const Color(0xFFD72638)),
              _SituationKpi('Critical / high', '$critical / $high',
                  'Highest response priority', Icons.priority_high_rounded,
                  const Color(0xFFB91C1C)),
              _SituationKpi('New reports', '$newlyReported',
                  'Awaiting acknowledgement', Icons.fiber_new_rounded,
                  const Color(0xFFD97706)),
              _SituationKpi('Field check-in',
                  '${d.summary.checkedInAssignments}/${d.summary.assignments}',
                  'Leadership presence', Icons.how_to_reg_rounded,
                  const Color(0xFF2563EB)),
              _SituationKpi('Comms ready',
                  readinessCount == 0
                      ? '—'
                      : '$communicationReady/$readinessCount',
                  'Readiness records', Icons.wifi_tethering_rounded,
                  const Color(0xFF0F766E)),
              _SituationKpi('Field reports', '${d.summary.fieldReports}',
                  'Evidence in active scope', Icons.feed_outlined,
                  const Color(0xFF7C3AED)),
            ],
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final incidentBoard = _IncidentCommandBoard(
                incidents: d.incidents,
                onOpen: () => onOpenModule(AppModule.situationRoom),
              );
              final health = _ResponseHealthPanel(
                assignments: d.assignments,
                readiness: d.readiness,
                communicationReady: communicationReady,
                logisticsReady: logisticsReady,
              );
              if (constraints.maxWidth < 1060) {
                return Column(children: [
                  incidentBoard,
                  const SizedBox(height: 14),
                  health,
                ]);
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 15, child: incidentBoard),
                  const SizedBox(width: 14),
                  Expanded(flex: 8, child: health),
                ],
              );
            },
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final evidence = _FieldEvidenceFeed(reports: d.reports);
              final hotspots = _HotspotPanel(incidents: d.incidents);
              if (constraints.maxWidth < 1060) {
                return Column(children: [
                  evidence,
                  const SizedBox(height: 14),
                  hotspots,
                ]);
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 12, child: evidence),
                  const SizedBox(width: 14),
                  Expanded(flex: 9, child: hotspots),
                ],
              );
            },
          ),
          const SizedBox(height: 16),
          _SituationActions(
            actions: [
              _QuickSpec('Incident Command', Icons.radar_rounded,
                  () => onOpenModule(AppModule.situationRoom)),
              _QuickSpec('Secure Communications', Icons.forum_outlined,
                  () => onOpenModule(AppModule.communications)),
              _QuickSpec('Field Network', Icons.hub_outlined,
                  () => onOpenModule(AppModule.fieldNetwork)),
              _QuickSpec('Election Day', Icons.how_to_vote_outlined,
                  () => onOpenModule(AppModule.electionDay)),
              _QuickSpec('Logistics & Tasks', Icons.inventory_2_outlined,
                  () => onOpenModule(AppModule.logisticsTasks)),
              _QuickSpec('Benue Map', Icons.map_outlined,
                  () => onOpenModule(AppModule.benueMap)),
            ],
          ),
          const SizedBox(height: 16),
          const _Doctrine(
            title: 'Situation Room response doctrine',
            text:
                'Detect → acknowledge → assign → communicate → preserve evidence → resolve → close. Critical incidents should never exist without accountable ownership, a communication path and an auditable closure state.',
          ),
        ],
      ),
    );
  }
}

class StateAdministratorCommandView extends StatelessWidget {
  const StateAdministratorCommandView({super.key, required this.onOpenModule});
  final ValueChanged<AppModule> onOpenModule;

  @override
  Widget build(BuildContext context) {
    final d = _RoleData.of(context);
    return _StandardRoleCommand(
      eyebrow: 'PLATFORM ADMINISTRATION',
      title: 'State Administrator Console',
      subtitle: 'System records, access posture, provenance and audit visibility.',
      icon: Icons.admin_panel_settings_rounded,
      accent: const Color(0xFF4054B2),
      metrics: [
        _MetricSpec('Users', '${d.records.users.length}', 'Campaign identities',
            Icons.people_alt_outlined),
        _MetricSpec('Assignments', '${d.records.assignments.length}',
            'Role assignments', Icons.badge_outlined),
        _MetricSpec('Audit events', '${d.records.auditEvents.length}',
            'Recorded mutations', Icons.receipt_long_outlined),
        const _MetricSpec('LGAs represented', '23', 'Base geography catalog',
            Icons.location_city_outlined),
      ],
      queueTitle: 'Recent audit activity',
      queueSubtitle: 'Newest shared-record mutations',
      queue: d.records.auditEvents.reversed
          .take(6)
          .map((e) => _ListItem(_label(e.action),
              '${e.entityType} • ${e.entityId} • ${e.actorId}',
              Icons.history_toggle_off_rounded))
          .toList(),
      actionTitle: 'Administration controls',
      actions: [
        _QuickSpec('Data & Governance', Icons.policy_outlined,
            () => onOpenModule(AppModule.dataGovernance)),
        _QuickSpec('Field Network', Icons.manage_accounts_outlined,
            () => onOpenModule(AppModule.fieldNetwork)),
        _QuickSpec('Benue Map', Icons.map_outlined,
            () => onOpenModule(AppModule.benueMap)),
        _QuickSpec('Reports', Icons.description_outlined,
            () => onOpenModule(AppModule.reportsDocuments)),
      ],
      doctrineTitle: 'Administration boundary',
      doctrine:
          'Flutter role visibility is UX only. Production authorization and immutable audit must be enforced server-side.',
    );
  }
}

class OperationsCommandView extends StatelessWidget {
  const OperationsCommandView({super.key, required this.onOpenModule});
  final ValueChanged<AppModule> onOpenModule;

  @override
  Widget build(BuildContext context) {
    final d = _RoleData.of(context);
    return _StandardRoleCommand(
      eyebrow: 'CAMPAIGN EXECUTION',
      title: 'Operations Command',
      subtitle: 'Activities, personnel, readiness, tasks and execution gaps.',
      icon: Icons.settings_suggest_rounded,
      accent: const Color(0xFF0F766E),
      metrics: [
        _MetricSpec('Assignments', '${d.summary.assignments}', 'Active scope',
            Icons.groups_2_outlined),
        _MetricSpec('Checked in', '${d.summary.checkedInAssignments}',
            'Personnel present', Icons.login_rounded),
        _MetricSpec('Activities', '${d.activities.length}', 'Calendar records',
            Icons.event_available_outlined),
        _MetricSpec('Readiness', '${d.summary.averageReadiness.toStringAsFixed(0)}%',
            'Agent coverage', Icons.speed_outlined),
      ],
      queueTitle: 'Execution queue',
      queueSubtitle: 'Activities and tasks requiring follow-through',
      queue: [
        ...d.activities.take(3).map((e) => _ListItem(e.title,
            '${e.scope.label} • ${_label(e.status.name)}',
            Icons.event_note_outlined)),
        ...d.tasks.take(3).map((e) => _ListItem(e.title,
            '${e.id} • ${_label(e.status.name)}', Icons.task_outlined)),
      ],
      actionTitle: 'Operations shortcuts',
      actions: [
        _QuickSpec('Campaign Operations', Icons.campaign_outlined,
            () => onOpenModule(AppModule.campaignOperations)),
        _QuickSpec('Field Network', Icons.hub_outlined,
            () => onOpenModule(AppModule.fieldNetwork)),
        _QuickSpec('Logistics & Tasks', Icons.inventory_2_outlined,
            () => onOpenModule(AppModule.logisticsTasks)),
        _QuickSpec('Situation Room', Icons.radar_rounded,
            () => onOpenModule(AppModule.situationRoom)),
      ],
      doctrineTitle: 'Operations focus',
      doctrine:
          'Turn strategy into visible execution: owner, geography, due date, blocker and measurable outcome.',
    );
  }
}

class MediaIntelligenceCommandView extends StatelessWidget {
  const MediaIntelligenceCommandView({super.key, required this.onOpenModule});
  final ValueChanged<AppModule> onOpenModule;

  @override
  Widget build(BuildContext context) {
    final d = _RoleData.of(context);
    return _StandardRoleCommand(
      eyebrow: 'PUBLIC NARRATIVE & INTELLIGENCE',
      title: 'Media & Intelligence Command',
      subtitle:
          'Public narratives, claim verification, trends and election intelligence.',
      icon: Icons.public_rounded,
      accent: const Color(0xFF7C3AED),
      metrics: [
        const _MetricSpec('Media feeds', 'Not connected',
            'Integration pending', Icons.wifi_tethering_rounded),
        const _MetricSpec('Verification desk', 'Ready', 'Human review required',
            Icons.fact_check_outlined),
        _MetricSpec('Field reports', '${d.summary.fieldReports}',
            'Evidence inputs', Icons.feed_outlined),
        const _MetricSpec('Individual profiling', 'Disabled',
            'Aggregate/public intelligence only', Icons.shield_outlined),
      ],
      queueTitle: 'Intelligence workflow',
      queueSubtitle: 'Source-aware public narrative handling',
      queue: const [
        _ListItem('Detect public narrative', 'Capture public source and timestamp',
            Icons.travel_explore_outlined),
        _ListItem('Verify claim', 'Separate fact, interpretation and uncertainty',
            Icons.fact_check_outlined),
        _ListItem('Assess geography', 'Use aggregate geography only',
            Icons.analytics_outlined),
        _ListItem('Prepare reviewed response', 'Human review before publication',
            Icons.rate_review_outlined),
      ],
      actionTitle: 'Intelligence shortcuts',
      actions: [
        _QuickSpec('Media Intelligence', Icons.public_rounded,
            () => onOpenModule(AppModule.mediaIntelligence)),
        _QuickSpec('Election Intelligence', Icons.psychology_alt_outlined,
            () => onOpenModule(AppModule.electionIntelligence)),
        _QuickSpec('Campaign Trends', Icons.trending_up_rounded,
            () => onOpenModule(AppModule.campaignTrends)),
        _QuickSpec('Historical Elections', Icons.history_rounded,
            () => onOpenModule(AppModule.historicalElections)),
      ],
      doctrineTitle: 'Intelligence standard',
      doctrine:
          'Keep verified fact, interpretation and hypothesis visibly separate; lower confidence when evidence is stale or partial.',
    );
  }
}

class LegalCommandView extends StatelessWidget {
  const LegalCommandView({super.key, required this.onOpenModule});
  final ValueChanged<AppModule> onOpenModule;

  @override
  Widget build(BuildContext context) {
    final d = _RoleData.of(context);
    return _StandardRoleCommand(
      eyebrow: 'LEGAL & EVIDENCE CONTROL',
      title: 'Legal Command',
      subtitle: 'Incident review, evidence integrity and election legal readiness.',
      icon: Icons.gavel_rounded,
      accent: const Color(0xFF8A5B00),
      metrics: [
        _MetricSpec('Open incidents', '${d.summary.openIncidents}', 'Review queue',
            Icons.report_problem_outlined),
        _MetricSpec('Field reports', '${d.summary.fieldReports}', 'Evidence sources',
            Icons.description_outlined),
        _MetricSpec('Audit events', '${d.records.auditEvents.length}', 'Record history',
            Icons.history_outlined),
        const _MetricSpec('Evidence vault', 'Prototype', 'Backend storage pending',
            Icons.lock_outline_rounded),
      ],
      queueTitle: 'Legal review queue',
      queueSubtitle: 'Operational incidents needing evidence preservation',
      queue: d.incidents
          .take(6)
          .map((e) => _ListItem(e.title,
              '${e.id} • ${e.scope.label} • ${_label(e.severity.name)}',
              Icons.gavel_outlined))
          .toList(),
      actionTitle: 'Legal shortcuts',
      actions: [
        _QuickSpec('Situation Room', Icons.radar_rounded,
            () => onOpenModule(AppModule.situationRoom)),
        _QuickSpec('Election Day', Icons.how_to_vote_outlined,
            () => onOpenModule(AppModule.electionDay)),
        _QuickSpec('Data & Governance', Icons.policy_outlined,
            () => onOpenModule(AppModule.dataGovernance)),
        _QuickSpec('Reports', Icons.description_outlined,
            () => onOpenModule(AppModule.reportsDocuments)),
      ],
      doctrineTitle: 'Evidence doctrine',
      doctrine:
          'Preserve original source, timestamp, geography, submitter and mutation history. Campaign result copies remain unofficial until INEC.',
    );
  }
}

class LogisticsCommandView extends StatelessWidget {
  const LogisticsCommandView({super.key, required this.onOpenModule});
  final ValueChanged<AppModule> onOpenModule;

  @override
  Widget build(BuildContext context) {
    final d = _RoleData.of(context);
    return _StandardRoleCommand(
      eyebrow: 'ASSETS • MATERIALS • MOVEMENT',
      title: 'Logistics Command',
      subtitle: 'Asset readiness, transport, materials and logistics tasks.',
      icon: Icons.local_shipping_rounded,
      accent: const Color(0xFFD97706),
      metrics: [
        _MetricSpec('Assets', '${d.summary.assets}', 'Registered assets',
            Icons.inventory_2_outlined),
        _MetricSpec('Ready assets', '${d.summary.readyAssets}', 'Operationally ready',
            Icons.check_circle_outline_rounded),
        _MetricSpec('Open tasks', '${d.summary.openTasks}', 'Work queue',
            Icons.checklist_rounded),
        _MetricSpec('Incidents', '${d.summary.openIncidents}', 'Movement blockers',
            Icons.warning_amber_rounded),
      ],
      queueTitle: 'Asset readiness',
      queueSubtitle: 'Current assets in the active scope',
      queue: d.assets
          .take(6)
          .map((e) => _ListItem(e.name,
              '${e.id} • ${e.scope.label} • ${_label(e.status.name)}',
              Icons.local_shipping_outlined))
          .toList(),
      actionTitle: 'Logistics shortcuts',
      actions: [
        _QuickSpec('Logistics & Tasks', Icons.inventory_2_outlined,
            () => onOpenModule(AppModule.logisticsTasks)),
        _QuickSpec('Campaign Operations', Icons.campaign_outlined,
            () => onOpenModule(AppModule.campaignOperations)),
        _QuickSpec('Benue Map', Icons.map_outlined,
            () => onOpenModule(AppModule.benueMap)),
        _QuickSpec('Election Day', Icons.how_to_vote_outlined,
            () => onOpenModule(AppModule.electionDay)),
      ],
      doctrineTitle: 'Logistics focus',
      doctrine:
          'Every asset needs a stable ID, custodian, geography, condition and current status.',
    );
  }
}

class FinanceCommandView extends StatelessWidget {
  const FinanceCommandView({super.key, required this.onOpenModule});
  final ValueChanged<AppModule> onOpenModule;

  @override
  Widget build(BuildContext context) {
    final d = _RoleData.of(context);
    return _StandardRoleCommand(
      eyebrow: 'FINANCE GOVERNANCE',
      title: 'Finance Command',
      subtitle: 'Budget, approvals, expenditure controls and audit integration.',
      icon: Icons.account_balance_wallet_rounded,
      accent: const Color(0xFF166534),
      metrics: [
        const _MetricSpec('Budget ledger', 'Not connected',
            'No financial amounts fabricated', Icons.account_balance_outlined),
        const _MetricSpec('Approval queue', 'Backend required', 'Workflow pending',
            Icons.approval_outlined),
        _MetricSpec('Audit events', '${d.records.auditEvents.length}',
            'Operational audit', Icons.receipt_long_outlined),
        const _MetricSpec('Expense evidence', 'Pending', 'Document workflow pending',
            Icons.attach_file_rounded),
      ],
      queueTitle: 'Finance module readiness',
      queueSubtitle: 'Dedicated financial domain model still required',
      queue: const [
        _ListItem('Budget control', 'Budget lines, envelopes and owner units',
            Icons.pie_chart_outline_rounded),
        _ListItem('Expense approvals', 'Request → review → authorization → evidence',
            Icons.approval_outlined),
        _ListItem('Reconciliation', 'Payment evidence and vendor linkage',
            Icons.balance_rounded),
        _ListItem('Executive reporting', 'Aggregate spend with appropriate access',
            Icons.summarize_outlined),
      ],
      actionTitle: 'Finance shortcuts',
      actions: [
        _QuickSpec('Campaign Operations', Icons.campaign_outlined,
            () => onOpenModule(AppModule.campaignOperations)),
        _QuickSpec('Reports', Icons.description_outlined,
            () => onOpenModule(AppModule.reportsDocuments)),
        _QuickSpec('Data & Governance', Icons.policy_outlined,
            () => onOpenModule(AppModule.dataGovernance)),
      ],
      doctrineTitle: 'Finance integrity rule',
      doctrine:
          'Until verified finance records exist, show missing data rather than demonstration naira amounts.',
    );
  }
}

class LgaCommandView extends StatelessWidget {
  const LgaCommandView({super.key, required this.onOpenModule});
  final ValueChanged<AppModule> onOpenModule;

  @override
  Widget build(BuildContext context) {
    final d = _RoleData.of(context);
    final selected = d.scope.lgaName != null;
    return _StandardRoleCommand(
      eyebrow: 'LOCAL GOVERNMENT COMMAND',
      title: selected ? '${d.scope.lgaName} LGA Command' : 'LGA Coordinator Command',
      subtitle: selected
          ? 'Local operations, incidents and election readiness for ${d.scope.lgaName}.'
          : 'Select an LGA to activate the local command view.',
      icon: Icons.location_city_rounded,
      accent: const Color(0xFF2563EB),
      metrics: [
        _MetricSpec('Assignments', '${d.summary.assignments}', 'Active LGA scope',
            Icons.groups_2_outlined),
        _MetricSpec('Checked in', '${d.summary.checkedInAssignments}', 'Field presence',
            Icons.how_to_reg_outlined),
        _MetricSpec('Incidents', '${d.summary.openIncidents}', 'Local queue',
            Icons.warning_amber_outlined),
        _MetricSpec('Readiness', '${d.summary.averageReadiness.toStringAsFixed(0)}%',
            'Agent coverage', Icons.speed_outlined),
      ],
      queueTitle: 'LGA operational queue',
      queueSubtitle: selected
          ? 'Records constrained to the selected LGA'
          : 'Select an LGA from Benue Map first',
      queue: selected
          ? [
              ...d.incidents.take(3).map((e) => _ListItem(e.title,
                  '${e.id} • ${_label(e.status.name)}',
                  Icons.report_problem_outlined)),
              ...d.tasks.take(3).map((e) => _ListItem(e.title,
                  '${e.id} • ${_label(e.status.name)}', Icons.task_outlined)),
            ]
          : const [
              _ListItem('LGA not selected', 'Open Benue Map and choose the assigned LGA',
                  Icons.location_searching_rounded),
            ],
      actionTitle: 'LGA shortcuts',
      actions: [
        _QuickSpec('Benue Map', Icons.map_outlined,
            () => onOpenModule(AppModule.benueMap)),
        _QuickSpec('Field Network', Icons.hub_outlined,
            () => onOpenModule(AppModule.fieldNetwork)),
        _QuickSpec('Situation Room', Icons.radar_rounded,
            () => onOpenModule(AppModule.situationRoom)),
        _QuickSpec('Election Day', Icons.how_to_vote_outlined,
            () => onOpenModule(AppModule.electionDay)),
      ],
      doctrineTitle: 'LGA responsibility',
      doctrine:
          'Coordinate local teams, maintain geographic discipline and escalate exceptions to state command.',
    );
  }
}

class WardCommandView extends StatelessWidget {
  const WardCommandView({super.key, required this.onOpenModule});
  final ValueChanged<AppModule> onOpenModule;

  @override
  Widget build(BuildContext context) {
    final d = _RoleData.of(context);
    final ward = d.scope.wardName;
    return _StandardRoleCommand(
      eyebrow: 'WARD COORDINATION',
      title: ward == null ? 'Ward Coordinator Command' : '$ward Ward Command',
      subtitle: ward == null
          ? 'Verified ward geography has not yet been assigned.'
          : 'Ward team coordination, incidents and election readiness.',
      icon: Icons.grid_view_rounded,
      accent: const Color(0xFF0E7490),
      metrics: [
        _MetricSpec('LGA assignments', '${d.summary.assignments}', 'Context only',
            Icons.groups_outlined),
        _MetricSpec('LGA incidents', '${d.summary.openIncidents}', 'Escalation context',
            Icons.warning_amber_outlined),
        const _MetricSpec('Ward roster', 'Locked', 'Verified ward import required',
            Icons.lock_outline_rounded),
        const _MetricSpec('PU coverage', 'Locked', 'Verified PU import required',
            Icons.how_to_vote_outlined),
      ],
      queueTitle: 'Ward command readiness',
      queueSubtitle: 'Unlocks after verified geography import',
      queue: const [
        _ListItem('Ward team roster', 'Coordinator, reporters and PU agents',
            Icons.group_outlined),
        _ListItem('Ward incident board', 'Only geography-tagged local incidents',
            Icons.report_problem_outlined),
        _ListItem('Polling-unit readiness', 'Agent, comms and logistics coverage',
            Icons.how_to_vote_outlined),
        _ListItem('Ward field reports', 'Structured evidence to LGA command',
            Icons.feed_outlined),
      ],
      actionTitle: 'Ward shortcuts',
      actions: [
        _QuickSpec('Benue Map', Icons.map_outlined,
            () => onOpenModule(AppModule.benueMap)),
        _QuickSpec('Field Network', Icons.hub_outlined,
            () => onOpenModule(AppModule.fieldNetwork)),
        _QuickSpec('Communications', Icons.forum_outlined,
            () => onOpenModule(AppModule.communications)),
        _QuickSpec('Election Day', Icons.how_to_vote_outlined,
            () => onOpenModule(AppModule.electionDay)),
      ],
      doctrineTitle: 'Ward data boundary',
      doctrine:
          'Do not manufacture ward or polling-unit data. Activate this level only from verified geography-tagged records.',
    );
  }
}

class PollingUnitAgentCommandView extends StatelessWidget {
  const PollingUnitAgentCommandView({super.key, required this.onOpenModule});
  final ValueChanged<AppModule> onOpenModule;

  @override
  Widget build(BuildContext context) {
    final d = _RoleData.of(context);
    final pu = d.scope.pollingUnitName;
    return _StandardRoleCommand(
      eyebrow: 'ELECTION-DAY FIELD CONSOLE',
      title: pu == null ? 'Polling Unit Agent Console' : '$pu Agent Console',
      subtitle: pu == null
          ? 'Verified polling-unit assignment required before local workflows activate.'
          : 'Check-in, incident reporting, communications and unofficial campaign result capture.',
      icon: Icons.how_to_vote_rounded,
      accent: const Color(0xFFB91C1C),
      metrics: const [
        _MetricSpec('Assignment', 'Awaiting verified PU', 'No fabricated PU identity',
            Icons.place_outlined),
        _MetricSpec('Check-in', 'Pending assignment', 'Election-day workflow',
            Icons.verified_user_outlined),
        _MetricSpec('Result capture', 'Unofficial', 'Campaign copy until INEC',
            Icons.ballot_outlined),
        _MetricSpec('Escalation', 'Available', 'Comms + election-day modules',
            Icons.sos_outlined),
      ],
      queueTitle: 'Agent election-day sequence',
      queueSubtitle: 'A deliberately simple field workflow',
      queue: const [
        _ListItem('1. Verify assignment & check in', 'Confirm correct polling unit',
            Icons.login_rounded),
        _ListItem('2. Report incident immediately', 'Security, materials or process issue',
            Icons.report_problem_outlined),
        _ListItem('3. Preserve result evidence', 'Capture time and PU identity',
            Icons.document_scanner_outlined),
        _ListItem('4. Submit campaign result copy', 'Always labelled unofficial',
            Icons.upload_file_outlined),
      ],
      actionTitle: 'Agent shortcuts',
      actions: [
        _QuickSpec('Communications', Icons.forum_outlined,
            () => onOpenModule(AppModule.communications)),
        _QuickSpec('Election Day', Icons.how_to_vote_outlined,
            () => onOpenModule(AppModule.electionDay)),
      ],
      doctrineTitle: 'Agent safety rule',
      doctrine:
          'Keep the field interface minimal under pressure: identity, check-in, incident, evidence, communications and result submission.',
    );
  }
}

class FieldReporterCommandView extends StatelessWidget {
  const FieldReporterCommandView({super.key, required this.onOpenModule});
  final ValueChanged<AppModule> onOpenModule;

  @override
  Widget build(BuildContext context) {
    final d = _RoleData.of(context);
    return _StandardRoleCommand(
      eyebrow: 'FIELD EVIDENCE CAPTURE',
      title: 'Field Reporter Console',
      subtitle: 'Fast structured reporting, incident escalation and secure communication.',
      icon: Icons.mobile_friendly_rounded,
      accent: const Color(0xFF0284C7),
      metrics: [
        _MetricSpec('Field reports', '${d.summary.fieldReports}', 'Active scope',
            Icons.feed_outlined),
        _MetricSpec('Open incidents', '${d.summary.openIncidents}', 'Escalation context',
            Icons.warning_amber_outlined),
        _MetricSpec('Assignments', '${d.summary.assignments}', 'Field network context',
            Icons.badge_outlined),
        _MetricSpec('Scope', d.scope.shortLabel, 'Reporting geography',
            Icons.location_on_outlined),
      ],
      queueTitle: 'Recent field evidence',
      queueSubtitle: 'Latest reports in the shared record set',
      queue: d.reports
          .take(6)
          .map((e) => _ListItem(e.category,
              '${e.id} • ${e.scope.label} • ${_label(e.status.name)}',
              Icons.feed_outlined))
          .toList(),
      actionTitle: 'Reporter shortcuts',
      actions: [
        _QuickSpec('Situation Room', Icons.radar_rounded,
            () => onOpenModule(AppModule.situationRoom)),
        _QuickSpec('Communications', Icons.forum_outlined,
            () => onOpenModule(AppModule.communications)),
        _QuickSpec('Field Network', Icons.hub_outlined,
            () => onOpenModule(AppModule.fieldNetwork)),
        _QuickSpec('Benue Map', Icons.map_outlined,
            () => onOpenModule(AppModule.benueMap)),
      ],
      doctrineTitle: 'Reporting standard',
      doctrine:
          'Report observable facts first, attach provenance and escalate urgent incidents without waiting for a long narrative.',
    );
  }
}

class ExecutiveViewerCommandView extends StatelessWidget {
  const ExecutiveViewerCommandView({super.key, required this.onOpenModule});
  final ValueChanged<AppModule> onOpenModule;

  @override
  Widget build(BuildContext context) {
    final d = _RoleData.of(context);
    return _StandardRoleCommand(
      eyebrow: 'READ-ONLY EXECUTIVE BRIEF',
      title: 'Executive Viewer',
      subtitle: 'Concise read-only campaign health, intelligence and incident visibility.',
      icon: Icons.visibility_rounded,
      accent: const Color(0xFF475569),
      metrics: [
        _MetricSpec('Readiness', '${d.summary.averageReadiness.toStringAsFixed(0)}%',
            'Coverage indicator', Icons.speed_outlined),
        _MetricSpec('Incidents', '${d.summary.openIncidents}', 'Open items',
            Icons.warning_amber_outlined),
        _MetricSpec('Tasks', '${d.summary.openTasks}', 'Execution queue',
            Icons.task_outlined),
        _MetricSpec('Reports', '${d.summary.fieldReports}', 'Field evidence',
            Icons.description_outlined),
      ],
      queueTitle: 'Executive watchlist',
      queueSubtitle: 'Highest current operational relevance',
      queue: d.incidents
          .take(5)
          .map((e) => _ListItem(e.title,
              '${e.scope.label} • ${_label(e.severity.name)}',
              Icons.visibility_outlined))
          .toList(),
      actionTitle: 'Read-only navigation',
      actions: [
        _QuickSpec('Election Intelligence', Icons.analytics_outlined,
            () => onOpenModule(AppModule.electionIntelligence)),
        _QuickSpec('Historical Elections', Icons.history_rounded,
            () => onOpenModule(AppModule.historicalElections)),
        _QuickSpec('Campaign Trends', Icons.trending_up_rounded,
            () => onOpenModule(AppModule.campaignTrends)),
        _QuickSpec('Reports', Icons.description_outlined,
            () => onOpenModule(AppModule.reportsDocuments)),
      ],
      doctrineTitle: 'Viewer boundary',
      doctrine:
          'This role is observational and should not expose mutation controls or edit privileges.',
    );
  }
}

class _RoleData {
  const _RoleData({
    required this.records,
    required this.scope,
    required this.summary,
    required this.incidents,
    required this.tasks,
    required this.activities,
    required this.assets,
    required this.reports,
    required this.assignments,
    required this.readiness,
  });

  final CampaignRecordsController records;
  final CampaignScopeController scope;
  final CampaignRecordsSummary summary;
  final List<CampaignIncident> incidents;
  final List<CampaignTask> tasks;
  final List<CampaignActivity> activities;
  final List<CampaignAsset> assets;
  final List<FieldReport> reports;
  final List<FieldAssignment> assignments;
  final List<ElectionReadinessRecord> readiness;

  static _RoleData of(BuildContext context) {
    final records = CampaignRecords.of(context);
    final scope = CampaignScope.of(context);
    final lgaId = scope.lgaId;
    final incidents = records.incidentsFor(lgaId).toList()
      ..sort((a, b) {
        final severity = _severityRank(b.severity).compareTo(_severityRank(a.severity));
        if (severity != 0) return severity;
        return b.reportedAt.compareTo(a.reportedAt);
      });
    final reports = records.reportsFor(lgaId).toList()
      ..sort((a, b) => b.reportedAt.compareTo(a.reportedAt));
    return _RoleData(
      records: records,
      scope: scope,
      summary: records.summaryFor(lgaId),
      incidents: incidents,
      tasks: records.tasksFor(lgaId),
      activities: records.activitiesFor(lgaId),
      assets: records.assetsFor(lgaId),
      reports: reports,
      assignments: records.assignmentsFor(lgaId),
      readiness: records.readinessFor(lgaId),
    );
  }
}

int _severityRank(IncidentSeverity severity) => switch (severity) {
      IncidentSeverity.critical => 5,
      IncidentSeverity.high => 4,
      IncidentSeverity.medium => 3,
      IncidentSeverity.low => 2,
      IncidentSeverity.info => 1,
    };

Color _severityColor(IncidentSeverity severity) => switch (severity) {
      IncidentSeverity.critical => const Color(0xFFB91C1C),
      IncidentSeverity.high => const Color(0xFFDC2626),
      IncidentSeverity.medium => const Color(0xFFD97706),
      IncidentSeverity.low => const Color(0xFF2563EB),
      IncidentSeverity.info => const Color(0xFF64748B),
    };

class _SituationHero extends StatelessWidget {
  const _SituationHero({
    required this.scopeLabel,
    required this.operatorName,
    required this.critical,
    required this.openIncidents,
  });

  final String scopeLabel;
  final String operatorName;
  final int critical;
  final int openIncidents;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(26),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: const LinearGradient(
            colors: [Color(0xFF160B0D), Color(0xFF4B1118), Color(0xFF971C2A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: const [
            BoxShadow(color: Color(0x332B0B10), blurRadius: 34, offset: Offset(0, 14)),
          ],
        ),
        child: LayoutBuilder(builder: (context, c) {
          final compact = c.maxWidth < 860;
          final copy = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(spacing: 8, runSpacing: 8, children: const [
                _DarkBadge(Icons.radar_rounded, 'LIVE OPERATIONS'),
                _DarkBadge(Icons.shield_outlined, 'SOURCE-AWARE'),
                _DarkBadge(Icons.sync_problem_rounded, 'REALTIME BACKEND PENDING'),
              ]),
              const SizedBox(height: 18),
              Text('Situation Room Command',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: compact ? 30 : 40,
                    height: 1.0,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -.8,
                  )),
              const SizedBox(height: 10),
              const Text(
                'Detect, verify, escalate and close operational incidents with one shared response picture across field teams, communications, logistics and election-day command.',
                style: TextStyle(color: Colors.white70, height: 1.5, fontWeight: FontWeight.w600),
              ),
            ],
          );
          final status = Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .08),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withValues(alpha: .13)),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(operatorName,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
              const SizedBox(height: 3),
              Text(scopeLabel,
                  style: const TextStyle(color: Colors.white60, fontSize: 11, fontWeight: FontWeight.w700)),
              const SizedBox(height: 14),
              Row(mainAxisSize: MainAxisSize.min, children: [
                _HeroNumber('$openIncidents', 'OPEN'),
                const SizedBox(width: 22),
                _HeroNumber('$critical', 'CRITICAL'),
              ]),
            ]),
          );
          if (compact) {
            return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              copy,
              const SizedBox(height: 18),
              status,
            ]);
          }
          return Row(children: [
            Expanded(flex: 14, child: copy),
            const SizedBox(width: 24),
            status,
          ]);
        }),
      );
}

class _DarkBadge extends StatelessWidget {
  const _DarkBadge(this.icon, this.label);
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: .08),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: Colors.white.withValues(alpha: .12)),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 13, color: Colors.white70),
          const SizedBox(width: 6),
          Text(label,
              style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: .5)),
        ]),
      );
}

class _HeroNumber extends StatelessWidget {
  const _HeroNumber(this.value, this.label);
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(value,
            style: const TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w900)),
        Text(label,
            style: const TextStyle(color: Colors.white54, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 1.0)),
      ]);
}

class _SituationKpi {
  const _SituationKpi(this.label, this.value, this.detail, this.icon, this.color);
  final String label;
  final String value;
  final String detail;
  final IconData icon;
  final Color color;
}

class _SituationKpiGrid extends StatelessWidget {
  const _SituationKpiGrid({required this.items});
  final List<_SituationKpi> items;

  @override
  Widget build(BuildContext context) => LayoutBuilder(builder: (context, c) {
        final cols = c.maxWidth >= 1200 ? 6 : c.maxWidth >= 780 ? 3 : c.maxWidth >= 500 ? 2 : 1;
        const gap = 11.0;
        final width = (c.maxWidth - gap * (cols - 1)) / cols;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: items.map((item) => SizedBox(
            width: width,
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFE3E9E4)),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: item.color.withValues(alpha: .09),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(item.icon, color: item.color, size: 19),
                ),
                const SizedBox(height: 12),
                Text(item.value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: ink, fontSize: 20, fontWeight: FontWeight.w900)),
                const SizedBox(height: 2),
                Text(item.label,
                    style: const TextStyle(color: ink, fontSize: 10.5, fontWeight: FontWeight.w900)),
                const SizedBox(height: 3),
                Text(item.detail,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: muted, fontSize: 9.5, height: 1.25)),
              ]),
            ),
          )).toList(),
        );
      });
}

class _IncidentCommandBoard extends StatelessWidget {
  const _IncidentCommandBoard({required this.incidents, required this.onOpen});
  final List<CampaignIncident> incidents;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) => SectionCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Incident command board',
                  style: TextStyle(color: ink, fontSize: 17, fontWeight: FontWeight.w900)),
              SizedBox(height: 3),
              Text('Severity-first operational queue from shared campaign records',
                  style: TextStyle(color: muted, fontSize: 10.5)),
            ])),
            TextButton.icon(onPressed: onOpen, icon: const Icon(Icons.open_in_new_rounded, size: 16),
                label: const Text('Open full room')),
          ]),
          const SizedBox(height: 13),
          if (incidents.isEmpty)
            const _EmptyState('No active incidents in this scope.')
          else
            ...incidents.take(7).map((incident) => _IncidentRow(incident: incident)),
        ]),
      );
}

class _IncidentRow extends StatelessWidget {
  const _IncidentRow({required this.incident});
  final CampaignIncident incident;

  @override
  Widget build(BuildContext context) {
    final color = _severityColor(incident.severity);
    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFBFA),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE6EBE7)),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: 6,
          height: 58,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(99)),
        ),
        const SizedBox(width: 11),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Wrap(spacing: 7, runSpacing: 5, crossAxisAlignment: WrapCrossAlignment.center, children: [
            Text(incident.title,
                style: const TextStyle(color: ink, fontSize: 11.5, fontWeight: FontWeight.w900)),
            _MiniPill(_label(incident.severity.name).toUpperCase(), color),
            _MiniPill(_label(incident.status.name).toUpperCase(), const Color(0xFF475569)),
          ]),
          const SizedBox(height: 5),
          Text('${incident.id} • ${incident.scope.label}',
              style: const TextStyle(color: muted, fontSize: 9.5, fontWeight: FontWeight.w700)),
          if (incident.assignedTeam != null) ...[
            const SizedBox(height: 4),
            Text('Owner: ${incident.assignedTeam}',
                style: const TextStyle(color: muted, fontSize: 9.5)),
          ],
        ])),
      ]),
    );
  }
}

class _MiniPill extends StatelessWidget {
  const _MiniPill(this.text, this.color);
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
        decoration: BoxDecoration(color: color.withValues(alpha: .09), borderRadius: BorderRadius.circular(999)),
        child: Text(text,
            style: TextStyle(color: color, fontSize: 8.5, fontWeight: FontWeight.w900, letterSpacing: .3)),
      );
}

class _ResponseHealthPanel extends StatelessWidget {
  const _ResponseHealthPanel({
    required this.assignments,
    required this.readiness,
    required this.communicationReady,
    required this.logisticsReady,
  });

  final List<FieldAssignment> assignments;
  final List<ElectionReadinessRecord> readiness;
  final int communicationReady;
  final int logisticsReady;

  @override
  Widget build(BuildContext context) {
    final checked = assignments.where((e) => e.checkedIn).length;
    final checkRate = assignments.isEmpty ? 0.0 : checked / assignments.length;
    final commRate = readiness.isEmpty ? 0.0 : communicationReady / readiness.length;
    final logRate = readiness.isEmpty ? 0.0 : logisticsReady / readiness.length;
    final avg = readiness.isEmpty
        ? 0.0
        : readiness.map((e) => e.agentCoveragePercent).reduce((a, b) => a + b) /
            readiness.length /
            100;
    return SectionCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Response health',
            style: TextStyle(color: ink, fontSize: 17, fontWeight: FontWeight.w900)),
        const SizedBox(height: 3),
        const Text('Operational readiness behind the incident response picture',
            style: TextStyle(color: muted, fontSize: 10.5)),
        const SizedBox(height: 17),
        _HealthBar('Field leadership checked in', checkRate,
            '$checked/${assignments.length}', const Color(0xFF2563EB)),
        _HealthBar('Communications ready', commRate,
            '$communicationReady/${readiness.length}', const Color(0xFF0F766E)),
        _HealthBar('Logistics ready', logRate,
            '$logisticsReady/${readiness.length}', const Color(0xFFD97706)),
        _HealthBar('Average agent coverage', avg,
            '${(avg * 100).toStringAsFixed(0)}%', pdpGreen),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(11),
          decoration: BoxDecoration(
            color: const Color(0xFFF7F9F7),
            borderRadius: BorderRadius.circular(13),
            border: Border.all(color: const Color(0xFFE5EAE6)),
          ),
          child: const Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Icon(Icons.info_outline_rounded, color: muted, size: 18),
            SizedBox(width: 8),
            Expanded(child: Text(
              'These are prototype shared-record readiness indicators. WebSocket presence, delivery acknowledgements and live device status are not connected yet.',
              style: TextStyle(color: muted, fontSize: 9.5, height: 1.4),
            )),
          ]),
        ),
      ]),
    );
  }
}

class _HealthBar extends StatelessWidget {
  const _HealthBar(this.label, this.value, this.display, this.color);
  final String label;
  final double value;
  final String display;
  final Color color;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Column(children: [
          Row(children: [
            Expanded(child: Text(label,
                style: const TextStyle(color: ink, fontSize: 10.5, fontWeight: FontWeight.w800))),
            Text(display,
                style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w900)),
          ]),
          const SizedBox(height: 7),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: value.clamp(0, 1).toDouble(),
              minHeight: 7,
              backgroundColor: const Color(0xFFE7ECE8),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ]),
      );
}

class _FieldEvidenceFeed extends StatelessWidget {
  const _FieldEvidenceFeed({required this.reports});
  final List<FieldReport> reports;

  @override
  Widget build(BuildContext context) => SectionCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Field evidence feed',
              style: TextStyle(color: ink, fontSize: 17, fontWeight: FontWeight.w900)),
          const SizedBox(height: 3),
          const Text('Recent structured reports flowing into command review',
              style: TextStyle(color: muted, fontSize: 10.5)),
          const SizedBox(height: 14),
          if (reports.isEmpty)
            const _EmptyState('No field reports in this scope.')
          else
            ...reports.take(6).map((report) => Container(
              margin: const EdgeInsets.only(bottom: 9),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAF9),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE6EBE7)),
              ),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(color: const Color(0xFFEAF4ED), borderRadius: BorderRadius.circular(11)),
                  child: const Icon(Icons.feed_outlined, color: pdpGreen, size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Expanded(child: Text(report.category,
                        style: const TextStyle(color: ink, fontSize: 11, fontWeight: FontWeight.w900))),
                    _MiniPill(_label(report.status.name).toUpperCase(), const Color(0xFF0F766E)),
                  ]),
                  const SizedBox(height: 4),
                  Text(report.summary,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: muted, fontSize: 9.5, height: 1.35)),
                  const SizedBox(height: 4),
                  Text('${report.id} • ${report.scope.label}',
                      style: const TextStyle(color: muted, fontSize: 9, fontWeight: FontWeight.w700)),
                ])),
              ]),
            )),
        ]),
      );
}

class _HotspotPanel extends StatelessWidget {
  const _HotspotPanel({required this.incidents});
  final List<CampaignIncident> incidents;

  @override
  Widget build(BuildContext context) {
    final grouped = <String, List<CampaignIncident>>{};
    for (final incident in incidents) {
      final name = incident.scope.lga ?? 'Statewide';
      grouped.putIfAbsent(name, () => []).add(incident);
    }
    final rows = grouped.entries.toList()
      ..sort((a, b) {
        final aScore = a.value.fold<int>(0, (s, e) => s + _severityRank(e.severity));
        final bScore = b.value.fold<int>(0, (s, e) => s + _severityRank(e.severity));
        return bScore.compareTo(aScore);
      });
    return SectionCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Operational hotspots',
            style: TextStyle(color: ink, fontSize: 17, fontWeight: FontWeight.w900)),
        const SizedBox(height: 3),
        const Text('Incident concentration ranked by count and severity',
            style: TextStyle(color: muted, fontSize: 10.5)),
        const SizedBox(height: 14),
        if (rows.isEmpty)
          const _EmptyState('No hotspots in this scope.')
        else
          ...rows.take(7).map((row) {
            final severe = row.value.where((e) =>
                e.severity == IncidentSeverity.critical || e.severity == IncidentSeverity.high).length;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(color: const Color(0xFFFDEBEC), borderRadius: BorderRadius.circular(11)),
                  child: const Icon(Icons.location_on_outlined, color: Color(0xFFD72638), size: 17),
                ),
                const SizedBox(width: 10),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(row.key,
                      style: const TextStyle(color: ink, fontSize: 10.5, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 2),
                  Text('${row.value.length} incidents • $severe critical/high',
                      style: const TextStyle(color: muted, fontSize: 9.5)),
                ])),
                Text('${row.value.length}',
                    style: const TextStyle(color: Color(0xFFD72638), fontSize: 16, fontWeight: FontWeight.w900)),
              ]),
            );
          }),
      ]),
    );
  }
}

class _SituationActions extends StatelessWidget {
  const _SituationActions({required this.actions});
  final List<_QuickSpec> actions;

  @override
  Widget build(BuildContext context) => SectionCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Response controls',
              style: TextStyle(color: ink, fontSize: 17, fontWeight: FontWeight.w900)),
          const SizedBox(height: 3),
          const Text('Move directly from command overview into the operational module needed next',
              style: TextStyle(color: muted, fontSize: 10.5)),
          const SizedBox(height: 14),
          LayoutBuilder(builder: (context, c) {
            final cols = c.maxWidth >= 1050 ? 6 : c.maxWidth >= 700 ? 3 : c.maxWidth >= 450 ? 2 : 1;
            const gap = 10.0;
            final width = (c.maxWidth - gap * (cols - 1)) / cols;
            return Wrap(
              spacing: gap,
              runSpacing: gap,
              children: actions.map((a) => SizedBox(
                width: width,
                child: InkWell(
                  onTap: a.onTap,
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAF9),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE4EAE5)),
                    ),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Icon(Icons.arrow_outward_rounded, color: Color(0xFFD72638), size: 17),
                      const SizedBox(height: 11),
                      Icon(a.icon, color: ink, size: 22),
                      const SizedBox(height: 9),
                      Text(a.label,
                          style: const TextStyle(color: ink, fontSize: 10.5, fontWeight: FontWeight.w900)),
                    ]),
                  ),
                ),
              )).toList(),
            );
          }),
        ]),
      );
}

class _EmptyState extends StatelessWidget {
  const _EmptyState(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(child: Text(text, style: const TextStyle(color: muted))),
      );
}

class _MetricSpec {
  const _MetricSpec(this.label, this.value, this.detail, this.icon);
  final String label;
  final String value;
  final String detail;
  final IconData icon;
}

class _ListItem {
  const _ListItem(this.title, this.detail, this.icon);
  final String title;
  final String detail;
  final IconData icon;
}

class _QuickSpec {
  const _QuickSpec(this.label, this.icon, this.onTap);
  final String label;
  final IconData icon;
  final VoidCallback onTap;
}

class _StandardRoleCommand extends StatelessWidget {
  const _StandardRoleCommand({
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accent,
    required this.metrics,
    required this.queueTitle,
    required this.queueSubtitle,
    required this.queue,
    required this.actionTitle,
    required this.actions,
    required this.doctrineTitle,
    required this.doctrine,
  });

  final String eyebrow;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accent;
  final List<_MetricSpec> metrics;
  final String queueTitle;
  final String queueSubtitle;
  final List<_ListItem> queue;
  final String actionTitle;
  final List<_QuickSpec> actions;
  final String doctrineTitle;
  final String doctrine;

  @override
  Widget build(BuildContext context) => ColoredBox(
        color: const Color(0xFFF3F6F3),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 22, 24, 38),
          children: [
            _RoleHero(
              eyebrow: eyebrow,
              title: title,
              subtitle: subtitle,
              icon: icon,
              accent: accent,
              operatorName: CampaignSession.of(context).operatorName,
              scopeLabel: CampaignScope.of(context).label,
            ),
            const SizedBox(height: 16),
            _MetricsGrid(metrics: metrics, accent: accent),
            const SizedBox(height: 16),
            LayoutBuilder(builder: (context, c) {
              final left = _PriorityList(title: queueTitle, subtitle: queueSubtitle, items: queue);
              final right = _QuickGrid(title: actionTitle, actions: actions);
              if (c.maxWidth < 980) {
                return Column(children: [left, const SizedBox(height: 14), right]);
              }
              return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Expanded(flex: 13, child: left),
                const SizedBox(width: 14),
                Expanded(flex: 8, child: right),
              ]);
            }),
            const SizedBox(height: 16),
            _Doctrine(title: doctrineTitle, text: doctrine),
          ],
        ),
      );
}

class _RoleHero extends StatelessWidget {
  const _RoleHero({
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accent,
    required this.operatorName,
    required this.scopeLabel,
  });

  final String eyebrow;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accent;
  final String operatorName;
  final String scopeLabel;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: LinearGradient(
            colors: [const Color(0xFF071C13), accent.withValues(alpha: .90)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [BoxShadow(color: accent.withValues(alpha: .16), blurRadius: 30, offset: const Offset(0, 12))],
        ),
        child: LayoutBuilder(builder: (context, c) {
          final compact = c.maxWidth < 780;
          final copy = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(eyebrow,
                style: const TextStyle(color: Colors.white60, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.6)),
            const SizedBox(height: 9),
            Text(title,
                style: TextStyle(color: Colors.white, fontSize: compact ? 27 : 36, height: 1.02, fontWeight: FontWeight.w900, letterSpacing: -.6)),
            const SizedBox(height: 9),
            Text(subtitle,
                style: const TextStyle(color: Colors.white70, height: 1.45, fontWeight: FontWeight.w600)),
          ]);
          final identity = Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .09),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withValues(alpha: .14)),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: .12), borderRadius: BorderRadius.circular(13)),
                child: Icon(icon, color: Colors.white),
              ),
              const SizedBox(width: 11),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(operatorName,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
                const SizedBox(height: 3),
                SizedBox(
                  width: compact ? 210 : 260,
                  child: Text(scopeLabel,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white60, fontSize: 10.5, fontWeight: FontWeight.w700)),
                ),
              ]),
            ]),
          );
          if (compact) {
            return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [copy, const SizedBox(height: 18), identity]);
          }
          return Row(children: [Expanded(child: copy), const SizedBox(width: 22), identity]);
        }),
      );
}

class _MetricsGrid extends StatelessWidget {
  const _MetricsGrid({required this.metrics, required this.accent});
  final List<_MetricSpec> metrics;
  final Color accent;

  @override
  Widget build(BuildContext context) => LayoutBuilder(builder: (context, c) {
        final cols = c.maxWidth >= 1050 ? 4 : c.maxWidth >= 620 ? 2 : 1;
        const gap = 12.0;
        final width = (c.maxWidth - gap * (cols - 1)) / cols;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: metrics.map((m) => SizedBox(
            width: width,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0xFFE1E9E3))),
              child: Row(children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(color: accent.withValues(alpha: .09), borderRadius: BorderRadius.circular(13)),
                  child: Icon(m.icon, color: accent, size: 21),
                ),
                const SizedBox(width: 11),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(m.value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: ink, fontSize: 19, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 2),
                  Text(m.label,
                      style: const TextStyle(color: ink, fontSize: 10.5, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 3),
                  Text(m.detail,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: muted, fontSize: 9.5, height: 1.25)),
                ])),
              ]),
            ),
          )).toList(),
        );
      });
}

class _PriorityList extends StatelessWidget {
  const _PriorityList({required this.title, required this.subtitle, required this.items});
  final String title;
  final String subtitle;
  final List<_ListItem> items;

  @override
  Widget build(BuildContext context) => SectionCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title,
              style: const TextStyle(color: ink, fontSize: 16, fontWeight: FontWeight.w900)),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(color: muted, height: 1.35, fontSize: 11)),
          const SizedBox(height: 14),
          if (items.isEmpty)
            const _EmptyState('No records in this command queue.')
          else
            ...items.map((item) => Container(
              margin: const EdgeInsets.only(bottom: 9),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: const Color(0xFFF8FAF8), borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFE7ECE8))),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(color: const Color(0xFFEAF4ED), borderRadius: BorderRadius.circular(11)),
                  child: Icon(item.icon, color: pdpGreen, size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(item.title,
                      style: const TextStyle(color: ink, fontWeight: FontWeight.w800, fontSize: 11.5)),
                  const SizedBox(height: 3),
                  Text(item.detail,
                      style: const TextStyle(color: muted, height: 1.35, fontSize: 10)),
                ])),
              ]),
            )),
        ]),
      );
}

class _QuickGrid extends StatelessWidget {
  const _QuickGrid({required this.title, required this.actions});
  final String title;
  final List<_QuickSpec> actions;

  @override
  Widget build(BuildContext context) => SectionCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title,
              style: const TextStyle(color: ink, fontSize: 16, fontWeight: FontWeight.w900)),
          const SizedBox(height: 14),
          ...actions.map((a) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: InkWell(
              onTap: a.onTap,
              borderRadius: BorderRadius.circular(13),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(color: const Color(0xFFF7FAF8), borderRadius: BorderRadius.circular(13), border: Border.all(color: const Color(0xFFE4EAE5))),
                child: Row(children: [
                  Icon(a.icon, color: pdpGreen, size: 20),
                  const SizedBox(width: 10),
                  Expanded(child: Text(a.label,
                      style: const TextStyle(color: ink, fontWeight: FontWeight.w800))),
                  const Icon(Icons.arrow_forward_ios_rounded, color: muted, size: 13),
                ]),
              ),
            ),
          )),
        ]),
      );
}

class _Doctrine extends StatelessWidget {
  const _Doctrine({required this.title, required this.text});
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: const Color(0xFFEAF4ED), borderRadius: BorderRadius.circular(17), border: Border.all(color: const Color(0xFFD5E7DA))),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Icon(Icons.lightbulb_outline_rounded, color: pdpGreen),
          const SizedBox(width: 11),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title,
                style: const TextStyle(color: ink, fontWeight: FontWeight.w900)),
            const SizedBox(height: 3),
            Text(text,
                style: const TextStyle(color: muted, height: 1.4, fontSize: 11)),
          ])),
        ]),
      );
}

String _label(String value) {
  final spaced = value.replaceAllMapped(
    RegExp(r'([a-z0-9])([A-Z])'),
    (m) => '${m.group(1)} ${m.group(2)}',
  );
  if (spaced.isEmpty) return spaced;
  return '${spaced[0].toUpperCase()}${spaced.substring(1)}';
}
