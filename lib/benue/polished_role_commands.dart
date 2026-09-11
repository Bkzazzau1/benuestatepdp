import 'package:flutter/material.dart';

import 'app_scope.dart';
import 'campaign_identity.dart';
import 'domain/models.dart';
import 'domain/records_store.dart';
import 'session.dart';
import 'widgets.dart';

class CandidateCommandView extends StatelessWidget {
  const CandidateCommandView({super.key, required this.onOpenModule});
  final ValueChanged<AppModule> onOpenModule;

  @override
  Widget build(BuildContext context) {
    final d = _CommandData.of(context);
    return _CommandScaffold(
      eyebrow: 'CANDIDATE COMMAND',
      title: CampaignIdentity.candidateName,
      subtitle: 'Executive campaign overview, priorities and statewide visibility.',
      icon: Icons.workspace_premium_rounded,
      accent: pdpGreen,
      badges: const ['EXECUTIVE VIEW', 'BENUE STATE'],
      metrics: _executiveMetrics(d),
      primaryTitle: 'Campaign priorities',
      primaryItems: _priorityItems(d),
      secondaryTitle: 'Campaign health',
      secondary: _HealthPanel(data: d),
      actionTitle: 'Quick actions',
      actions: [
        _Action('Benue Map', Icons.map_outlined, () => onOpenModule(AppModule.benueMap)),
        _Action('Situation Room', Icons.radar_rounded, () => onOpenModule(AppModule.situationRoom)),
        _Action('Election Intelligence', Icons.analytics_rounded,
            () => onOpenModule(AppModule.electionIntelligence)),
        _Action('Campaign Operations', Icons.campaign_outlined,
            () => onOpenModule(AppModule.campaignOperations)),
        _Action('Reports', Icons.description_outlined,
            () => onOpenModule(AppModule.reportsDocuments)),
      ],
      doctrineTitle: 'Candidate focus',
      doctrine:
          'Keep attention on the most important campaign priorities, exceptions and decisions that need executive direction.',
    );
  }
}

class DirectorGeneralCommandView extends StatelessWidget {
  const DirectorGeneralCommandView({super.key, required this.onOpenModule});
  final ValueChanged<AppModule> onOpenModule;

  @override
  Widget build(BuildContext context) {
    final d = _CommandData.of(context);
    return _CommandScaffold(
      eyebrow: 'STATEWIDE CAMPAIGN CONTROL',
      title: 'Director General Command',
      subtitle: 'Statewide execution, accountability and campaign readiness.',
      icon: Icons.account_balance_rounded,
      accent: pdpGreen,
      badges: const ['DIRECTOR GENERAL', 'STATEWIDE COMMAND'],
      metrics: _executiveMetrics(d),
      primaryTitle: 'LGA readiness board',
      primaryItems: _readinessItems(d),
      secondaryTitle: 'DG decision desk',
      secondary: _DecisionPanel(data: d),
      extraSections: [
        _TwoPanel(
          left: _SimplePanel(
            title: 'Campaign activity board',
            subtitle: 'Upcoming and active campaign activities',
            items: d.activities
                .take(6)
                .map((e) => _QueueItem(
                      e.title,
                      '${e.scope.label} • ${_nice(e.status.name)}',
                      Icons.event_available_outlined,
                    ))
                .toList(),
          ),
          right: _PanelCard(
            title: 'Execution health',
            subtitle: 'Field presence, readiness and task follow-through',
            child: _HealthPanel(data: d, compact: true),
          ),
        ),
        _ExecutiveBrief(data: d),
      ],
      actionTitle: 'DG command shortcuts',
      actions: [
        _Action('Situation Room', Icons.radar_rounded,
            () => onOpenModule(AppModule.situationRoom)),
        _Action('Campaign Operations', Icons.campaign_outlined,
            () => onOpenModule(AppModule.campaignOperations)),
        _Action('Election Intelligence', Icons.analytics_rounded,
            () => onOpenModule(AppModule.electionIntelligence)),
        _Action('Benue Map', Icons.map_outlined,
            () => onOpenModule(AppModule.benueMap)),
        _Action('Reports', Icons.description_outlined,
            () => onOpenModule(AppModule.reportsDocuments)),
        _Action('Data & Governance', Icons.admin_panel_settings_outlined,
            () => onOpenModule(AppModule.dataGovernance)),
      ],
      doctrineTitle: 'DG operating doctrine',
      doctrine:
          'See the whole campaign, identify weak points early, assign ownership and follow every priority through to closure.',
    );
  }
}

class SituationRoomCommandView extends StatelessWidget {
  const SituationRoomCommandView({super.key, required this.onOpenModule});
  final ValueChanged<AppModule> onOpenModule;

