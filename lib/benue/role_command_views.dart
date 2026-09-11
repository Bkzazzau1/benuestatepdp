import 'package:flutter/material.dart';

import 'app_scope.dart';
import 'campaign_identity.dart';
import 'domain/models.dart';
import 'domain/records_store.dart';
import 'executive_dashboard.dart';
import 'session.dart';
import 'widgets.dart';

/// Routes the shared Command Overview destination to a purpose-built command
/// centre for the authenticated campaign role. The underlying records remain
/// shared; only the responsibilities, hierarchy and actions change by role.
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
    return _RoleCommandPage(
      eyebrow: 'STATEWIDE CAMPAIGN CONTROL',
      title: 'Director General Command',
      subtitle:
          'Execution, escalation and cross-unit accountability for ${CampaignIdentity.candidateName} campaign operations.',
      icon: Icons.account_balance_rounded,
      accent: const Color(0xFF0B7A3B),
      metrics: [
        _MetricSpec('Readiness', '${d.summary.averageReadiness.toStringAsFixed(0)}%',
            'Average agent coverage', Icons.speed_rounded),
        _MetricSpec('Open incidents', '${d.summary.openIncidents}',
            'Requires command visibility', Icons.warning_amber_rounded),
        _MetricSpec('Open tasks', '${d.summary.openTasks}',
            'Across active command scope', Icons.task_alt_rounded),
        _MetricSpec('Checked in', '${d.summary.checkedInAssignments}/${d.summary.assignments}',
            'Field leadership presence', Icons.how_to_reg_rounded),
      ],
      left: _PriorityList(
        title: 'Command priorities',
        subtitle: 'Highest-impact items requiring coordination',
        items: [
          ...d.incidents.take(3).map((e) => _ListItem(
                e.title,
                '${e.scope.label} • ${_enumLabel(e.severity.name)} severity',
                Icons.crisis_alert_outlined,
              )),
          ...d.tasks.take(2).map((e) => _ListItem(
                e.title,
                '${e.scope.label} • ${_enumLabel(e.status.name)}',
                Icons.checklist_rounded,
              )),
        ],
      ),
      right: _QuickGrid(
        title: 'DG command shortcuts',
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
      ),
      footer: const _CommandDoctrine(
        title: 'DG operating doctrine',
        text:
            'See the whole campaign, assign clear ownership, escalate exceptions quickly and measure whether every decision closes a real operational gap.',
      ),
    );
  }
}

class SituationRoomCommandView extends StatelessWidget {
  const SituationRoomCommandView({super.key, required this.onOpenModule});
  final ValueChanged<AppModule> onOpenModule;

