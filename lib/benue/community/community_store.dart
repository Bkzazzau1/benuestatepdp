import 'dart:typed_data';

import 'package:flutter/widgets.dart';

import '../domain/geography_catalog.dart';
import '../domain/models.dart';


enum ForumPostKind { discussion, debate, experience, question, announcement }
enum CommunityMediaType { image, video, document, other }
enum MeetingAudienceMode { assignments, location, group }
enum MeetingStatus { scheduled, live, completed, cancelled }

class CommunityMedia {
  const CommunityMedia({
    required this.id,
    required this.type,
    required this.fileName,
    this.bytes,
    this.caption,
  });

  final String id;
  final CommunityMediaType type;
  final String fileName;
  final Uint8List? bytes;
  final String? caption;
}

class ForumComment {
  const ForumComment({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.authorRole,
    required this.scope,
    required this.body,
    required this.createdAt,
    this.attachments = const [],
    this.replyToCommentId,
  });

  final String id;
  final String authorId;
  final String authorName;
  final CampaignRole authorRole;
  final GeographicScope scope;
  final String body;
  final DateTime createdAt;
  final List<CommunityMedia> attachments;
  final String? replyToCommentId;
}

class ForumPost {
  const ForumPost({
    required this.id,
    required this.kind,
    required this.authorId,
    required this.authorName,
    required this.authorRole,
    required this.scope,
    required this.body,
    required this.createdAt,
    this.attachments = const [],
    this.comments = const [],
    this.reactionUserIds = const {},
    this.prototypeSeed = false,
  });

  final String id;
  final ForumPostKind kind;
  final String authorId;
  final String authorName;
  final CampaignRole authorRole;
  final GeographicScope scope;
  final String body;
  final DateTime createdAt;
  final List<CommunityMedia> attachments;
  final List<ForumComment> comments;
  final Set<String> reactionUserIds;
  final bool prototypeSeed;

  ForumPost copyWith({
    List<ForumComment>? comments,
    Set<String>? reactionUserIds,
  }) =>
      ForumPost(
        id: id,
        kind: kind,
        authorId: authorId,
        authorName: authorName,
        authorRole: authorRole,
        scope: scope,
        body: body,
        createdAt: createdAt,
        attachments: attachments,
        comments: comments ?? this.comments,
        reactionUserIds: reactionUserIds ?? this.reactionUserIds,
        prototypeSeed: prototypeSeed,
      );
}

class CampaignGroup {
  const CampaignGroup({
    required this.id,
    required this.name,
    required this.scope,
    required this.memberIds,
    required this.description,
  });

  final String id;
  final String name;
  final GeographicScope scope;
  final List<String> memberIds;
  final String description;
}

class CampaignMeeting {
  const CampaignMeeting({
    required this.id,
    required this.title,
    required this.agenda,
    required this.organizerId,
    required this.organizerName,
    required this.organizerRole,
    required this.organizerScope,
    required this.audienceMode,
    required this.participantIds,
    required this.participantNames,
    required this.startsAt,
    required this.durationMinutes,
    required this.status,
    required this.createdAt,
    this.groupId,
    this.prototypeSeed = false,
  });

  final String id;
  final String title;
  final String agenda;
  final String organizerId;
  final String organizerName;
  final CampaignRole organizerRole;
  final GeographicScope organizerScope;
  final MeetingAudienceMode audienceMode;
  final List<String> participantIds;
  final List<String> participantNames;
  final DateTime startsAt;
  final int durationMinutes;
  final MeetingStatus status;
  final DateTime createdAt;
  final String? groupId;
  final bool prototypeSeed;

  CampaignMeeting copyWith({MeetingStatus? status}) => CampaignMeeting(
        id: id,
        title: title,
        agenda: agenda,
        organizerId: organizerId,
        organizerName: organizerName,
        organizerRole: organizerRole,
        organizerScope: organizerScope,
        audienceMode: audienceMode,
        participantIds: participantIds,
        participantNames: participantNames,
        startsAt: startsAt,
        durationMinutes: durationMinutes,
        status: status ?? this.status,
        createdAt: createdAt,
        groupId: groupId,
        prototypeSeed: prototypeSeed,
      );
}

class CampaignCommunityController extends ChangeNotifier {
  CampaignCommunityController._({
    required List<ForumPost> posts,
    required List<CampaignGroup> groups,
    required List<CampaignMeeting> meetings,
  })  : _posts = posts,
        _groups = groups,
        _meetings = meetings;

