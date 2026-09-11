import 'package:flutter/material.dart';
import 'package:polisphere/src/theme/app_theme.dart';

/// Every operational role PoliSphere is used by. Determines which shell a
/// signed-in user lands on, which Situation Room sections they can see, and
/// whether they can perform write actions (acknowledge, call, assign, etc.)
/// or only observe.
enum AppRole {
  roomCommander,
  situationRoomSupervisor,
  situationRoomObserver,
  coordinator,
  secretary,
  agent,
  candidate,
  dgCampaign,
}

extension AppRoleData on AppRole {
  String get label => switch (this) {
        AppRole.roomCommander => 'Room Commander',
        AppRole.situationRoomSupervisor => 'Situation Room Supervisor',
        AppRole.situationRoomObserver => 'Situation Room Observer',
        AppRole.coordinator => 'Coordinator',
        AppRole.secretary => 'Secretary',
        AppRole.agent => 'Agent',
        AppRole.candidate => 'Candidate',
        AppRole.dgCampaign => 'DG Campaign',
      };

  String get description => switch (this) {
        AppRole.roomCommander =>
          'Full command of the Situation Room: every console, every action.',
        AppRole.situationRoomSupervisor =>
          'Runs day-to-day Situation Room operations across all consoles.',
        AppRole.situationRoomObserver =>
          'Read-only visibility into Situation Room consoles.',
        AppRole.coordinator =>
          'Coordinates field response: incidents, verification and agents.',
        AppRole.secretary =>
          'Administrative record-keeping: briefs, comms and evidence filing.',
        AppRole.agent => 'Field operative using the mobile field-agent app.',
        AppRole.candidate =>
          'High-level, read-only view of campaign situational awareness.',
        AppRole.dgCampaign =>
          'Senior campaign leadership view across strategic consoles.',
      };

  IconData get icon => switch (this) {
        AppRole.roomCommander => Icons.shield_outlined,
        AppRole.situationRoomSupervisor => Icons.supervisor_account_outlined,
        AppRole.situationRoomObserver => Icons.visibility_outlined,
        AppRole.coordinator => Icons.hub_outlined,
        AppRole.secretary => Icons.edit_note_outlined,
        AppRole.agent => Icons.person_pin_circle_outlined,
        AppRole.candidate => Icons.person_outline_rounded,
        AppRole.dgCampaign => Icons.workspace_premium_outlined,
      };

  /// Demo display name used while there is no real authentication backend.
  String get demoUserName => switch (this) {
        AppRole.roomCommander => 'Sani Shuaibu',
        AppRole.situationRoomSupervisor => 'Ifeoma Bello',
        AppRole.situationRoomObserver => 'Guest Observer',
        AppRole.coordinator => 'Chidi Nwosu',
        AppRole.secretary => 'Grace Adeyemi',
        AppRole.agent => 'Amina Yusuf',
        AppRole.candidate => 'Hon. Aisha Bello',
        AppRole.dgCampaign => 'Chief Emeka Umeh',
      };

  /// Accent color used to badge this role on the sign-in screen.
  Color get accentColor => switch (this) {
        AppRole.roomCommander => AppColors.bronze,
        AppRole.situationRoomSupervisor => AppColors.emerald,
        AppRole.situationRoomObserver => AppColors.slate,
        AppRole.coordinator => AppColors.copper,
        AppRole.secretary => AppColors.maroon,
        AppRole.agent => AppColors.sage,
        AppRole.candidate => AppColors.indigo,
        AppRole.dgCampaign => AppColors.bronzeLight,
      };

  /// Field-agent roles use the narrow mobile app shell; every other role
  /// works from the desktop Situation Room command center.
  bool get usesFieldApp => this == AppRole.agent;

  /// Ward coordinators and Situation Room command staff may create campaign
  /// groups; every other role can only see and use existing ones.
  bool get canManageGroups => switch (this) {
        AppRole.roomCommander => true,
        AppRole.situationRoomSupervisor => true,
        AppRole.coordinator => true,
        _ => false,
      };

  /// Whether this role may perform write actions (acknowledge alerts,
  /// place calls, request reports, assign agents) or only observe.
  bool get canEdit => switch (this) {
        AppRole.situationRoomObserver => false,
        AppRole.candidate => false,
        AppRole.dgCampaign => false,
        _ => true,
      };

  /// Situation Room sidebar sections this role is allowed to see, matching
  /// the labels used in `_SituationRoomPageState._nav`.
  List<String> get situationRoomSections => switch (this) {
        AppRole.roomCommander ||
        AppRole.situationRoomSupervisor ||
        AppRole.situationRoomObserver =>
          const [
            'Command',
            'Live map',
            'Incidents',
            'Verification',
            'Agents',
            'Communications',
            'Meetings',
            'Evidence',
            'Alerts',
            'Social pulse',
            'Daily brief',
            'AI intelligence',
          ],
        AppRole.coordinator => const [
            'Command',
            'Live map',
            'Incidents',
            'Verification',
            'Agents',
            'Communications',
            'Meetings',
            'Alerts',
          ],
        AppRole.secretary => const [
            'Command',
            'Communications',
            'Meetings',
            'Evidence',
            'Alerts',
            'Daily brief',
          ],
        AppRole.candidate => const [
            'Command',
            'Social pulse',
            'Daily brief',
            'AI intelligence',
          ],
        AppRole.dgCampaign => const [
            'Command',
            'Live map',
            'Social pulse',
            'Daily brief',
            'AI intelligence',
            'Alerts',
          ],
        AppRole.agent => const [],
      };
}