  @override
  Widget build(BuildContext context) {
    final d = _CommandData.of(context);
    final critical = d.incidents
        .where((e) => e.severity == IncidentSeverity.critical)
        .length;
    final high = d.incidents.where((e) => e.severity == IncidentSeverity.high).length;
    return _CommandScaffold(
      eyebrow: 'LIVE CAMPAIGN RESPONSE',
      title: 'Situation Room Command',
      subtitle: 'Incident response, field evidence, communications and escalation.',
      icon: Icons.radar_rounded,
      accent: const Color(0xFFD72638),
      badges: const ['LIVE OPERATIONS', 'RESPONSE COMMAND'],
      metrics: [
        _Metric('Open incidents', '${d.summary.openIncidents}', 'Active response queue',
            Icons.radar_rounded),
        _Metric('Critical / high', '$critical / $high', 'Highest priority cases',
            Icons.priority_high_rounded),
        _Metric('Field reports', '${d.summary.fieldReports}', 'Recent field updates',
            Icons.feed_outlined),
        _Metric('Checked in', '${d.summary.checkedInAssignments}/${d.summary.assignments}',
            'Field leadership presence', Icons.how_to_reg_rounded),
      ],
      primaryTitle: 'Incident command board',
      primaryItems: d.incidents
          .take(7)
          .map((e) => _QueueItem(
                e.title,
                '${e.scope.label} • ${_nice(e.severity.name)} • ${_nice(e.status.name)}',
                Icons.crisis_alert_outlined,
              ))
          .toList(),
      secondaryTitle: 'Response health',
      secondary: _HealthPanel(data: d),
      extraSections: [
        _TwoPanel(
          left: _SimplePanel(
            title: 'Field evidence feed',
            subtitle: 'Recent reports from campaign teams',
            items: d.reports
                .take(6)
                .map((e) => _QueueItem(
                      e.category,
                      '${e.scope.label} • ${_nice(e.status.name)}',
                      Icons.feed_outlined,
                    ))
                .toList(),
          ),
          right: _HotspotPanel(incidents: d.incidents),
        ),
      ],
      actionTitle: 'Response controls',
      actions: [
        _Action('Incident Command', Icons.radar_rounded,
            () => onOpenModule(AppModule.situationRoom)),
        _Action('Communications', Icons.forum_outlined,
            () => onOpenModule(AppModule.communications)),
        _Action('Field Network', Icons.hub_outlined,
            () => onOpenModule(AppModule.fieldNetwork)),
        _Action('Election Day', Icons.how_to_vote_outlined,
            () => onOpenModule(AppModule.electionDay)),
        _Action('Logistics & Tasks', Icons.inventory_2_outlined,
            () => onOpenModule(AppModule.logisticsTasks)),
        _Action('Benue Map', Icons.map_outlined,
            () => onOpenModule(AppModule.benueMap)),
      ],
      doctrineTitle: 'Situation Room response doctrine',
      doctrine:
          'Detect, acknowledge, assign, communicate, preserve evidence, resolve and close.',
    );
  }
}

class StateAdministratorCommandView extends StatelessWidget {
  const StateAdministratorCommandView({super.key, required this.onOpenModule});
  final ValueChanged<AppModule> onOpenModule;

  @override
  Widget build(BuildContext context) {
    final d = _CommandData.of(context);
    return _standard(
      d: d,
      eyebrow: 'STATE ADMINISTRATION',
      title: 'State Administrator Console',
      subtitle: 'Campaign accounts, assignments, records and statewide administration.',
      icon: Icons.admin_panel_settings_rounded,
      accent: const Color(0xFF4054B2),
      primaryTitle: 'Administration overview',
      primaryItems: [
        _QueueItem('Campaign accounts', '${d.records.users.length} active records', Icons.people_alt_outlined),
        _QueueItem('Field assignments', '${d.records.assignments.length} assignments', Icons.badge_outlined),
        _QueueItem('Campaign areas', '23 Local Government Areas', Icons.location_city_outlined),
        _QueueItem('Activity history', '${d.records.auditEvents.length} recorded actions', Icons.history_rounded),
      ],
      actions: [
        _Action('Data & Governance', Icons.policy_outlined,
            () => onOpenModule(AppModule.dataGovernance)),
        _Action('Field Network', Icons.manage_accounts_outlined,
            () => onOpenModule(AppModule.fieldNetwork)),
        _Action('Benue Map', Icons.map_outlined,
            () => onOpenModule(AppModule.benueMap)),
        _Action('Reports', Icons.description_outlined,
            () => onOpenModule(AppModule.reportsDocuments)),
      ],
      doctrineTitle: 'Administration focus',
      doctrine: 'Keep campaign accounts, assignments and records organized, current and accountable.',
    );
  }
}

class OperationsCommandView extends StatelessWidget {
  const OperationsCommandView({super.key, required this.onOpenModule});
  final ValueChanged<AppModule> onOpenModule;

  @override
  Widget build(BuildContext context) {
    final d = _CommandData.of(context);
    return _standard(
      d: d,
      eyebrow: 'CAMPAIGN EXECUTION',
      title: 'Operations Command',
      subtitle: 'Activities, teams, tasks and field execution across the campaign.',
      icon: Icons.settings_suggest_rounded,
      accent: const Color(0xFF0F766E),
      primaryTitle: 'Execution queue',
      primaryItems: [
        ...d.activities.take(3).map((e) => _QueueItem(
              e.title,
              '${e.scope.label} • ${_nice(e.status.name)}',
              Icons.event_note_outlined,
            )),
        ...d.tasks.take(3).map((e) => _QueueItem(
              e.title,
              '${e.scope.label} • ${_nice(e.status.name)}',
              Icons.task_outlined,
            )),
      ],
      actions: [
        _Action('Campaign Operations', Icons.campaign_outlined,
            () => onOpenModule(AppModule.campaignOperations)),
        _Action('Field Network', Icons.hub_outlined,
            () => onOpenModule(AppModule.fieldNetwork)),
        _Action('Logistics & Tasks', Icons.inventory_2_outlined,
            () => onOpenModule(AppModule.logisticsTasks)),
        _Action('Situation Room', Icons.radar_rounded,
            () => onOpenModule(AppModule.situationRoom)),
      ],
      doctrineTitle: 'Operations focus',
      doctrine: 'Turn campaign plans into clear owners, dates, locations and completed actions.',
    );
  }
}