  @override
  Widget build(BuildContext context) {
    final d = _RoleData.of(context);
    final critical = d.incidents
        .where((item) => item.severity == IncidentSeverity.critical)
        .length;
    return _RoleCommandPage(
      eyebrow: 'LIVE INCIDENT COMMAND',
      title: 'Situation Room Command',
      subtitle:
          'A response-first view for incidents, incoming field evidence, communications and election-day escalation.',
      icon: Icons.radar_rounded,
      accent: const Color(0xFFD72638),
      metrics: [
        _MetricSpec('Open incidents', '${d.summary.openIncidents}',
            'Active command queue', Icons.radar_rounded),
        _MetricSpec('Critical', '$critical', 'Immediate escalation',
            Icons.priority_high_rounded),
        _MetricSpec('Field reports', '${d.summary.fieldReports}',
            'Submitted in active scope', Icons.feed_outlined),
        _MetricSpec('Open tasks', '${d.summary.openTasks}', 'Response actions',
            Icons.assignment_outlined),
      ],
      left: _PriorityList(
        title: 'Live incident queue',
        subtitle: 'Current incidents ordered from the shared command record set',
        items: d.incidents
            .take(6)
            .map((e) => _ListItem(
                  e.title,
                  '${e.id} • ${e.scope.label} • ${_enumLabel(e.status.name)}',
                  Icons.report_problem_outlined,
                ))
            .toList(),
      ),
      right: _QuickGrid(
        title: 'Response controls',
        actions: [
          _QuickSpec('Open Situation Room', Icons.radar_rounded,
              () => onOpenModule(AppModule.situationRoom)),
          _QuickSpec('Secure Communications', Icons.forum_outlined,
              () => onOpenModule(AppModule.communications)),
          _QuickSpec('Field Network', Icons.hub_outlined,
              () => onOpenModule(AppModule.fieldNetwork)),
          _QuickSpec('Election Day', Icons.how_to_vote_outlined,
              () => onOpenModule(AppModule.electionDay)),
        ],
      ),
      footer: const _CommandDoctrine(
        title: 'Escalation rule',
        text:
            'Every serious incident should have a stable ID, accountable team, communication thread, evidence trail, linked task and explicit closure state.',
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
    return _RoleCommandPage(
      eyebrow: 'PLATFORM ADMINISTRATION',
      title: 'State Administrator Console',
      subtitle:
          'System-wide records, access posture, provenance and audit visibility for the Benue campaign platform.',
      icon: Icons.admin_panel_settings_rounded,
      accent: const Color(0xFF4054B2),
      metrics: [
        _MetricSpec('Users', '${d.records.users.length}', 'Shared campaign identities',
            Icons.people_alt_outlined),
        _MetricSpec('Assignments', '${d.records.assignments.length}',
            'Geography-linked role assignments', Icons.badge_outlined),
        _MetricSpec('Audit events', '${d.records.auditEvents.length}',
            'Recorded mutations', Icons.receipt_long_outlined),
        _MetricSpec('LGAs represented', '23', 'Base geography catalog',
            Icons.location_city_outlined),
      ],
      left: _PriorityList(
        title: 'Recent audit activity',
        subtitle: 'Newest shared-record mutations',
        items: d.records.auditEvents.reversed
            .take(6)
            .map((e) => _ListItem(
                  _enumLabel(e.action),
                  '${e.entityType} • ${e.entityId} • ${e.actorId}',
                  Icons.history_toggle_off_rounded,
                ))
            .toList(),
      ),
      right: _QuickGrid(
        title: 'Administration controls',
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
      ),
      footer: const _CommandDoctrine(
        title: 'Administration boundary',
        text:
            'Role visibility in Flutter is a user-experience layer. Production authorization, immutable audit and record permissions must be enforced server-side.',
      ),
    );
  }
}

class OperationsCommandView extends StatelessWidget {
  const OperationsCommandView({super.key, required this.onOpenModule});
  final ValueChanged<AppModule> onOpenModule;

  @override
  Widget build(BuildContext context) {
    final d = _RoleData.of(context);
    return _RoleCommandPage(
      eyebrow: 'CAMPAIGN EXECUTION',
      title: 'Operations Command',
      subtitle:
          'Activities, personnel deployment, readiness, tasks and execution gaps across the active geography.',
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
      left: _PriorityList(
        title: 'Execution queue',
        subtitle: 'Activities and tasks requiring operational follow-through',
        items: [
          ...d.activities.take(3).map((e) => _ListItem(
                e.title,
                '${e.scope.label} • ${_enumLabel(e.status.name)}',
                Icons.event_note_outlined,
              )),
          ...d.tasks.take(3).map((e) => _ListItem(
                e.title,
                '${e.id} • ${_enumLabel(e.status.name)}',
                Icons.task_outlined,
              )),
        ],
      ),
      right: _QuickGrid(
        title: 'Operations shortcuts',
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
      ),
      footer: const _CommandDoctrine(
        title: 'Operations focus',
        text:
            'Turn strategy into visible execution: who owns the work, where it is happening, what is blocked, what is due and what outcome was achieved.',
      ),
    );
  }
}

class MediaIntelligenceCommandView extends StatelessWidget {
  const MediaIntelligenceCommandView({super.key, required this.onOpenModule});
  final ValueChanged<AppModule> onOpenModule;

  @override
  Widget build(BuildContext context) {
    final d = _RoleData.of(context);
    return _RoleCommandPage(
      eyebrow: 'PUBLIC NARRATIVE & INTELLIGENCE',
      title: 'Media & Intelligence Command',
      subtitle:
          'Monitor public narratives, verify claims and connect historical election intelligence to current campaign communication.',
      icon: Icons.public_rounded,
      accent: const Color(0xFF7C3AED),
      metrics: [
        const _MetricSpec('Media feeds', 'Not connected',
            'Prototype integration pending', Icons.wifi_tethering_rounded),
        const _MetricSpec('Verification desk', 'Ready',
            'Human review required', Icons.fact_check_outlined),
        _MetricSpec('Field reports', '${d.summary.fieldReports}',
            'Potential evidence inputs', Icons.feed_outlined),
        const _MetricSpec('Individual profiling', 'Disabled',
            'Aggregate/public intelligence only', Icons.shield_outlined),
      ],
      left: const _PriorityList(
        title: 'Intelligence workflow',
        subtitle: 'How a public claim should move through the desk',
        items: [
          _ListItem('Detect public narrative',
              'Capture source, timestamp and public reach', Icons.travel_explore_outlined),
          _ListItem('Verify the claim',
              'Classify verified, false, misleading or insufficient evidence',
              Icons.fact_check_outlined),
          _ListItem('Assess campaign relevance',
              'Link only to aggregate geography and public issues',
              Icons.analytics_outlined),
          _ListItem('Prepare reviewed response',
              'No automated political persuasion or individual voter profiling',
              Icons.rate_review_outlined),
        ],
      ),
      right: _QuickGrid(
        title: 'Intelligence shortcuts',
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
      ),
      footer: const _CommandDoctrine(
        title: 'Intelligence standard',
        text:
            'Keep verified fact, source-backed interpretation and campaign hypothesis visibly separate. Confidence should fall when evidence is stale, partial or methodologically weak.',
      ),
    );
  }
}

class LegalCommandView extends StatelessWidget {
  const LegalCommandView({super.key, required this.onOpenModule});
  final ValueChanged<AppModule> onOpenModule;

  @override
  Widget build(BuildContext context) {
    final d = _RoleData.of(context);
    return _RoleCommandPage(
      eyebrow: 'LEGAL & EVIDENCE CONTROL',
      title: 'Legal Command',
      subtitle:
          'Election incidents, evidence integrity, escalation and legal-readiness oversight.',
      icon: Icons.gavel_rounded,
      accent: const Color(0xFF8A5B00),
      metrics: [
        _MetricSpec('Open incidents', '${d.summary.openIncidents}',
            'Potential legal review queue', Icons.report_problem_outlined),
        _MetricSpec('Field reports', '${d.summary.fieldReports}',
            'Possible evidence sources', Icons.description_outlined),
        _MetricSpec('Audit events', '${d.records.auditEvents.length}',
            'Record history', Icons.history_outlined),
        const _MetricSpec('Evidence vault', 'Prototype',
            'Secure backend storage pending', Icons.lock_outline_rounded),
      ],
      left: _PriorityList(
        title: 'Legal review queue',
        subtitle: 'Operational incidents that may require evidence preservation',
        items: d.incidents
            .take(6)
            .map((e) => _ListItem(
                  e.title,
                  '${e.id} • ${e.scope.label} • ${_enumLabel(e.severity.name)}',
                  Icons.gavel_outlined,
                ))
            .toList(),
      ),
      right: _QuickGrid(
        title: 'Legal shortcuts',
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
      ),
      footer: const _CommandDoctrine(
        title: 'Evidence doctrine',
        text:
            'Preserve original source, timestamp, geography, submitter, chain of custody and every later mutation. Campaign-collected election results remain unofficial until INEC declaration.',
      ),
    );
  }
}

class LogisticsCommandView extends StatelessWidget {
  const LogisticsCommandView({super.key, required this.onOpenModule});
  final ValueChanged<AppModule> onOpenModule;

  @override
  Widget build(BuildContext context) {
    final d = _RoleData.of(context);
    return _RoleCommandPage(
      eyebrow: 'ASSETS • MATERIALS • MOVEMENT',
      title: 'Logistics Command',
      subtitle:
          'Asset readiness, transport, task execution and logistics-related incident visibility.',
      icon: Icons.local_shipping_rounded,
      accent: const Color(0xFFD97706),
      metrics: [
        _MetricSpec('Assets', '${d.summary.assets}', 'Registered in active scope',
            Icons.inventory_2_outlined),
        _MetricSpec('Ready assets', '${d.summary.readyAssets}',
            'Available / assigned / in use', Icons.check_circle_outline_rounded),
        _MetricSpec('Open tasks', '${d.summary.openTasks}', 'Logistics work queue',
            Icons.checklist_rounded),
        _MetricSpec('Incidents', '${d.summary.openIncidents}',
            'Potential movement blockers', Icons.warning_amber_rounded),
      ],
      left: _PriorityList(
        title: 'Asset readiness',
        subtitle: 'Current assets in the shared record set',
        items: d.assets
            .take(6)
            .map((e) => _ListItem(
                  e.name,
                  '${e.id} • ${e.scope.label} • ${_enumLabel(e.status.name)}',
                  Icons.local_shipping_outlined,
                ))
            .toList(),
      ),
      right: _QuickGrid(
        title: 'Logistics shortcuts',
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
      ),
      footer: const _CommandDoctrine(
        title: 'Logistics focus',
        text:
            'Every asset should have a stable ID, custodian, geography, condition, current status and linked task when movement or maintenance is required.',
      ),
    );
  }
}

class FinanceCommandView extends StatelessWidget {
  const FinanceCommandView({super.key, required this.onOpenModule});
  final ValueChanged<AppModule> onOpenModule;

  @override
  Widget build(BuildContext context) {
    final d = _RoleData.of(context);
    return _RoleCommandPage(
      eyebrow: 'FINANCE GOVERNANCE',
      title: 'Finance Command',
      subtitle:
          'A finance-specific command surface prepared for budget, approvals, expenditure controls and audit integration.',
      icon: Icons.account_balance_wallet_rounded,
      accent: const Color(0xFF166534),
      metrics: [
        const _MetricSpec('Budget ledger', 'Not connected',
            'No financial amounts are fabricated', Icons.account_balance_outlined),
        const _MetricSpec('Approval queue', 'Backend required',
            'Role workflow pending', Icons.approval_outlined),
        _MetricSpec('Audit events', '${d.records.auditEvents.length}',
            'Operational audit available', Icons.receipt_long_outlined),
        const _MetricSpec('Expense evidence', 'Pending',
            'Document workflow to be connected', Icons.attach_file_rounded),
      ],
      left: const _PriorityList(
        title: 'Finance module readiness',
        subtitle: 'The UI is separated now; financial records still need a dedicated domain model',
        items: [
          _ListItem('Budget control', 'Campaign budget lines, envelopes and owner units',
              Icons.pie_chart_outline_rounded),
          _ListItem('Expense approvals', 'Request → review → authorization → payment → evidence',
              Icons.approval_outlined),
          _ListItem('Reconciliation', 'Payment evidence, vendor record and audit linkage',
              Icons.balance_rounded),
          _ListItem('Executive reporting', 'Aggregated spend without exposing unnecessary sensitive data',
              Icons.summarize_outlined),
        ],
      ),
      right: _QuickGrid(
        title: 'Finance shortcuts',
        actions: [
          _QuickSpec('Campaign Operations', Icons.campaign_outlined,
              () => onOpenModule(AppModule.campaignOperations)),
          _QuickSpec('Reports', Icons.description_outlined,
              () => onOpenModule(AppModule.reportsDocuments)),
          _QuickSpec('Data & Governance', Icons.policy_outlined,
              () => onOpenModule(AppModule.dataGovernance)),
        ],
      ),
      footer: const _CommandDoctrine(
        title: 'Finance integrity rule',
        text:
            'Until a verified finance repository exists, the prototype must show missing financial data explicitly rather than displaying demonstration naira amounts as real campaign finance.',
      ),
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
    return _RoleCommandPage(
      eyebrow: 'LOCAL GOVERNMENT COMMAND',
      title: selected ? '${d.scope.lgaName} LGA Command' : 'LGA Coordinator Command',
      subtitle: selected
          ? 'Local operations, personnel, incidents, readiness and election-day preparation for ${d.scope.lgaName}.'
          : 'Select an LGA from Benue Map to activate a true local-government command view.',
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
      left: selected
          ? _PriorityList(
              title: 'LGA operational queue',
              subtitle: 'Records constrained to the selected LGA',
              items: [
                ...d.incidents.take(3).map((e) => _ListItem(
                      e.title,
                      '${e.id} • ${_enumLabel(e.status.name)}',
                      Icons.report_problem_outlined,
                    )),
                ...d.tasks.take(3).map((e) => _ListItem(
                      e.title,
                      '${e.id} • ${_enumLabel(e.status.name)}',
                      Icons.task_outlined,
                    )),
              ],
            )
          : _ScopeRequired(onOpenMap: () => onOpenModule(AppModule.benueMap)),
      right: _QuickGrid(
        title: 'LGA shortcuts',
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
      ),
      footer: const _CommandDoctrine(
        title: 'LGA responsibility',
        text:
            'The LGA coordinator should see only the operational picture needed to coordinate local teams and escalate exceptions to state command.',
      ),
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
    return _RoleCommandPage(
      eyebrow: 'WARD COORDINATION',
      title: ward == null ? 'Ward Coordinator Command' : '$ward Ward Command',
      subtitle: ward == null
          ? 'Verified ward geography has not yet been assigned to this session.'
          : 'Ward-level team coordination, reports, incidents and election readiness.',
      icon: Icons.grid_view_rounded,
      accent: const Color(0xFF0E7490),
      metrics: [
        _MetricSpec('LGA assignments', '${d.summary.assignments}',
            'Ward-specific records unlock after import', Icons.groups_outlined),
        _MetricSpec('LGA incidents', '${d.summary.openIncidents}',
            'Visible for escalation context', Icons.warning_amber_outlined),
        const _MetricSpec('Ward roster', 'Locked',
            'Verified ward import required', Icons.lock_outline_rounded),
        const _MetricSpec('PU coverage', 'Locked',
            'Verified polling-unit import required', Icons.how_to_vote_outlined),
      ],
      left: const _PriorityList(
        title: 'Ward command readiness',
        subtitle: 'What becomes active after verified geography import',
        items: [
          _ListItem('Ward team roster', 'Coordinator, reporters and polling-unit agents',
              Icons.group_outlined),
          _ListItem('Ward incident board', 'Only geography-tagged local incidents',
              Icons.report_problem_outlined),
          _ListItem('Polling-unit readiness', 'Agent, communications and logistics coverage',
              Icons.how_to_vote_outlined),
          _ListItem('Ward field reports', 'Structured evidence flowing upward to LGA command',
              Icons.feed_outlined),
        ],
      ),
      right: _QuickGrid(
        title: 'Ward shortcuts',
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
      ),
      footer: const _CommandDoctrine(
        title: 'Ward data boundary',
        text:
            'Do not manufacture ward names, polling units or ward-level political conclusions. This command view becomes operational only from verified geography-tagged records.',
      ),
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
    return _RoleCommandPage(
      eyebrow: 'ELECTION-DAY FIELD CONSOLE',
      title: pu == null ? 'Polling Unit Agent Console' : '$pu Agent Console',
      subtitle: pu == null
          ? 'A verified polling-unit assignment is required before local result and check-in workflows activate.'
          : 'Focused election-day workflow for check-in, communications, incident reporting and unofficial campaign result capture.',
      icon: Icons.how_to_vote_rounded,
      accent: const Color(0xFFB91C1C),
      metrics: const [
        _MetricSpec('Assignment', 'Awaiting verified PU',
            'No fabricated polling-unit identity', Icons.place_outlined),
        _MetricSpec('Check-in', 'Pending assignment', 'Election-day identity workflow',
            Icons.verified_user_outlined),
        _MetricSpec('Result capture', 'Unofficial',
            'Campaign copy until INEC declaration', Icons.ballot_outlined),
        _MetricSpec('Escalation', 'Available', 'Communications + election-day modules',
            Icons.sos_outlined),
      ],
      left: const _PriorityList(
        title: 'Agent election-day sequence',
        subtitle: 'A deliberately simple field workflow',
        items: [
          _ListItem('1. Verify assignment & check in',
              'Confirm the correct polling unit before any submission', Icons.login_rounded),
          _ListItem('2. Report incident immediately',
              'Security, materials, accreditation or process issue', Icons.report_problem_outlined),
          _ListItem('3. Preserve result evidence',
              'Capture campaign evidence with time and polling-unit identity', Icons.document_scanner_outlined),
          _ListItem('4. Submit campaign result copy',
              'Always labelled unofficial until INEC declaration', Icons.upload_file_outlined),
        ],
      ),
      right: _QuickGrid(
        title: 'Agent shortcuts',
        actions: [
          _QuickSpec('Communications', Icons.forum_outlined,
              () => onOpenModule(AppModule.communications)),
          _QuickSpec('Election Day', Icons.how_to_vote_outlined,
              () => onOpenModule(AppModule.electionDay)),
        ],
      ),
      footer: const _CommandDoctrine(
        title: 'Agent safety rule',
        text:
            'The field agent interface should stay minimal under pressure: identity, check-in, incident, evidence, communications and result submission—nothing distracting.',
      ),
    );
  }
}

class FieldReporterCommandView extends StatelessWidget {
  const FieldReporterCommandView({super.key, required this.onOpenModule});
  final ValueChanged<AppModule> onOpenModule;

  @override
  Widget build(BuildContext context) {
    final d = _RoleData.of(context);
    return _RoleCommandPage(
      eyebrow: 'FIELD EVIDENCE CAPTURE',
      title: 'Field Reporter Console',
      subtitle:
          'Fast structured reporting, incident escalation and secure communication from the active geography.',
      icon: Icons.mobile_friendly_rounded,
      accent: const Color(0xFF0284C7),
      metrics: [
        _MetricSpec('Field reports', '${d.summary.fieldReports}',
            'Visible in active scope', Icons.feed_outlined),
        _MetricSpec('Open incidents', '${d.summary.openIncidents}',
            'Escalation context', Icons.warning_amber_outlined),
        _MetricSpec('Assignments', '${d.summary.assignments}', 'Field network context',
            Icons.badge_outlined),
        _MetricSpec('Scope', d.scope.label, 'Current reporting geography',
            Icons.location_on_outlined),
      ],
      left: _PriorityList(
        title: 'Recent field evidence',
        subtitle: 'Latest reports in the shared record set',
        items: d.reports
            .take(6)
            .map((e) => _ListItem(
                  e.category,
                  '${e.id} • ${e.scope.label} • ${_enumLabel(e.status.name)}',
                  Icons.feed_outlined,
                ))
            .toList(),
      ),
      right: _QuickGrid(
        title: 'Reporter shortcuts',
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
      ),
      footer: const _CommandDoctrine(
        title: 'Reporting standard',
        text:
            'Report observable facts first. Separate what was directly seen from what another person said, attach provenance, and escalate urgent incidents without waiting for a long narrative.',
      ),
    );
  }
}

class ExecutiveViewerCommandView extends StatelessWidget {
  const ExecutiveViewerCommandView({super.key, required this.onOpenModule});
  final ValueChanged<AppModule> onOpenModule;

  @override
  Widget build(BuildContext context) {
    final d = _RoleData.of(context);
    return _RoleCommandPage(
      eyebrow: 'READ-ONLY EXECUTIVE BRIEF',
      title: 'Executive Viewer',
      subtitle:
          'A concise read-only view of campaign health, intelligence, incidents and reporting without operational mutation controls.',
      icon: Icons.visibility_rounded,
      accent: const Color(0xFF475569),
      metrics: [
        _MetricSpec('Readiness', '${d.summary.averageReadiness.toStringAsFixed(0)}%',
            'Campaign coverage indicator', Icons.speed_outlined),
        _MetricSpec('Incidents', '${d.summary.openIncidents}', 'Open statewide items',
            Icons.warning_amber_outlined),
        _MetricSpec('Tasks', '${d.summary.openTasks}', 'Execution queue',
            Icons.task_outlined),
        _MetricSpec('Reports', '${d.summary.fieldReports}', 'Field evidence records',
            Icons.description_outlined),
      ],
      left: _PriorityList(
        title: 'Executive watchlist',
        subtitle: 'Read-only items with the highest current operational relevance',
        items: d.incidents
            .take(5)
            .map((e) => _ListItem(
                  e.title,
                  '${e.scope.label} • ${_enumLabel(e.severity.name)}',
                  Icons.visibility_outlined,
                ))
            .toList(),
      ),
      right: _QuickGrid(
        title: 'Read-only navigation',
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
      ),
      footer: const _CommandDoctrine(
        title: 'Viewer boundary',
        text:
            'This role is intentionally observational. It should never expose mutation controls, operational secrets beyond authorization, or edit privileges through UI shortcuts.',
      ),
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
  });

  final CampaignRecordsController records;
  final CampaignScopeController scope;
  final CampaignRecordsSummary summary;
  final List<CampaignIncident> incidents;
  final List<CampaignTask> tasks;
  final List<CampaignActivity> activities;
  final List<CampaignAsset> assets;
  final List<FieldReport> reports;

  static _RoleData of(BuildContext context) {
    final records = CampaignRecords.of(context);
    final scope = CampaignScope.of(context);
    final lgaId = scope.lgaId;
    final incidents = records.incidentsFor(lgaId).toList()
      ..sort((a, b) => _severityRank(b.severity).compareTo(_severityRank(a.severity)));
    return _RoleData(
      records: records,
      scope: scope,
      summary: records.summaryFor(lgaId),
      incidents: incidents,
      tasks: records.tasksFor(lgaId),
      activities: records.activitiesFor(lgaId),
      assets: records.assetsFor(lgaId),
      reports: records.reportsFor(lgaId).reversed.toList(growable: false),
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

class _RoleCommandPage extends StatelessWidget {
  const _RoleCommandPage({
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accent,
    required this.metrics,
    required this.left,
    required this.right,
    required this.footer,
  });

  final String eyebrow;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accent;
  final List<_MetricSpec> metrics;
  final Widget left;
  final Widget right;
  final Widget footer;

  @override
  Widget build(BuildContext context) {
    final session = CampaignSession.of(context);
    final scope = CampaignScope.of(context);
    return ColoredBox(
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
            operatorName: session.operatorName,
            scopeLabel: scope.label,
          ),
          const SizedBox(height: 16),
          _MetricsGrid(metrics: metrics, accent: accent),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 980) {
                return Column(children: [left, const SizedBox(height: 14), right]);
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 13, child: left),
                  const SizedBox(width: 14),
                  Expanded(flex: 8, child: right),
                ],
              );
            },
          ),
          const SizedBox(height: 16),
          footer,
        ],
      ),
    );
  }
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
          boxShadow: [
            BoxShadow(
              color: accent.withValues(alpha: .16),
              blurRadius: 30,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 780;
            final copy = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  eyebrow,
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.6,
                  ),
                ),
                const SizedBox(height: 9),
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: compact ? 27 : 36,
                    height: 1.02,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -.6,
                  ),
                ),
                const SizedBox(height: 9),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white70,
                    height: 1.45,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            );
            final identity = Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .09),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.white.withValues(alpha: .14)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: .12),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Icon(icon, color: Colors.white),
                  ),
                  const SizedBox(width: 11),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(operatorName,
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w900)),
                      const SizedBox(height: 3),
                      SizedBox(
                        width: compact ? 210 : 260,
                        child: Text(scopeLabel,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Colors.white60,
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                ],
              ),
            );
            if (compact) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [copy, const SizedBox(height: 18), identity],
              );
            }
            return Row(
              children: [
                Expanded(child: copy),
                const SizedBox(width: 22),
                identity,
              ],
            );
          },
        ),
      );
}