  factory CampaignCommunityController.prototypeSeed() {
    final base = DateTime.utc(2026, 9, 11, 10);
    final lgaCoordinatorIds = BenueBaseGeography.lgas
        .map((lga) => 'USR-${lga.id}-COORD')
        .toList(growable: false);
    final stateRoleIds = <String>[
      'ROLE-candidate',
      'ROLE-directorGeneral',
      'ROLE-stateAdministrator',
      'ROLE-operationsOfficer',
    ];

    final groups = <CampaignGroup>[
      CampaignGroup(
        id: 'GRP-BEN-STATE-COORD',
        name: 'Benue State Coordination Council',
        scope: GeographicScope.benueState,
        memberIds: [...stateRoleIds, ...lgaCoordinatorIds],
        description:
            'Prototype cross-LGA coordination group. Explicit membership allows meetings across normal location boundaries.',
      ),
      CampaignGroup(
        id: 'GRP-BEN-SITUATION',
        name: 'State Situation & Response Group',
        scope: GeographicScope.benueState,
        memberIds: [
          'ROLE-directorGeneral',
          'ROLE-situationRoomDirector',
          'ROLE-stateAdministrator',
          'ROLE-operationsOfficer',
        ],
        description:
            'Prototype state response group for incident coordination.',
      ),
    ];

    final posts = <ForumPost>[
      ForumPost(
        id: 'POST-BEN-0001',
        kind: ForumPostKind.experience,
        authorId: 'USR-BEN-LGA-13-COORD',
        authorName: 'Makurdi Coordinator Seat',
        authorRole: CampaignRole.lgaCoordinator,
        scope: const GeographicScope(
          level: GeographyLevel.lga,
          state: 'Benue',
          lgaId: 'BEN-LGA-13',
          lga: 'Makurdi',
        ),
        body:
            'Field experience thread: share what is working in local coordination, what is blocking teams and what state command should understand before the next review.',
        createdAt: base,
        comments: [
          ForumComment(
            id: 'CMT-BEN-0001',
            authorId: 'USR-BEN-LGA-05-COORD',
            authorName: 'Gboko Coordinator Seat',
            authorRole: CampaignRole.lgaCoordinator,
            scope: const GeographicScope(
              level: GeographyLevel.lga,
              state: 'Benue',
              lgaId: 'BEN-LGA-05',
              lga: 'Gboko',
            ),
            body:
                'Structured follow-up after activities has helped us identify unresolved logistics issues earlier.',
            createdAt: base.add(const Duration(minutes: 18)),
          ),
        ],
        reactionUserIds: const {'ROLE-directorGeneral'},
        prototypeSeed: true,
      ),
      ForumPost(
        id: 'POST-BEN-0002',
        kind: ForumPostKind.debate,
        authorId: 'ROLE-operationsOfficer',
        authorName: 'Operations Officer',
        authorRole: CampaignRole.operationsOfficer,
        scope: GeographicScope.benueState,
        body:
            'Debate: should every campaign activity close with a same-day field report, or should low-risk activities use a shorter weekly summary?',
        createdAt: base.add(const Duration(hours: 1)),
        prototypeSeed: true,
      ),
    ];

    final meetings = <CampaignMeeting>[
      CampaignMeeting(
        id: 'MTG-BEN-0001',
        title: 'State coordination review',
        agenda: 'Readiness exceptions, open incidents and next activity cycle.',
        organizerId: 'ROLE-directorGeneral',
        organizerName: 'Director General',
        organizerRole: CampaignRole.directorGeneral,
        organizerScope: GeographicScope.benueState,
        audienceMode: MeetingAudienceMode.group,
        participantIds: lgaCoordinatorIds.take(6).toList(growable: false),
        participantNames: BenueBaseGeography.lgas
            .take(6)
            .map((lga) => '${lga.name} Coordinator Seat')
            .toList(growable: false),
        startsAt: base.add(const Duration(days: 1, hours: 2)),
        durationMinutes: 45,
        status: MeetingStatus.scheduled,
        createdAt: base,
        groupId: 'GRP-BEN-STATE-COORD',
        prototypeSeed: true,
      ),
    ];

    return CampaignCommunityController._(
      posts: posts,
      groups: groups,
      meetings: meetings,
    );
  }

  final List<ForumPost> _posts;
  final List<CampaignGroup> _groups;
  final List<CampaignMeeting> _meetings;
  int _postSequence = 2;
  int _commentSequence = 1;
  int _meetingSequence = 1;
  int _mediaSequence = 0;

  List<ForumPost> get posts => List.unmodifiable(_posts);
  List<CampaignGroup> get groups => List.unmodifiable(_groups);
  List<CampaignMeeting> get meetings => List.unmodifiable(_meetings);

