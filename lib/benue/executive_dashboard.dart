import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'app_scope.dart';
import 'campaign_identity.dart';
import 'data.dart';
import 'domain/geography_catalog.dart';
import 'domain/models.dart';
import 'domain/records_store.dart';
import 'session.dart';
import 'widgets.dart';

class ExecutiveDashboardPage extends StatelessWidget {
  const ExecutiveDashboardPage({
    super.key,
    this.onOpenMap,
    this.onOpenSituationRoom,
    this.onOpenCommunications,
    this.onOpenCampaignOperations,
    this.onOpenReports,
  });

  final VoidCallback? onOpenMap;
  final VoidCallback? onOpenSituationRoom;
  final VoidCallback? onOpenCommunications;
  final VoidCallback? onOpenCampaignOperations;
  final VoidCallback? onOpenReports;

  @override
  Widget build(BuildContext context) {
    final scope = CampaignScope.of(context);
    final records = CampaignRecords.of(context);
    final session = CampaignSession.of(context);
    final summary = records.summaryFor(scope.lgaId);
    final incidents = [...records.incidentsFor(scope.lgaId)]
      ..sort((a, b) => _severityRank(b.severity).compareTo(_severityRank(a.severity)));
    final activities = [...records.activitiesFor(scope.lgaId)]
      ..sort((a, b) => a.startsAt.compareTo(b.startsAt));

    return ColoredBox(
      color: const Color(0xFFF3F6F3),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 22, 24, 34),
        children: [
          _ExecutiveHero(
            scopeLabel: scope.label,
            operatorName: session.operatorName,
            role: session.role!,
            summary: summary,
          ),
          const SizedBox(height: 18),
          _KpiGrid(summary: summary, incidents: incidents),
          const SizedBox(height: 18),
          LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth >= 1020;
              final map = _CoverageSnapshot(
                activeLgaId: scope.lgaId,
                records: records,
                onOpenMap: onOpenMap,
              );
              final alerts = _PriorityAlerts(
                incidents: incidents,
                onOpenSituationRoom: onOpenSituationRoom,
              );
              if (!wide) {
                return Column(
                  children: [
                    map,
                    const SizedBox(height: 16),
                    alerts,
                  ],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 13, child: map),
                  const SizedBox(width: 16),
                  Expanded(flex: 9, child: alerts),
                ],
              );
            },
          ),
          const SizedBox(height: 18),
          LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth >= 1020;
              final momentum = const _MomentumPanel();
              final schedule = _SchedulePanel(activities: activities);
              if (!wide) {
                return Column(
                  children: [
                    momentum,
                    const SizedBox(height: 16),
                    schedule,
                  ],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: momentum),
                  const SizedBox(width: 16),
                  Expanded(child: schedule),
                ],
              );
            },
          ),
          const SizedBox(height: 18),
          _AiBrief(
            summary: summary,
            incidents: incidents,
            records: records,
            scope: scope,
          ),
          const SizedBox(height: 18),
          _QuickActions(
            onOpenMap: onOpenMap,
            onOpenSituationRoom: onOpenSituationRoom,
            onOpenCommunications: onOpenCommunications,
            onOpenCampaignOperations: onOpenCampaignOperations,
            onOpenReports: onOpenReports,
          ),
        ],
      ),
    );
  }
}

class _ExecutiveHero extends StatelessWidget {
  const _ExecutiveHero({
    required this.scopeLabel,
    required this.operatorName,
    required this.role,
    required this.summary,
  });

  final String scopeLabel;
  final String operatorName;
  final CampaignRole role;
  final CampaignRecordsSummary summary;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 850;
          final copy = _HeroCopy(
            scopeLabel: scopeLabel,
            operatorName: operatorName,
            role: role,
            summary: summary,
          );
          if (compact) {
            return Container(
              decoration: _heroDecoration(),
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 26, 24, 22),
                    child: copy,
                  ),
                  SizedBox(height: 280, child: _HeroPortrait(compact: true)),
                ],
              ),
            );
          }
          return Container(
            height: 350,
            decoration: _heroDecoration(),
            clipBehavior: Clip.antiAlias,
            child: Row(
              children: [
                Expanded(
                  flex: 13,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(34, 32, 20, 30),
                    child: copy,
                  ),
                ),
                const Expanded(flex: 7, child: _HeroPortrait()),
              ],
            ),
          );
        },
      );

  BoxDecoration _heroDecoration() => BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [Color(0xFF062C1A), Color(0xFF0B6C39), Color(0xFF0E8848)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: pdpGreenDark.withValues(alpha: .20),
            blurRadius: 30,
            offset: const Offset(0, 14),
          ),
        ],
      );
}