class MediaIntelligenceCommandView extends StatelessWidget {
  const MediaIntelligenceCommandView({super.key, required this.onOpenModule});
  final ValueChanged<AppModule> onOpenModule;

  @override
  Widget build(BuildContext context) {
    final d = _CommandData.of(context);
    return _standard(
      d: d,
      eyebrow: 'MEDIA & INTELLIGENCE',
      title: 'Media & Intelligence Command',
      subtitle: 'Public narratives, election intelligence, trends and campaign messaging.',
      icon: Icons.public_rounded,
      accent: const Color(0xFF7C3AED),
      primaryTitle: 'Intelligence desk',
      primaryItems: [
        _QueueItem('Election intelligence', 'Historical and current political analysis', Icons.analytics_outlined),
        _QueueItem('Campaign trends', 'Track changing campaign signals', Icons.trending_up_rounded),
        _QueueItem('Media monitoring', 'Review public narratives and issues', Icons.public_outlined),
        _QueueItem('Field reports', '${d.summary.fieldReports} reports available', Icons.feed_outlined),
      ],
      actions: [
        _Action('Media Intelligence', Icons.public_rounded,
            () => onOpenModule(AppModule.mediaIntelligence)),
        _Action('Election Intelligence', Icons.psychology_alt_outlined,
            () => onOpenModule(AppModule.electionIntelligence)),
        _Action('Campaign Trends', Icons.trending_up_rounded,
            () => onOpenModule(AppModule.campaignTrends)),
        _Action('Historical Elections', Icons.history_rounded,
            () => onOpenModule(AppModule.historicalElections)),
      ],
      doctrineTitle: 'Intelligence standard',
      doctrine: 'Separate confirmed facts from analysis and keep every important claim tied to its evidence.',
    );
  }
}

class LegalCommandView extends StatelessWidget {
  const LegalCommandView({super.key, required this.onOpenModule});
  final ValueChanged<AppModule> onOpenModule;

  @override
  Widget build(BuildContext context) {
    final d = _CommandData.of(context);
    return _standard(
      d: d,
      eyebrow: 'LEGAL & EVIDENCE',
      title: 'Legal Command',
      subtitle: 'Legal review, incident evidence and election-day readiness.',
      icon: Icons.gavel_rounded,
      accent: const Color(0xFF8A5B00),
      primaryTitle: 'Legal review queue',
      primaryItems: d.incidents
          .take(6)
          .map((e) => _QueueItem(
                e.title,
                '${e.scope.label} • ${_nice(e.severity.name)}',
                Icons.gavel_outlined,
              ))
          .toList(),
      actions: [
        _Action('Situation Room', Icons.radar_rounded,
            () => onOpenModule(AppModule.situationRoom)),
        _Action('Election Day', Icons.how_to_vote_outlined,
            () => onOpenModule(AppModule.electionDay)),
        _Action('Data & Governance', Icons.policy_outlined,
            () => onOpenModule(AppModule.dataGovernance)),
        _Action('Reports', Icons.description_outlined,
            () => onOpenModule(AppModule.reportsDocuments)),
      ],
      doctrineTitle: 'Evidence focus',
      doctrine: 'Preserve clear evidence, ownership, dates and the full history of important election matters.',
    );
  }
}

class LogisticsCommandView extends StatelessWidget {
  const LogisticsCommandView({super.key, required this.onOpenModule});
  final ValueChanged<AppModule> onOpenModule;

  @override
  Widget build(BuildContext context) {
    final d = _CommandData.of(context);
    return _standard(
      d: d,
      eyebrow: 'ASSETS • MATERIALS • MOVEMENT',
      title: 'Logistics Command',
      subtitle: 'Campaign assets, transport, materials and operational movement.',
      icon: Icons.local_shipping_rounded,
      accent: const Color(0xFFD97706),
      primaryTitle: 'Asset readiness',
      primaryItems: d.assets
          .take(6)
          .map((e) => _QueueItem(
                e.name,
                '${e.scope.label} • ${_nice(e.status.name)}',
                Icons.local_shipping_outlined,
              ))
          .toList(),
      actions: [
        _Action('Logistics & Tasks', Icons.inventory_2_outlined,
            () => onOpenModule(AppModule.logisticsTasks)),
        _Action('Campaign Operations', Icons.campaign_outlined,
            () => onOpenModule(AppModule.campaignOperations)),
        _Action('Benue Map', Icons.map_outlined,
            () => onOpenModule(AppModule.benueMap)),
        _Action('Election Day', Icons.how_to_vote_outlined,
            () => onOpenModule(AppModule.electionDay)),
      ],
      doctrineTitle: 'Logistics focus',
      doctrine: 'Know where every important asset is, who owns it and whether it is ready for use.',
    );
  }
}

class FinanceCommandView extends StatelessWidget {
  const FinanceCommandView({super.key, required this.onOpenModule});
  final ValueChanged<AppModule> onOpenModule;