class _MetricSpec {
  const _MetricSpec(this.label, this.value, this.detail, this.icon);
  final String label;
  final String value;
  final String detail;
  final IconData icon;
}

class _MetricsGrid extends StatelessWidget {
  const _MetricsGrid({required this.metrics, required this.accent});
  final List<_MetricSpec> metrics;
  final Color accent;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          final columns = constraints.maxWidth >= 1050
              ? 4
              : constraints.maxWidth >= 620
                  ? 2
                  : 1;
          const gap = 12.0;
          final width = (constraints.maxWidth - gap * (columns - 1)) / columns;
          return Wrap(
            spacing: gap,
            runSpacing: gap,
            children: metrics
                .map((m) => SizedBox(
                      width: width,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: const Color(0xFFE1E9E3)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: accent.withValues(alpha: .09),
                                borderRadius: BorderRadius.circular(13),
                              ),
                              child: Icon(m.icon, color: accent, size: 21),
                            ),
                            const SizedBox(width: 11),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(m.value,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          color: ink,
                                          fontSize: 19,
                                          fontWeight: FontWeight.w900)),
                                  const SizedBox(height: 2),
                                  Text(m.label,
                                      style: const TextStyle(
                                          color: ink,
                                          fontSize: 10.5,
                                          fontWeight: FontWeight.w800)),
                                  const SizedBox(height: 3),
                                  Text(m.detail,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          color: muted,
                                          fontSize: 9.5,
                                          height: 1.25,
                                          fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ))
                .toList(),
          );
        },
      );
}