class _HeroCopy extends StatelessWidget {
  const _HeroCopy({
    required this.scopeLabel,
    required this.operatorName,
    required this.role,
    required this.summary,
  });

  final String scopeLabel;
  final String operatorName;
  final CampaignRole role;
  final CampaignRecordsSummary summary;

  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'Good morning'
        : hour < 17
            ? 'Good afternoon'
            : 'Good evening';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _HeroPill(icon: Icons.shield_outlined, text: 'PDP COMMAND CENTRE'),
            _HeroPill(icon: Icons.location_on_outlined, text: scopeLabel.toUpperCase()),
          ],
        ),
        const SizedBox(height: 22),
        Text(
          '$greeting, $operatorName',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 7),
        Text(
          CampaignIdentity.candidateName,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 31,
            height: 1.04,
            fontWeight: FontWeight.w900,
            letterSpacing: -.6,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Benue Governorship Campaign • Executive Command Overview',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Spacer(),
        Wrap(
          spacing: 20,
          runSpacing: 10,
          children: [
            _HeroMetric(value: '${summary.assignments}', label: 'Field assignments'),
            _HeroMetric(value: '${summary.openIncidents}', label: 'Open incidents'),
            _HeroMetric(
              value: '${summary.averageReadiness.toStringAsFixed(0)}%',
              label: 'Readiness',
            ),
            _HeroMetric(value: roleLabel(role), label: 'Current role', compact: true),
          ],
        ),
      ],
    );
  }
}

class _HeroPortrait extends StatelessWidget {
  const _HeroPortrait({this.compact = false});
  final bool compact;

  @override
  Widget build(BuildContext context) => Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0x00000000), Color(0x28000000)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Positioned(
            left: compact ? 18 : 12,
            right: compact ? 18 : 28,
            top: compact ? 10 : 18,
            bottom: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(compact ? 24 : 30),
                topRight: Radius.circular(compact ? 24 : 30),
              ),
              child: Image.asset(
                CampaignIdentity.portraitAsset,
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.white10,
                  alignment: Alignment.center,
                  child: const Icon(Icons.person_rounded, size: 120, color: Colors.white54),
                ),
              ),
            ),
          ),
          Positioned(
            right: 18,
            bottom: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .92),
                borderRadius: BorderRadius.circular(999),
                boxShadow: const [
                  BoxShadow(color: Color(0x22000000), blurRadius: 12, offset: Offset(0, 5)),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.circle, size: 9, color: Color(0xFF22A35A)),
                  SizedBox(width: 6),
                  Text('Campaign Command Active',
                      style: TextStyle(color: ink, fontSize: 11, fontWeight: FontWeight.w900)),
                ],
              ),
            ),
          ),
        ],
      );
}

class _HeroPill extends StatelessWidget {
  const _HeroPill({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: .10),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: Colors.white.withValues(alpha: .15)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: Colors.white70),
            const SizedBox(width: 6),
            Text(text,
                style: const TextStyle(
                    color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: .6)),
          ],
        ),
      );
}

class _HeroMetric extends StatelessWidget {
  const _HeroMetric({required this.value, required this.label, this.compact = false});
  final String value;
  final String label;
  final bool compact;

  @override
  Widget build(BuildContext context) => ConstrainedBox(
        constraints: BoxConstraints(maxWidth: compact ? 180 : 110),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontSize: compact ? 14 : 21,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 2),
            Text(label,
                style: const TextStyle(color: Colors.white60, fontSize: 10, fontWeight: FontWeight.w700)),
          ],
        ),
      );
}

class _KpiGrid extends StatelessWidget {
  const _KpiGrid({required this.summary, required this.incidents});
  final CampaignRecordsSummary summary;
  final List<CampaignIncident> incidents;