  @override
  Widget build(BuildContext context) {
    final d = _CommandData.of(context);
    return _standard(
      d: d,
      eyebrow: 'CAMPAIGN FINANCE',
      title: 'Finance Command',
      subtitle: 'Budget oversight, approvals, supporting documents and financial reporting.',
      icon: Icons.account_balance_wallet_rounded,
      accent: const Color(0xFF166534),
      primaryTitle: 'Finance workspace',
      primaryItems: const [
        _QueueItem('Budget control', 'Campaign budgets and spending plans', Icons.pie_chart_outline_rounded),
        _QueueItem('Approvals', 'Review requests and authorizations', Icons.approval_outlined),
        _QueueItem('Supporting documents', 'Receipts, invoices and payment records', Icons.receipt_long_outlined),
        _QueueItem('Finance reports', 'Executive financial summaries', Icons.summarize_outlined),
      ],
      actions: [
        _Action('Campaign Operations', Icons.campaign_outlined,
            () => onOpenModule(AppModule.campaignOperations)),
        _Action('Reports', Icons.description_outlined,
            () => onOpenModule(AppModule.reportsDocuments)),
        _Action('Data & Governance', Icons.policy_outlined,
            () => onOpenModule(AppModule.dataGovernance)),
      ],
      doctrineTitle: 'Finance focus',
      doctrine: 'Keep approvals, supporting documents and financial reporting clear and accountable.',
    );
  }
}

class LgaCommandView extends StatelessWidget {
  const LgaCommandView({super.key, required this.onOpenModule});
  final ValueChanged<AppModule> onOpenModule;

  @override
  Widget build(BuildContext context) {
    final d = _CommandData.of(context);
    final selected = d.scope.lgaName != null;
    return _standard(
      d: d,
      eyebrow: 'LOCAL GOVERNMENT COMMAND',
      title: selected ? '${d.scope.lgaName} LGA Command' : 'LGA Coordinator Command',
      subtitle: selected
          ? 'Local campaign teams, incidents, activities and election readiness.'
          : 'Choose your Local Government Area to open the local command view.',
      icon: Icons.location_city_rounded,
      accent: const Color(0xFF2563EB),
      primaryTitle: 'LGA operational queue',
      primaryItems: selected
          ? [
              ...d.incidents.take(3).map((e) => _QueueItem(
                    e.title,
                    _nice(e.status.name),
                    Icons.report_problem_outlined,
                  )),
              ...d.tasks.take(3).map((e) => _QueueItem(
                    e.title,
                    _nice(e.status.name),
                    Icons.task_outlined,
                  )),
            ]
          : const [
              _QueueItem('Choose an LGA', 'Open Benue Map and select your campaign area.', Icons.location_searching_rounded),
            ],
      actions: [
        _Action('Benue Map', Icons.map_outlined,
            () => onOpenModule(AppModule.benueMap)),
        _Action('Field Network', Icons.hub_outlined,
            () => onOpenModule(AppModule.fieldNetwork)),
        _Action('Situation Room', Icons.radar_rounded,
            () => onOpenModule(AppModule.situationRoom)),
        _Action('Election Day', Icons.how_to_vote_outlined,
            () => onOpenModule(AppModule.electionDay)),
      ],
      doctrineTitle: 'LGA responsibility',
      doctrine: 'Coordinate local teams, keep local records current and escalate important issues quickly.',
    );
  }
}

class WardCommandView extends StatelessWidget {
  const WardCommandView({super.key, required this.onOpenModule});
  final ValueChanged<AppModule> onOpenModule;

  @override
  Widget build(BuildContext context) {
    final d = _CommandData.of(context);
    final ward = d.scope.wardName;
    return _standard(
      d: d,
      eyebrow: 'WARD COORDINATION',
      title: ward == null ? 'Ward Coordinator Command' : '$ward Ward Command',
      subtitle: ward == null
          ? 'Choose your ward to open the local coordination view.'
          : 'Ward teams, field updates, incidents and polling-unit coordination.',
      icon: Icons.grid_view_rounded,
      accent: const Color(0xFF0E7490),
      primaryTitle: 'Ward priorities',
      primaryItems: const [
        _QueueItem('Ward team', 'Coordinate ward members and field reporters', Icons.group_outlined),
        _QueueItem('Local issues', 'Track and escalate urgent ward matters', Icons.report_problem_outlined),
        _QueueItem('Polling units', 'Coordinate polling-unit teams and readiness', Icons.how_to_vote_outlined),
        _QueueItem('Field reports', 'Share structured updates with LGA command', Icons.feed_outlined),
      ],
      actions: [
        _Action('Benue Map', Icons.map_outlined,
            () => onOpenModule(AppModule.benueMap)),
        _Action('Field Network', Icons.hub_outlined,
            () => onOpenModule(AppModule.fieldNetwork)),
        _Action('Communications', Icons.forum_outlined,
            () => onOpenModule(AppModule.communications)),
        _Action('Election Day', Icons.how_to_vote_outlined,
            () => onOpenModule(AppModule.electionDay)),
      ],
      doctrineTitle: 'Ward responsibility',
      doctrine: 'Keep ward teams coordinated and maintain a clear line between polling units, the ward and LGA command.',
    );
  }
}

class PollingUnitAgentCommandView extends StatelessWidget {
  const PollingUnitAgentCommandView({super.key, required this.onOpenModule});
  final ValueChanged<AppModule> onOpenModule;