class _ListItem {
  const _ListItem(this.title, this.detail, this.icon);
  final String title;
  final String detail;
  final IconData icon;
}

class _PriorityList extends StatelessWidget {
  const _PriorityList({
    required this.title,
    required this.subtitle,
    required this.items,
  });

  final String title;
  final String subtitle;
  final List<_ListItem> items;

  @override
  Widget build(BuildContext context) => SectionCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    color: ink, fontSize: 16, fontWeight: FontWeight.w900)),
            const SizedBox(height: 4),
            Text(subtitle,
                style: const TextStyle(color: muted, height: 1.35, fontSize: 11)),
            const SizedBox(height: 14),
            if (items.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: Text('No records in this command queue.',
                      style: TextStyle(color: muted)),
                ),
              )
            else
              ...items.map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 9),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAF8),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFE7ECE8)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: const Color(0xFFEAF4ED),
                              borderRadius: BorderRadius.circular(11),
                            ),
                            child: Icon(item.icon, color: pdpGreen, size: 18),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.title,
                                    style: const TextStyle(
                                        color: ink,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 11.5)),
                                const SizedBox(height: 3),
                                Text(item.detail,
                                    style: const TextStyle(
                                        color: muted, height: 1.35, fontSize: 10)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
          ],
        ),
      );
}