  @override
  Widget build(BuildContext context) {
    final critical = incidents
        .where((incident) =>
            incident.severity == IncidentSeverity.critical || incident.severity == IncidentSeverity.high)
        .length;
    final checkInRate = summary.assignments == 0
        ? 0
        : ((summary.checkedInAssignments / summary.assignments) * 100).round();
    final cards = <Widget>[
      _ExecutiveKpi(
        label: 'Campaign readiness',
        value: '${summary.averageReadiness.toStringAsFixed(0)}%',
        footnote: 'Operational coverage index',
        icon: Icons.speed_rounded,
        accent: pdpGreen,
        progress: summary.averageReadiness / 100,
      ),
      _ExecutiveKpi(
        label: 'Field assignments',
        value: '${summary.assignments}',
        footnote: '$checkInRate% currently checked in',
        icon: Icons.groups_2_outlined,
        accent: const Color(0xFF3267D6),
        progress: checkInRate / 100,
      ),
      _ExecutiveKpi(
        label: 'Priority alerts',
        value: '$critical',
        footnote: '${summary.openIncidents} incidents open',
        icon: Icons.notification_important_outlined,
        accent: const Color(0xFFD97706),
        progress: math.min(1.0, critical / 8),
      ),
      _ExecutiveKpi(
        label: 'Operational tasks',
        value: '${summary.openTasks}',
        footnote: '${summary.readyAssets}/${summary.assets} assets ready',
        icon: Icons.task_alt_rounded,
        accent: const Color(0xFF7C3AED),
        progress: summary.assets == 0 ? 0.0 : summary.readyAssets / summary.assets,
      ),
    ];
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 1080
            ? 4
            : constraints.maxWidth >= 650
                ? 2
                : 1;
        const gap = 14.0;
        final width = (constraints.maxWidth - gap * (columns - 1)) / columns;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: cards.map((card) => SizedBox(width: width, child: card)).toList(),
        );
      },
    );
  }
}

class _ExecutiveKpi extends StatelessWidget {
  const _ExecutiveKpi({
    required this.label,
    required this.value,
    required this.footnote,
    required this.icon,
    required this.accent,
    required this.progress,
  });

  final String label;
  final String value;
  final String footnote;
  final IconData icon;
  final Color accent;
  final double progress;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE2E9E3)),
          boxShadow: const [
            BoxShadow(color: Color(0x09000000), blurRadius: 18, offset: Offset(0, 8)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: .10),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Icon(icon, color: accent, size: 22),
                ),
                const Spacer(),
                Icon(Icons.more_horiz_rounded, color: muted.withValues(alpha: .6), size: 20),
              ],
            ),
            const SizedBox(height: 16),
            Text(value,
                style: const TextStyle(color: ink, fontSize: 27, fontWeight: FontWeight.w900, letterSpacing: -.4)),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(color: ink, fontWeight: FontWeight.w800, fontSize: 13)),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: LinearProgressIndicator(
                value: progress.clamp(0.0, 1.0).toDouble(),
                minHeight: 6,
                backgroundColor: const Color(0xFFEDF1EE),
                valueColor: AlwaysStoppedAnimation<Color>(accent),
              ),
            ),
            const SizedBox(height: 8),
            Text(footnote, style: const TextStyle(color: muted, fontSize: 11, fontWeight: FontWeight.w600)),
          ],
        ),
      );
}

class _CoverageSnapshot extends StatelessWidget {
  const _CoverageSnapshot({
    required this.activeLgaId,
    required this.records,
    required this.onOpenMap,
  });

  final String? activeLgaId;
  final CampaignRecordsController records;
  final VoidCallback? onOpenMap;