  @override
  Widget build(BuildContext context) {
    final d = _CommandData.of(context);
    final pu = d.scope.pollingUnitName;
    return _standard(
      d: d,
      eyebrow: 'ELECTION-DAY FIELD CONSOLE',
      title: pu == null ? 'Polling Unit Agent Console' : '$pu Agent Console',
      subtitle: pu == null
          ? 'Select your polling-unit assignment to begin.'
          : 'Check-in, incident reporting, communications and result capture.',
      icon: Icons.how_to_vote_rounded,
      accent: const Color(0xFFB91C1C),
      primaryTitle: 'Election-day sequence',
      primaryItems: const [
        _QueueItem('1. Confirm assignment', 'Check your polling unit and report arrival', Icons.login_rounded),
        _QueueItem('2. Report incidents', 'Escalate security, materials or process issues', Icons.report_problem_outlined),
        _QueueItem('3. Preserve result evidence', 'Capture clear result documentation', Icons.document_scanner_outlined),
        _QueueItem('4. Submit campaign copy', 'Send the campaign result record', Icons.upload_file_outlined),
      ],
      actions: [
        _Action('Communications', Icons.forum_outlined,
            () => onOpenModule(AppModule.communications)),
        _Action('Election Day', Icons.how_to_vote_outlined,
            () => onOpenModule(AppModule.electionDay)),
      ],
      doctrineTitle: 'Agent focus',
      doctrine: 'Stay accurate, calm and fast: check in, report issues, preserve evidence and submit the result copy.',
    );
  }
}

class FieldReporterCommandView extends StatelessWidget {
  const FieldReporterCommandView({super.key, required this.onOpenModule});
  final ValueChanged<AppModule> onOpenModule;

  @override
  Widget build(BuildContext context) {
    final d = _CommandData.of(context);
    return _standard(
      d: d,
      eyebrow: 'FIELD REPORTING',
      title: 'Field Reporter Console',
      subtitle: 'Fast reporting, evidence capture and incident escalation.',
      icon: Icons.mobile_friendly_rounded,
      accent: const Color(0xFF0284C7),
      primaryTitle: 'Recent field reports',
      primaryItems: d.reports
          .take(6)
          .map((e) => _QueueItem(
                e.category,
                '${e.scope.label} • ${_nice(e.status.name)}',
                Icons.feed_outlined,
              ))
          .toList(),
      actions: [
        _Action('Situation Room', Icons.radar_rounded,
            () => onOpenModule(AppModule.situationRoom)),
        _Action('Communications', Icons.forum_outlined,
            () => onOpenModule(AppModule.communications)),
        _Action('Field Network', Icons.hub_outlined,
            () => onOpenModule(AppModule.fieldNetwork)),
        _Action('Benue Map', Icons.map_outlined,
            () => onOpenModule(AppModule.benueMap)),
      ],
      doctrineTitle: 'Reporting focus',
      doctrine: 'Report what you observe clearly, include evidence where possible and escalate urgent issues immediately.',
    );
  }
}

class ExecutiveViewerCommandView extends StatelessWidget {
  const ExecutiveViewerCommandView({super.key, required this.onOpenModule});
  final ValueChanged<AppModule> onOpenModule;

  @override
  Widget build(BuildContext context) {
    final d = _CommandData.of(context);
    return _standard(
      d: d,
      eyebrow: 'EXECUTIVE BRIEF',
      title: 'Executive Viewer',
      subtitle: 'Campaign health, intelligence, incidents and reports at a glance.',
      icon: Icons.visibility_rounded,
      accent: const Color(0xFF475569),
      primaryTitle: 'Executive watchlist',
      primaryItems: d.incidents
          .take(5)
          .map((e) => _QueueItem(
                e.title,
                '${e.scope.label} • ${_nice(e.severity.name)}',
                Icons.visibility_outlined,
              ))
          .toList(),
      actions: [
        _Action('Election Intelligence', Icons.analytics_outlined,
            () => onOpenModule(AppModule.electionIntelligence)),
        _Action('Historical Elections', Icons.history_rounded,
            () => onOpenModule(AppModule.historicalElections)),
        _Action('Campaign Trends', Icons.trending_up_rounded,
            () => onOpenModule(AppModule.campaignTrends)),
        _Action('Reports', Icons.description_outlined,
            () => onOpenModule(AppModule.reportsDocuments)),
      ],
      doctrineTitle: 'Executive view',
      doctrine: 'Stay informed on campaign health, major issues and decisions without unnecessary operational detail.',
    );
  }
}

Widget _standard({
  required _CommandData d,
  required String eyebrow,
  required String title,
  required String subtitle,
  required IconData icon,
  required Color accent,
  required String primaryTitle,
  required List<_QueueItem> primaryItems,
  required List<_Action> actions,
  required String doctrineTitle,
  required String doctrine,
}) =>
    _CommandScaffold(
      eyebrow: eyebrow,
      title: title,
      subtitle: subtitle,
      icon: icon,
      accent: accent,
      badges: [eyebrow],
      metrics: [
        _Metric('Readiness', '${d.summary.averageReadiness.toStringAsFixed(0)}%',
            'Campaign coverage', Icons.speed_rounded),
        _Metric('Open incidents', '${d.summary.openIncidents}',
            'Issues needing attention', Icons.warning_amber_rounded),
        _Metric('Open tasks', '${d.summary.openTasks}',
            'Current work queue', Icons.task_alt_rounded),
        _Metric('Checked in', '${d.summary.checkedInAssignments}/${d.summary.assignments}',
            'Field presence', Icons.how_to_reg_rounded),
      ],
      primaryTitle: primaryTitle,
      primaryItems: primaryItems,
      secondaryTitle: 'Campaign health',
      secondary: _HealthPanel(data: d),
      actionTitle: 'Shortcuts',
      actions: actions,
      doctrineTitle: doctrineTitle,
      doctrine: doctrine,
    );