class _QuickSpec {
  const _QuickSpec(this.label, this.icon, this.onTap);
  final String label;
  final IconData icon;
  final VoidCallback onTap;
}

class _QuickGrid extends StatelessWidget {
  const _QuickGrid({required this.title, required this.actions});
  final String title;
  final List<_QuickSpec> actions;

  @override
  Widget build(BuildContext context) => SectionCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    color: ink, fontSize: 16, fontWeight: FontWeight.w900)),
            const SizedBox(height: 14),
            ...actions.map((action) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: InkWell(
                    onTap: action.onTap,
                    borderRadius: BorderRadius.circular(13),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7FAF8),
                        borderRadius: BorderRadius.circular(13),
                        border: Border.all(color: const Color(0xFFE4EAE5)),
                      ),
                      child: Row(
                        children: [
                          Icon(action.icon, color: pdpGreen, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(action.label,
                                style: const TextStyle(
                                    color: ink, fontWeight: FontWeight.w800)),
                          ),
                          const Icon(Icons.arrow_forward_ios_rounded,
                              color: muted, size: 13),
                        ],
                      ),
                    ),
                  ),
                )),
          ],
        ),
      );
}

class _ScopeRequired extends StatelessWidget {
  const _ScopeRequired({required this.onOpenMap});
  final VoidCallback onOpenMap;