  @override
  Widget build(BuildContext context) {
    final tiles = BenueBaseGeography.lgas.map((lga) {
      final readiness = records.readinessFor(lga.id);
      final value = readiness.isEmpty ? 0.0 : readiness.first.agentCoveragePercent;
      final color = value >= 75
          ? pdpGreen
          : value >= 50
              ? const Color(0xFFD99A13)
              : pdpRed;
      final selected = lga.id == activeLgaId;
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? color.withValues(alpha: .13) : const Color(0xFFF6F8F6),
          borderRadius: BorderRadius.circular(11),
          border: Border.all(color: selected ? color : const Color(0xFFE7ECE8)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 7, height: 7, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
            const SizedBox(width: 6),
            Text(lga.name,
                style: TextStyle(
                    color: ink,
                    fontSize: 11,
                    fontWeight: selected ? FontWeight.w900 : FontWeight.w700)),
            const SizedBox(width: 6),
            Text('${value.toStringAsFixed(0)}%',
                style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w900)),
          ],
        ),
      );
    }).toList();

    return _DashboardCard(
      title: 'Benue operational coverage',
      subtitle: '23 LGA readiness snapshot • prototype records',
      trailing: TextButton.icon(
        onPressed: onOpenMap,
        icon: const Icon(Icons.map_outlined, size: 17),
        label: const Text('Open map'),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFF1F8F3), Color(0xFFFFFAF8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFE1EAE3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.travel_explore_rounded, color: pdpGreen, size: 23),
                    SizedBox(width: 9),
                    Text('State command geography',
                        style: TextStyle(color: ink, fontSize: 14, fontWeight: FontWeight.w900)),
                  ],
                ),
                const SizedBox(height: 14),
                Wrap(spacing: 7, runSpacing: 7, children: tiles),
              ],
            ),
          ),
          const SizedBox(height: 13),
          const Wrap(
            spacing: 16,
            runSpacing: 7,
            children: [
              _LegendDot(color: pdpGreen, text: '75%+ readiness'),
              _LegendDot(color: Color(0xFFD99A13), text: '50–74%'),
              _LegendDot(color: pdpRed, text: 'Below 50%'),
            ],
          ),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.text});
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 6),
          Text(text, style: const TextStyle(color: muted, fontSize: 10, fontWeight: FontWeight.w700)),
        ],
      );
}

class _PriorityAlerts extends StatelessWidget {
  const _PriorityAlerts({required this.incidents, required this.onOpenSituationRoom});
  final List<CampaignIncident> incidents;
  final VoidCallback? onOpenSituationRoom;

  @override
  Widget build(BuildContext context) => _DashboardCard(
        title: 'Priority alerts',
        subtitle: 'What needs executive attention now',
        trailing: TextButton(
          onPressed: onOpenSituationRoom,
          child: const Text('Situation Room'),
        ),
        child: Column(
          children: incidents.take(5).map((incident) {
            final color = _severityColor(incident.severity);
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: .055),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: color.withValues(alpha: .13)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(color: color.withValues(alpha: .11), borderRadius: BorderRadius.circular(10)),
                      child: Icon(Icons.priority_high_rounded, color: color, size: 18),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(incident.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: ink, fontSize: 12, fontWeight: FontWeight.w900)),
                          const SizedBox(height: 4),
                          Text('${incident.scope.lga ?? 'State'} • ${incident.category}',
                              style: const TextStyle(color: muted, fontSize: 10, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    StatusPill(_enumLabel(incident.severity).toUpperCase(), color: color),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      );
}

class _MomentumPanel extends StatelessWidget {
  const _MomentumPanel();

  @override
  Widget build(BuildContext context) {
    final values = campaignTrend.map((point) => point.value).toList();
    final latest = values.last;
    final gain = latest - values.first;
    return _DashboardCard(
      title: 'Campaign momentum',
      subtitle: 'Prototype composite index • 8-week view',
      trailing: StatusPill('+${gain.toStringAsFixed(0)} pts', color: pdpGreen),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(latest.toStringAsFixed(0),
                  style: const TextStyle(color: ink, fontSize: 37, height: 1, fontWeight: FontWeight.w900)),
              const SizedBox(width: 7),
              const Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Text('/ 100', style: TextStyle(color: muted, fontWeight: FontWeight.w700)),
              ),
              const Spacer(),
              const Icon(Icons.trending_up_rounded, color: pdpGreen),
            ],
          ),
          const SizedBox(height: 16),
          MiniLineChart(values: values, height: 155),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: campaignTrend
                .map((point) => Text(point.label,
                    style: const TextStyle(color: muted, fontSize: 9, fontWeight: FontWeight.w700)))
                .toList(),
          ),
          const SizedBox(height: 12),
          const _PrototypeNote(
            text: 'Momentum is demonstration data until verified field, media and campaign activity feeds are connected.',
          ),
        ],
      ),
    );
  }
}