List<_Metric> _executiveMetrics(_CommandData d) => [
      _Metric('Campaign readiness', '${d.summary.averageReadiness.toStringAsFixed(0)}%',
          'Statewide coverage', Icons.speed_rounded),
      _Metric('Open incidents', '${d.summary.openIncidents}',
          'Issues needing attention', Icons.warning_amber_rounded),
      _Metric('Open tasks', '${d.summary.openTasks}',
          'Current work queue', Icons.task_alt_rounded),
      _Metric('Checked in', '${d.summary.checkedInAssignments}/${d.summary.assignments}',
          'Field presence', Icons.how_to_reg_rounded),
    ];

List<_QueueItem> _priorityItems(_CommandData d) => [
      ...d.incidents.take(4).map((e) => _QueueItem(
            e.title,
            '${e.scope.label} • ${_nice(e.severity.name)}',
            Icons.crisis_alert_outlined,
          )),
      ...d.tasks.take(3).map((e) => _QueueItem(
            e.title,
            '${e.scope.label} • ${_nice(e.status.name)}',
            Icons.task_outlined,
          )),
    ];

List<_QueueItem> _readinessItems(_CommandData d) {
  final readiness = [...d.readiness]
    ..sort((a, b) => a.agentCoveragePercent.compareTo(b.agentCoveragePercent));
  return readiness
      .take(8)
      .map((e) => _QueueItem(
            e.scope.lga ?? e.scope.label,
            '${e.agentCoveragePercent.toStringAsFixed(0)}% readiness • ${_nice(e.status.name)}',
            Icons.location_city_outlined,
          ))
      .toList();
}

class _CommandData {
  const _CommandData({
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

  static _CommandData of(BuildContext context) {
    final records = CampaignRecords.of(context);
    final scope = CampaignScope.of(context);
    final lgaId = scope.lgaId;
    final incidents = records.incidentsFor(lgaId).toList()
      ..sort((a, b) => _severityRank(b.severity).compareTo(_severityRank(a.severity)));
    final tasks = records.tasksFor(lgaId).toList()
      ..sort((a, b) => _severityRank(b.priority).compareTo(_severityRank(a.priority)));
    final reports = records.reportsFor(lgaId).toList()
      ..sort((a, b) => b.reportedAt.compareTo(a.reportedAt));
    final activities = records.activitiesFor(lgaId).toList()
      ..sort((a, b) => a.startsAt.compareTo(b.startsAt));
    return _CommandData(
      records: records,
      scope: scope,
      summary: records.summaryFor(lgaId),
      incidents: incidents,
      tasks: tasks,
      activities: activities,
      assets: records.assetsFor(lgaId),
      reports: reports,
      assignments: records.assignmentsFor(lgaId),
      readiness: records.readinessFor(lgaId),
    );
  }
}

class _CommandScaffold extends StatelessWidget {
  const _CommandScaffold({
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accent,
    required this.badges,
    required this.metrics,
    required this.primaryTitle,
    required this.primaryItems,
    required this.secondaryTitle,
    required this.secondary,
    required this.actionTitle,
    required this.actions,
    required this.doctrineTitle,
    required this.doctrine,
    this.extraSections = const [],
  });

  final String eyebrow;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accent;
  final List<String> badges;
  final List<_Metric> metrics;
  final String primaryTitle;
  final List<_QueueItem> primaryItems;
  final String secondaryTitle;
  final Widget secondary;
  final String actionTitle;
  final List<_Action> actions;
  final String doctrineTitle;
  final String doctrine;
  final List<Widget> extraSections;

  @override
  Widget build(BuildContext context) => ColoredBox(
        color: const Color(0xFFF3F6F3),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 22, 24, 38),
          children: [
            _Hero(
              eyebrow: eyebrow,
              title: title,
              subtitle: subtitle,
              icon: icon,
              accent: accent,
              badges: badges,
            ),
            const SizedBox(height: 16),
            _MetricGrid(metrics: metrics, accent: accent),
            const SizedBox(height: 16),
            _TwoPanel(
              left: _SimplePanel(
                title: primaryTitle,
                subtitle: 'Current items in your command view',
                items: primaryItems,
              ),
              right: _PanelCard(
                title: secondaryTitle,
                subtitle: 'Current campaign picture',
                child: secondary,
              ),
            ),
            for (final section in extraSections) ...[
              const SizedBox(height: 16),
              section,
            ],
            const SizedBox(height: 16),
            _ActionPanel(title: actionTitle, actions: actions),
            const SizedBox(height: 16),
            _Doctrine(title: doctrineTitle, text: doctrine),
          ],
        ),
      );
}

class _Hero extends StatelessWidget {
  const _Hero({
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accent,
    required this.badges,
  });

  final String eyebrow;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accent;
  final List<String> badges;