  @override
  Widget build(BuildContext context) => SectionCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.location_searching_rounded, color: pdpGreen, size: 34),
            const SizedBox(height: 12),
            const Text('Choose an LGA to activate local command',
                style: TextStyle(color: ink, fontSize: 17, fontWeight: FontWeight.w900)),
            const SizedBox(height: 7),
            const Text(
              'The coordinator dashboard should never mix all 23 LGAs into one local command view. Select the assigned LGA first.',
              style: TextStyle(color: muted, height: 1.45),
            ),
            const SizedBox(height: 14),
            FilledButton.icon(
              onPressed: onOpenMap,
              icon: const Icon(Icons.map_outlined),
              label: const Text('Open Benue Map'),
            ),
          ],
        ),
      );
}

class _CommandDoctrine extends StatelessWidget {
  const _CommandDoctrine({required this.title, required this.text});
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFEAF4ED),
          borderRadius: BorderRadius.circular(17),
          border: Border.all(color: const Color(0xFFD5E7DA)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.lightbulb_outline_rounded, color: pdpGreen),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(color: ink, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 3),
                  Text(text,
                      style: const TextStyle(color: muted, height: 1.4, fontSize: 11)),
                ],
              ),
            ),
          ],
        ),
      );
}

String _enumLabel(String value) {
  final spaced = value.replaceAllMapped(
    RegExp(r'([a-z0-9])([A-Z])'),
    (match) => '${match.group(1)} ${match.group(2)}',
  );
  if (spaced.isEmpty) return spaced;
  return '${spaced[0].toUpperCase()}${spaced.substring(1)}';
}