class _SchedulePanel extends StatelessWidget {
  const _SchedulePanel({required this.activities});
  final List<CampaignActivity> activities;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = activities
        .where((activity) =>
            activity.startsAt.year == now.year &&
            activity.startsAt.month == now.month &&
            activity.startsAt.day == now.day)
        .toList();
    final shown = (today.isNotEmpty ? today : activities).take(5).toList();
    return _DashboardCard(
      title: today.isNotEmpty ? "Today's programme" : 'Upcoming programme',
      subtitle: today.isNotEmpty ? 'Campaign schedule for today' : 'Next scheduled campaign activities',
      trailing: const Icon(Icons.calendar_month_outlined, color: pdpGreen),
      child: Column(
        children: shown.isEmpty
            ? const [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 34),
                  child: Text('No scheduled activities in the active scope.', style: TextStyle(color: muted)),
                )
              ]
            : shown.asMap().entries.map((entry) {
                final activity = entry.value;
                final time = TimeOfDay.fromDateTime(activity.startsAt.toLocal()).format(context);
                final last = entry.key == shown.length - 1;
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 66,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(time,
                            style: const TextStyle(color: pdpGreenDark, fontSize: 11, fontWeight: FontWeight.w900)),
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(color: pdpGreen, shape: BoxShape.circle),
                        ),
                        if (!last)
                          Container(width: 2, height: 49, color: const Color(0xFFDDE7DF)),
                      ],
                    ),
                    const SizedBox(width: 11),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: last ? 0 : 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(activity.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: ink, fontSize: 12, fontWeight: FontWeight.w900)),
                            const SizedBox(height: 3),
                            Text('${activity.scope.lga ?? 'Statewide'} • ${activity.category}',
                                style: const TextStyle(color: muted, fontSize: 10, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
      ),
    );
  }
}

class _AiBrief extends StatelessWidget {
  const _AiBrief({
    required this.summary,
    required this.incidents,
    required this.records,
    required this.scope,
  });

  final CampaignRecordsSummary summary;
  final List<CampaignIncident> incidents;
  final CampaignRecordsController records;
  final CampaignScopeController scope;