  String nextMediaId() {
    _mediaSequence += 1;
    return 'MEDIA-BEN-${_mediaSequence.toString().padLeft(5, '0')}';
  }

  void createPost({
    required ForumPostKind kind,
    required String authorId,
    required String authorName,
    required CampaignRole authorRole,
    required GeographicScope scope,
    required String body,
    List<CommunityMedia> attachments = const [],
  }) {
    if (body.trim().isEmpty && attachments.isEmpty) return;
    _postSequence += 1;
    _posts.insert(
      0,
      ForumPost(
        id: 'POST-BEN-${_postSequence.toString().padLeft(4, '0')}',
        kind: kind,
        authorId: authorId,
        authorName: authorName,
        authorRole: authorRole,
        scope: scope,
        body: body.trim(),
        createdAt: DateTime.now(),
        attachments: List.unmodifiable(attachments),
      ),
    );
    notifyListeners();
  }

  void addComment({
    required String postId,
    required String authorId,
    required String authorName,
    required CampaignRole authorRole,
    required GeographicScope scope,
    required String body,
    List<CommunityMedia> attachments = const [],
    String? replyToCommentId,
  }) {
    if (body.trim().isEmpty && attachments.isEmpty) return;
    final index = _posts.indexWhere((post) => post.id == postId);
    if (index < 0) return;
    _commentSequence += 1;
    final comment = ForumComment(
      id: 'CMT-BEN-${_commentSequence.toString().padLeft(5, '0')}',
      authorId: authorId,
      authorName: authorName,
      authorRole: authorRole,
      scope: scope,
      body: body.trim(),
      createdAt: DateTime.now(),
      attachments: List.unmodifiable(attachments),
      replyToCommentId: replyToCommentId,
    );
    final post = _posts[index];
    _posts[index] = post.copyWith(comments: [...post.comments, comment]);
    notifyListeners();
  }

  void toggleReaction({required String postId, required String userId}) {
    final index = _posts.indexWhere((post) => post.id == postId);
    if (index < 0) return;
    final post = _posts[index];
    final reactions = {...post.reactionUserIds};
    if (!reactions.add(userId)) reactions.remove(userId);
    _posts[index] = post.copyWith(reactionUserIds: reactions);
    notifyListeners();
  }

  void createMeeting({
    required String title,
    required String agenda,
    required String organizerId,
    required String organizerName,
    required CampaignRole organizerRole,
    required GeographicScope organizerScope,
    required MeetingAudienceMode audienceMode,
    required List<String> participantIds,
    required List<String> participantNames,
    required DateTime startsAt,
    required int durationMinutes,
    String? groupId,
  }) {
    if (title.trim().isEmpty || participantIds.isEmpty) return;
    _meetingSequence += 1;
    _meetings.insert(
      0,
      CampaignMeeting(
        id: 'MTG-BEN-${_meetingSequence.toString().padLeft(4, '0')}',
        title: title.trim(),
        agenda: agenda.trim(),
        organizerId: organizerId,
        organizerName: organizerName,
        organizerRole: organizerRole,
        organizerScope: organizerScope,
        audienceMode: audienceMode,
        participantIds: List.unmodifiable(participantIds),
        participantNames: List.unmodifiable(participantNames),
        startsAt: startsAt,
        durationMinutes: durationMinutes,
        status: MeetingStatus.scheduled,
        createdAt: DateTime.now(),
        groupId: groupId,
      ),
    );
    notifyListeners();
  }

  void setMeetingStatus(String meetingId, MeetingStatus status) {
    final index = _meetings.indexWhere((meeting) => meeting.id == meetingId);
    if (index < 0) return;
    _meetings[index] = _meetings[index].copyWith(status: status);
    notifyListeners();
  }
}

class CampaignCommunity extends InheritedNotifier<CampaignCommunityController> {
  const CampaignCommunity({
    super.key,
    required CampaignCommunityController controller,
    required super.child,
  }) : super(notifier: controller);

  static CampaignCommunityController of(BuildContext context, {bool listen = true}) {
    if (listen) {
      final value = context.dependOnInheritedWidgetOfExactType<CampaignCommunity>();
      assert(value != null, 'CampaignCommunity is missing above this context.');
      return value!.notifier!;
    }
    final element = context.getElementForInheritedWidgetOfExactType<CampaignCommunity>();
    final value = element?.widget as CampaignCommunity?;
    assert(value != null, 'CampaignCommunity is missing above this context.');
    return value!.notifier!;
  }
}