  @override
  Widget build(BuildContext context) {
    final session = CampaignSession.of(context);
    final scope = CampaignScope.of(context);
    return Container(
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          colors: [const Color(0xFF071C13), accent.withValues(alpha: .92)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(color: accent.withValues(alpha: .14), blurRadius: 30, offset: const Offset(0, 12)),
        ],
      ),
      child: LayoutBuilder(builder: (context, c) {
        final compact = c.maxWidth < 840;
        final copy = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: badges.map((b) => _HeroBadge(b)).toList(),
          ),
          const SizedBox(height: 18),
          Text(title,
              style: TextStyle(
                color: Colors.white,
                fontSize: compact ? 29 : 39,
                height: 1,
                fontWeight: FontWeight.w900,
                letterSpacing: -.8,
              )),
          const SizedBox(height: 9),
          Text(subtitle,
              style: const TextStyle(
                  color: Colors.white70,
                  height: 1.5,
                  fontWeight: FontWeight.w600)),
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
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .12),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(icon, color: Colors.white),
            ),
            const SizedBox(width: 10),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(session.operatorName,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
              const SizedBox(height: 3),
              SizedBox(
                width: compact ? 200 : 250,
                child: Text(scope.label,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white60, fontSize: 10.5)),
              ),
            ]),
          ]),
        );
        if (compact) {
          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            copy,
            const SizedBox(height: 18),
            identity,
          ]);
        }
        return Row(children: [Expanded(child: copy), const SizedBox(width: 22), identity]);
      }),
    );
  }
}

class _HeroBadge extends StatelessWidget {
  const _HeroBadge(this.label);
  final String label;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: .08),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: Colors.white.withValues(alpha: .12)),
        ),
        child: Text(label,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.w900,
                letterSpacing: .5)),
      );
}

class _Metric {
  const _Metric(this.label, this.value, this.detail, this.icon);
  final String label;
  final String value;
  final String detail;
  final IconData icon;
}

class _MetricGrid extends StatelessWidget {
  const _MetricGrid({required this.metrics, required this.accent});
  final List<_Metric> metrics;
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
                child: SectionCard(
                  padding: const EdgeInsets.all(16),
                  child: Row(children: [
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
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(m.value,
                            style: const TextStyle(
                                color: ink, fontSize: 19, fontWeight: FontWeight.w900)),
                        const SizedBox(height: 2),
                        Text(m.label,
                            style: const TextStyle(
                                color: ink, fontSize: 10.5, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 3),
                        Text(m.detail,
                            style: const TextStyle(color: muted, fontSize: 9.5, height: 1.25)),
                      ]),
                    ),
                  ]),
                ),
              )).toList(),
        );
      });
}

class _QueueItem {
  const _QueueItem(this.title, this.detail, this.icon);
  final String title;
  final String detail;
  final IconData icon;
}

class _SimplePanel extends StatelessWidget {
  const _SimplePanel({required this.title, required this.subtitle, required this.items});
  final String title;
  final String subtitle;
  final List<_QueueItem> items;

  @override
  Widget build(BuildContext context) => _PanelCard(
        title: title,
        subtitle: subtitle,
        child: Column(children: [
          if (items.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 22),
              child: Center(child: Text('No items at the moment.', style: TextStyle(color: muted))),
            )
          else
            ...items.map((item) => Container(
                  margin: const EdgeInsets.only(bottom: 9),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAF8),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE7ECE8)),
                  ),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(item.title,
                            style: const TextStyle(
                                color: ink, fontWeight: FontWeight.w800, fontSize: 11.5)),
                        const SizedBox(height: 3),
                        Text(item.detail,
                            style: const TextStyle(color: muted, height: 1.35, fontSize: 10)),
                      ]),
                    ),
                  ]),
                )),
        ]),
      );
}

class _PanelCard extends StatelessWidget {
  const _PanelCard({required this.title, required this.subtitle, required this.child});
  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) => SectionCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title,
              style: const TextStyle(color: ink, fontSize: 16.5, fontWeight: FontWeight.w900)),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(color: muted, fontSize: 10.5)),
          const SizedBox(height: 14),
          child,
        ]),
      );
}

class _TwoPanel extends StatelessWidget {
  const _TwoPanel({required this.left, required this.right});
  final Widget left;
  final Widget right;

  @override
  Widget build(BuildContext context) => LayoutBuilder(builder: (context, c) {
        if (c.maxWidth < 980) {
          return Column(children: [left, const SizedBox(height: 14), right]);
        }
        return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(flex: 13, child: left),
          const SizedBox(width: 14),
          Expanded(flex: 9, child: right),
        ]);
      });
}

class _HealthPanel extends StatelessWidget {
  const _HealthPanel({required this.data, this.compact = false});
  final _CommandData data;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final checkRate = data.summary.assignments == 0
        ? 0.0
        : data.summary.checkedInAssignments / data.summary.assignments;
    final trained = data.assignments.where((e) => e.trainingComplete).length;
    final trainingRate = data.assignments.isEmpty ? 0.0 : trained / data.assignments.length;
    final comms = data.readiness.where((e) => e.communicationReady).length;
    final commsRate = data.readiness.isEmpty ? 0.0 : comms / data.readiness.length;
    final logistics = data.readiness.where((e) => e.logisticsReady).length;
    final logisticsRate = data.readiness.isEmpty ? 0.0 : logistics / data.readiness.length;
    return Column(children: [
      _HealthBar('Field presence', checkRate),
      _HealthBar('Team preparation', trainingRate),
      _HealthBar('Communications', commsRate),
      _HealthBar('Logistics', logisticsRate),
      if (!compact) _HealthBar('Overall readiness', data.summary.averageReadiness / 100),
    ]);
  }
}