  @override
  Widget build(BuildContext context) {
    final attention = BenueBaseGeography.lgas
        .map((lga) {
          final readiness = records.readinessFor(lga.id);
          return MapEntry(lga.name, readiness.isEmpty ? 0.0 : readiness.first.agentCoveragePercent);
        })
        .toList()
      ..sort((a, b) => a.value.compareTo(b.value));
    final topAttention = attention.take(3).map((item) => item.key).join(', ');
    final highAlerts = incidents
        .where((item) =>
            item.severity == IncidentSeverity.critical || item.severity == IncidentSeverity.high)
        .length;

    final brief = scope.isStatewide
        ? 'Statewide readiness currently averages ${summary.averageReadiness.toStringAsFixed(0)}%. '
            '$highAlerts high-priority incidents require command attention, while ${summary.checkedInAssignments} of '
            '${summary.assignments} field assignments are checked in. Current prototype records place the lowest readiness attention on '
            '$topAttention. Review verified field evidence before taking consequential action.'
        : '${scope.label} readiness is ${summary.averageReadiness.toStringAsFixed(0)}%, with ${summary.openIncidents} open incidents '
            'and ${summary.openTasks} active tasks. ${summary.checkedInAssignments} field assignment(s) are checked in. '
            'This brief is generated only from operational records visible in the current scope.';

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          colors: [Color(0xFF10271D), Color(0xFF163F2B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const [
          BoxShadow(color: Color(0x15000000), blurRadius: 22, offset: Offset(0, 10)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .10),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(Icons.auto_awesome_rounded, color: Color(0xFFFFD467)),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Text('AI Command Brief',
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900)),
                    SizedBox(width: 8),
                    StatusPill('PROTOTYPE SYNTHESIS', color: Color(0xFFFFD467)),
                  ],
                ),
                const SizedBox(height: 9),
                Text(brief,
                    style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.55, fontWeight: FontWeight.w600)),
                const SizedBox(height: 10),
                const Text(
                  'Uses campaign operational records only • Human review required',
                  style: TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({
    required this.onOpenMap,
    required this.onOpenSituationRoom,
    required this.onOpenCommunications,
    required this.onOpenCampaignOperations,
    required this.onOpenReports,
  });

  final VoidCallback? onOpenMap;
  final VoidCallback? onOpenSituationRoom;
  final VoidCallback? onOpenCommunications;
  final VoidCallback? onOpenCampaignOperations;
  final VoidCallback? onOpenReports;

  @override
  Widget build(BuildContext context) {
    final actions = [
      _ActionData('Benue Map', 'Coverage & geography', Icons.map_outlined, pdpGreen, onOpenMap),
      _ActionData('Situation Room', 'Incidents & command', Icons.radar_rounded, pdpRed, onOpenSituationRoom),
      _ActionData('Communications', 'Teams & incident rooms', Icons.forum_outlined, const Color(0xFF3267D6), onOpenCommunications),
      _ActionData('Campaign Ops', 'Activities & field teams', Icons.campaign_outlined, const Color(0xFF7C3AED), onOpenCampaignOperations),
      _ActionData('Reports', 'Briefings & documents', Icons.description_outlined, const Color(0xFFD97706), onOpenReports),
    ];
    return _DashboardCard(
      title: 'Quick actions',
      subtitle: 'Move directly into the command workflow',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final columns = constraints.maxWidth >= 950
              ? 5
              : constraints.maxWidth >= 620
                  ? 3
                  : 1;
          const gap = 10.0;
          final width = (constraints.maxWidth - gap * (columns - 1)) / columns;
          return Wrap(
            spacing: gap,
            runSpacing: gap,
            children: actions.map((action) {
              return SizedBox(
                width: width,
                child: InkWell(
                  onTap: action.onTap,
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: action.color.withValues(alpha: .055),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: action.color.withValues(alpha: .12)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: action.color.withValues(alpha: .10),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(action.icon, color: action.color, size: 20),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(action.title,
                                  style: const TextStyle(color: ink, fontSize: 11, fontWeight: FontWeight.w900)),
                              const SizedBox(height: 2),
                              Text(action.subtitle,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(color: muted, fontSize: 9, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios_rounded, size: 11, color: action.color),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

class _ActionData {
  const _ActionData(this.title, this.subtitle, this.icon, this.color, this.onTap);
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;
}

class _DashboardCard extends StatelessWidget {
  const _DashboardCard({
    required this.title,
    required this.subtitle,
    required this.child,
    this.trailing,
  });

  final String title;
  final String subtitle;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xFFE2E9E3)),
          boxShadow: const [
            BoxShadow(color: Color(0x09000000), blurRadius: 20, offset: Offset(0, 8)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: const TextStyle(color: ink, fontSize: 15, fontWeight: FontWeight.w900)),
                      const SizedBox(height: 3),
                      Text(subtitle,
                          style: const TextStyle(color: muted, fontSize: 11, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
            const SizedBox(height: 17),
            child,
          ],
        ),
      );
}

class _PrototypeNote extends StatelessWidget {
  const _PrototypeNote({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF8E8),
          borderRadius: BorderRadius.circular(11),
          border: Border.all(color: const Color(0xFFF6E4B5)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.science_outlined, size: 15, color: Color(0xFF9A6A05)),
            const SizedBox(width: 7),
            Expanded(
              child: Text(text,
                  style: const TextStyle(color: Color(0xFF79550A), fontSize: 9.5, height: 1.35, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      );
}

int _severityRank(IncidentSeverity severity) => switch (severity) {
      IncidentSeverity.critical => 5,
      IncidentSeverity.high => 4,
      IncidentSeverity.medium => 3,
      IncidentSeverity.low => 2,
      IncidentSeverity.info => 1,
    };

Color _severityColor(IncidentSeverity severity) => switch (severity) {
      IncidentSeverity.critical => pdpRed,
      IncidentSeverity.high => const Color(0xFFD97706),
      IncidentSeverity.medium => const Color(0xFF7C3AED),
      IncidentSeverity.low => const Color(0xFF3267D6),
      IncidentSeverity.info => pdpGreen,
    };

String _enumLabel(Object value) {
  final raw = value.toString().split('.').last;
  return raw
      .replaceAllMapped(RegExp(r'([a-z])([A-Z])'), (m) => '${m[1]} ${m[2]}')
      .replaceFirstMapped(RegExp(r'^.'), (m) => m[0]!.toUpperCase());
}