class _HealthBar extends StatelessWidget {
  const _HealthBar(this.label, this.value);
  final String label;
  final double value;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 13),
        child: Column(children: [
          Row(children: [
            Expanded(child: Text(label,
                style: const TextStyle(color: ink, fontSize: 10.5, fontWeight: FontWeight.w800))),
            Text('${(value * 100).toStringAsFixed(0)}%',
                style: const TextStyle(color: pdpGreen, fontSize: 10, fontWeight: FontWeight.w900)),
          ]),
          const SizedBox(height: 7),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: value.clamp(0, 1).toDouble(),
              minHeight: 7,
              backgroundColor: const Color(0xFFE7ECE8),
              valueColor: const AlwaysStoppedAnimation<Color>(pdpGreen),
            ),
          ),
        ]),
      );
}

class _DecisionPanel extends StatelessWidget {
  const _DecisionPanel({required this.data});
  final _CommandData data;

  @override
  Widget build(BuildContext context) => Column(children: [
        ...data.incidents.take(3).map((e) => _DecisionRow(
              title: e.title,
              detail: '${e.scope.label} • ${_nice(e.severity.name)}',
              icon: Icons.crisis_alert_outlined,
            )),
        ...data.tasks.take(3).map((e) => _DecisionRow(
              title: e.title,
              detail: '${e.scope.label} • ${_nice(e.status.name)}',
              icon: Icons.task_outlined,
            )),
      ]);
}

class _DecisionRow extends StatelessWidget {
  const _DecisionRow({required this.title, required this.detail, required this.icon});
  final String title;
  final String detail;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(icon, color: pdpGreen, size: 20),
          const SizedBox(width: 9),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(color: ink, fontWeight: FontWeight.w800)),
            const SizedBox(height: 3),
            Text(detail, style: const TextStyle(color: muted, fontSize: 10.5)),
          ])),
        ]),
      );
}

class _HotspotPanel extends StatelessWidget {
  const _HotspotPanel({required this.incidents});
  final List<CampaignIncident> incidents;

  @override
  Widget build(BuildContext context) {
    final grouped = <String, int>{};
    for (final incident in incidents) {
      final key = incident.scope.lga ?? 'Statewide';
      grouped[key] = (grouped[key] ?? 0) + 1;
    }
    final rows = grouped.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    return _PanelCard(
      title: 'Operational hotspots',
      subtitle: 'Areas with the most active incidents',
      child: Column(children: rows.take(7).map((row) => Padding(
            padding: const EdgeInsets.only(bottom: 11),
            child: Row(children: [
              const Icon(Icons.location_on_outlined, color: pdpRed, size: 20),
              const SizedBox(width: 8),
              Expanded(child: Text(row.key,
                  style: const TextStyle(color: ink, fontWeight: FontWeight.w800))),
              Text('${row.value}',
                  style: const TextStyle(color: pdpRed, fontWeight: FontWeight.w900)),
            ]),
          )).toList()),
    );
  }
}

class _ExecutiveBrief extends StatelessWidget {
  const _ExecutiveBrief({required this.data});
  final _CommandData data;

  @override
  Widget build(BuildContext context) => _PanelCard(
        title: 'Executive command brief',
        subtitle: 'Current statewide campaign picture',
        child: Text(
          'Campaign readiness is ${data.summary.averageReadiness.toStringAsFixed(0)}%. '
          '${data.summary.openIncidents} incidents and ${data.summary.openTasks} tasks remain open. '
          '${data.summary.checkedInAssignments} of ${data.summary.assignments} field assignments are currently checked in. '
          'Priority attention should remain on the lowest-readiness areas and unresolved high-severity incidents.',
          style: const TextStyle(color: ink, height: 1.55, fontSize: 12.5),
        ),
      );
}

class _Action {
  const _Action(this.label, this.icon, this.onTap);
  final String label;
  final IconData icon;
  final VoidCallback onTap;
}

class _ActionPanel extends StatelessWidget {
  const _ActionPanel({required this.title, required this.actions});
  final String title;
  final List<_Action> actions;

  @override
  Widget build(BuildContext context) => _PanelCard(
        title: title,
        subtitle: 'Open the next command area',
        child: LayoutBuilder(builder: (context, c) {
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
                        Icon(a.icon, color: pdpGreen, size: 22),
                        const SizedBox(height: 10),
                        Text(a.label,
                            style: const TextStyle(
                                color: ink, fontSize: 10.5, fontWeight: FontWeight.w900)),
                      ]),
                    ),
                  ),
                )).toList(),
          );
        }),
      );
}

class _Doctrine extends StatelessWidget {
  const _Doctrine({required this.title, required this.text});
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
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Icon(Icons.lightbulb_outline_rounded, color: pdpGreen),
          const SizedBox(width: 11),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(color: ink, fontWeight: FontWeight.w900)),
            const SizedBox(height: 3),
            Text(text, style: const TextStyle(color: muted, height: 1.4, fontSize: 11)),
          ])),
        ]),
      );
}

int _severityRank(IncidentSeverity severity) => switch (severity) {
      IncidentSeverity.critical => 5,
      IncidentSeverity.high => 4,
      IncidentSeverity.medium => 3,
      IncidentSeverity.low => 2,
      IncidentSeverity.info => 1,
    };

String _nice(String value) {
  final spaced = value.replaceAllMapped(
    RegExp(r'([a-z0-9])([A-Z])'),
    (m) => '${m.group(1)} ${m.group(2)}',
  );
  if (spaced.isEmpty) return spaced;
  return '${spaced[0].toUpperCase()}${spaced.substring(1)}';
}
