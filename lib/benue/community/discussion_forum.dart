import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';

import '../app_scope.dart';
import '../session.dart';
import '../widgets.dart';
import 'community_access.dart';
import 'community_store.dart';

class DiscussionForumPage extends StatefulWidget {
  const DiscussionForumPage({super.key});

  @override
  State<DiscussionForumPage> createState() => _DiscussionForumPageState();
}

class _DiscussionForumPageState extends State<DiscussionForumPage> {
  final _composer = TextEditingController();
  ForumPostKind _kind = ForumPostKind.discussion;
  ForumPostKind? _filter;
  final List<CommunityMedia> _attachments = [];

  @override
  void dispose() {
    _composer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final community = CampaignCommunity.of(context);
    final session = CampaignSession.of(context);
    final scope = geographicScopeFromCampaignScope(CampaignScope.of(context));
    final actorId = communityActorId(session.role!, scope);
    final posts = community.posts
        .where((post) => _filter == null || post.kind == _filter)
        .toList(growable: false);

    return ColoredBox(
      color: const Color(0xFFF3F6F3),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 22, 24, 38),
        children: [
          _ForumHero(
            name: session.operatorName,
            role: roleLabel(session.role!),
            scope: scope.label,
            postCount: community.posts.length,
          ),
          const SizedBox(height: 16),
          _ComposerCard(
            controller: _composer,
            kind: _kind,
            attachments: _attachments,
            onKindChanged: (value) => setState(() => _kind = value),
            onPickMedia: _pickComposerMedia,
            onRemoveAttachment: (id) =>
                setState(() => _attachments.removeWhere((a) => a.id == id)),
            onPost: () {
              community.createPost(
                kind: _kind,
                authorId: actorId,
                authorName: session.operatorName,
                authorRole: session.role!,
                scope: scope,
                body: _composer.text,
                attachments: List.unmodifiable(_attachments),
              );
              _composer.clear();
              setState(() => _attachments.clear());
            },
          ),
          const SizedBox(height: 14),
          _ForumFilters(
            selected: _filter,
            onChanged: (value) => setState(() => _filter = value),
          ),
          const SizedBox(height: 14),
          if (posts.isEmpty)
            const SectionCard(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 34),
                child: Center(
                  child: Text('No posts here yet.', style: TextStyle(color: muted)),
                ),
              ),
            )
          else
            ...posts.map((post) => Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: _PostCard(
                    post: post,
                    actorId: actorId,
                    onReact: () => community.toggleReaction(
                      postId: post.id,
                      userId: actorId,
                    ),
                    onComment: () => _openCommentDialog(
                      post: post,
                      actorId: actorId,
                    ),
                  ),
                )),
        ],
      ),
    );
  }

  Future<void> _pickComposerMedia() async {
    final media = await _pickMedia(limit: 4 - _attachments.length);
    if (!mounted || media.isEmpty) return;
    setState(() => _attachments.addAll(media));
  }

  Future<List<CommunityMedia>> _pickMedia({required int limit}) async {
    if (limit <= 0) return const [];
    const group = XTypeGroup(
      label: 'Photos, videos and files',
      extensions: [
        'jpg', 'jpeg', 'png', 'webp', 'gif',
        'mp4', 'mov', 'm4v', 'webm',
        'pdf', 'doc', 'docx', 'txt'
      ],
    );
    final files = await openFiles(acceptedTypeGroups: const [group]);
    if (!mounted) return const [];
    final selected = <CommunityMedia>[];
    final community = CampaignCommunity.of(context, listen: false);
    for (final file in files.take(limit)) {
      final name = file.name;
      final extension = name.contains('.') ? name.split('.').last.toLowerCase() : '';
      final type = _mediaType(extension);
      selected.add(CommunityMedia(
        id: community.nextMediaId(),
        type: type,
        fileName: name,
        bytes: await file.readAsBytes(),
      ));
    }
    return selected;
  }

  Future<void> _openCommentDialog({
    required ForumPost post,
    required String actorId,
  }) async {
    final controller = TextEditingController();
    final attachments = <CommunityMedia>[];
    final session = CampaignSession.of(context, listen: false);
    final scope = geographicScopeFromCampaignScope(
      CampaignScope.of(context, listen: false),
    );
    final community = CampaignCommunity.of(context, listen: false);

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Add a comment'),
          content: SizedBox(
            width: 560,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: controller,
                    minLines: 3,
                    maxLines: 7,
                    decoration: const InputDecoration(
                      hintText: 'Write your comment…',
                    ),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () async {
                      final media = await _pickMedia(limit: 3 - attachments.length);
                      if (media.isNotEmpty) {
                        setDialogState(() => attachments.addAll(media));
                      }
                    },
                    icon: const Icon(Icons.attach_file_rounded),
                    label: const Text('Add photo, video or file'),
                  ),
                  if (attachments.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: attachments
                          .map((item) => InputChip(
                                label: Text(item.fileName),
                                onDeleted: () => setDialogState(
                                  () => attachments.removeWhere((a) => a.id == item.id),
                                ),
                              ))
                          .toList(),
                    ),
                  ],
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                community.addComment(
                  postId: post.id,
                  authorId: actorId,
                  authorName: session.operatorName,
                  authorRole: session.role!,
                  scope: scope,
                  body: controller.text,
                  attachments: attachments,
                );
                Navigator.pop(dialogContext);
              },
              child: const Text('Comment'),
            ),
          ],
        ),
      ),
    );
    controller.dispose();
  }
}

class _ForumHero extends StatelessWidget {
  const _ForumHero({
    required this.name,
    required this.role,
    required this.scope,
    required this.postCount,
  });

  final String name;
  final String role;
  final String scope;
  final int postCount;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: const LinearGradient(
            colors: [Color(0xFF061D13), Color(0xFF0A5D34), Color(0xFF0B7A3B)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: const [
            BoxShadow(color: Color(0x19064F2A), blurRadius: 30, offset: Offset(0, 12)),
          ],
        ),
        child: LayoutBuilder(builder: (context, c) {
          final compact = c.maxWidth < 820;
          final copy = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Wrap(spacing: 8, runSpacing: 8, children: [
                _Badge(Icons.forum_rounded, 'MEMBER FORUM'),
                _Badge(Icons.photo_library_outlined, 'PHOTOS & VIDEO'),
                _Badge(Icons.groups_2_outlined, 'OPEN DISCUSSION'),
              ]),
              const SizedBox(height: 18),
              Text(
                'Discussion & Debate Forum',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: compact ? 30 : 40,
                  height: 1,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -.8,
                ),
              ),
              const SizedBox(height: 9),
              const Text(
                'Share experiences, ideas, questions and opinions with campaign members across Benue.',
                style: TextStyle(
                  color: Colors.white70,
                  height: 1.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          );
          final identity = Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .09),
              borderRadius: BorderRadius.circular(19),
              border: Border.all(color: Colors.white.withValues(alpha: .13)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w900)),
                const SizedBox(height: 3),
                Text('$role • $scope',
                    style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 10,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 13),
                Text('$postCount posts',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w900)),
              ],
            ),
          );
          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [copy, const SizedBox(height: 18), identity],
            );
          }
          return Row(children: [
            Expanded(flex: 13, child: copy),
            const SizedBox(width: 24),
            identity,
          ]);
        }),
      );
}

class _Badge extends StatelessWidget {
  const _Badge(this.icon, this.label);
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
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                  letterSpacing: .4)),
        ]),
      );
}

class _ComposerCard extends StatelessWidget {
  const _ComposerCard({
    required this.controller,
    required this.kind,
    required this.attachments,
    required this.onKindChanged,
    required this.onPickMedia,
    required this.onRemoveAttachment,
    required this.onPost,
  });

  final TextEditingController controller;
  final ForumPostKind kind;
  final List<CommunityMedia> attachments;
  final ValueChanged<ForumPostKind> onKindChanged;
  final VoidCallback onPickMedia;
  final ValueChanged<String> onRemoveAttachment;
  final VoidCallback onPost;

  @override
  Widget build(BuildContext context) => SectionCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Row(children: [
            CircleAvatar(
              backgroundColor: Color(0xFFE6F3EA),
              child: Icon(Icons.edit_rounded, color: pdpGreen),
            ),
            SizedBox(width: 11),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Start a conversation',
                    style: TextStyle(
                        color: ink, fontSize: 16, fontWeight: FontWeight.w900)),
                SizedBox(height: 2),
                Text('Share with the campaign community',
                    style: TextStyle(color: muted, fontSize: 10.5)),
              ]),
            ),
          ]),
          const SizedBox(height: 14),
          TextField(
            controller: controller,
            minLines: 3,
            maxLines: 8,
            decoration: const InputDecoration(
              hintText: 'Share an experience, opinion, question or debate topic…',
            ),
          ),
          const SizedBox(height: 12),
          Wrap(spacing: 8, runSpacing: 8, children: [
            DropdownButton<ForumPostKind>(
              value: kind,
              underline: const SizedBox.shrink(),
              borderRadius: BorderRadius.circular(14),
              items: ForumPostKind.values
                  .map((value) => DropdownMenuItem(
                        value: value,
                        child: Text(_kindLabel(value)),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) onKindChanged(value);
              },
            ),
            OutlinedButton.icon(
              onPressed: onPickMedia,
              icon: const Icon(Icons.add_photo_alternate_outlined),
              label: const Text('Add media'),
            ),
            FilledButton.icon(
              onPressed: onPost,
              icon: const Icon(Icons.send_rounded),
              label: const Text('Publish'),
            ),
          ]),
          if (attachments.isNotEmpty) ...[
            const SizedBox(height: 12),
            _MediaGrid(
              attachments: attachments,
              removable: true,
              onRemove: onRemoveAttachment,
            ),
          ],
        ]),
      );
}

class _ForumFilters extends StatelessWidget {
  const _ForumFilters({required this.selected, required this.onChanged});
  final ForumPostKind? selected;
  final ValueChanged<ForumPostKind?> onChanged;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: [
          ChoiceChip(
            label: const Text('All'),
            selected: selected == null,
            onSelected: (_) => onChanged(null),
          ),
          const SizedBox(width: 8),
          ...ForumPostKind.values.expand((kind) => [
                ChoiceChip(
                  label: Text(_kindLabel(kind)),
                  selected: selected == kind,
                  onSelected: (_) => onChanged(kind),
                ),
                const SizedBox(width: 8),
              ]),
        ]),
      );
}

class _PostCard extends StatelessWidget {
  const _PostCard({
    required this.post,
    required this.actorId,
    required this.onReact,
    required this.onComment,
  });

  final ForumPost post;
  final String actorId;
  final VoidCallback onReact;
  final VoidCallback onComment;

  @override
  Widget build(BuildContext context) {
    final reacted = post.reactionUserIds.contains(actorId);
    return SectionCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: const Color(0xFFE7F3EA),
            child: Text(_initials(post.authorName),
                style: const TextStyle(
                    color: pdpGreen, fontWeight: FontWeight.w900)),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Wrap(spacing: 7, runSpacing: 5, children: [
                Text(post.authorName,
                    style: const TextStyle(
                        color: ink, fontWeight: FontWeight.w900)),
                StatusPill(_kindLabel(post.kind).toUpperCase()),
              ]),
              const SizedBox(height: 4),
              Text(
                '${roleLabel(post.authorRole)} • ${post.scope.label} • ${_relativeTime(post.createdAt)}',
                style: const TextStyle(color: muted, fontSize: 10),
              ),
            ]),
          ),
          const Icon(Icons.more_horiz_rounded, color: muted),
        ]),
        if (post.body.isNotEmpty) ...[
          const SizedBox(height: 14),
          Text(post.body,
              style: const TextStyle(color: ink, fontSize: 13, height: 1.55)),
        ],
        if (post.attachments.isNotEmpty) ...[
          const SizedBox(height: 14),
          _MediaGrid(attachments: post.attachments),
        ],
        const SizedBox(height: 13),
        const Divider(height: 1),
        Row(children: [
          TextButton.icon(
            onPressed: onReact,
            icon: Icon(
              reacted ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: reacted ? pdpRed : muted,
            ),
            label: Text('${post.reactionUserIds.length} Like'),
          ),
          TextButton.icon(
            onPressed: onComment,
            icon: const Icon(Icons.chat_bubble_outline_rounded),
            label: Text('${post.comments.length} Comment'),
          ),
        ]),
        if (post.comments.isNotEmpty) ...[
          const Divider(height: 18),
          ...post.comments.map((comment) => _CommentTile(comment: comment)),
        ],
      ]),
    );
  }
}

class _CommentTile extends StatelessWidget {
  const _CommentTile({required this.comment});
  final ForumComment comment;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 11),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: const Color(0xFFF0F4F1),
            child: Text(_initials(comment.authorName),
                style: const TextStyle(
                    color: pdpGreen, fontSize: 9, fontWeight: FontWeight.w900)),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(11),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F9F7),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(comment.authorName,
                    style: const TextStyle(
                        color: ink, fontSize: 10.5, fontWeight: FontWeight.w900)),
                if (comment.body.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(comment.body,
                      style: const TextStyle(color: ink, fontSize: 11.5, height: 1.4)),
                ],
                if (comment.attachments.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  _MediaGrid(attachments: comment.attachments, compact: true),
                ],
              ]),
            ),
          ),
        ]),
      );
}

class _MediaGrid extends StatelessWidget {
  const _MediaGrid({
    required this.attachments,
    this.removable = false,
    this.onRemove,
    this.compact = false,
  });

  final List<CommunityMedia> attachments;
  final bool removable;
  final ValueChanged<String>? onRemove;
  final bool compact;

  @override
  Widget build(BuildContext context) => Wrap(
        spacing: 9,
        runSpacing: 9,
        children: attachments.map((item) {
          final width = compact ? 150.0 : 210.0;
          return Container(
            width: width,
            height: item.type == CommunityMediaType.image ? (compact ? 110 : 150) : 72,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F2),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE0E7E2)),
            ),
            child: Stack(children: [
              Positioned.fill(
                child: item.type == CommunityMediaType.image && item.bytes != null
                    ? Image.memory(item.bytes!, fit: BoxFit.cover)
                    : Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(children: [
                          Icon(_mediaIcon(item.type), color: pdpGreen),
                          const SizedBox(width: 9),
                          Expanded(
                            child: Text(item.fileName,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    color: ink,
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w700)),
                          ),
                        ]),
                      ),
              ),
              if (removable)
                Positioned(
                  top: 5,
                  right: 5,
                  child: Material(
                    color: Colors.black54,
                    shape: const CircleBorder(),
                    child: InkWell(
                      onTap: () => onRemove?.call(item.id),
                      customBorder: const CircleBorder(),
                      child: const Padding(
                        padding: EdgeInsets.all(5),
                        child: Icon(Icons.close_rounded, color: Colors.white, size: 15),
                      ),
                    ),
                  ),
                ),
            ]),
          );
        }).toList(),
      );
}

CommunityMediaType _mediaType(String extension) {
  if (['jpg', 'jpeg', 'png', 'webp', 'gif'].contains(extension)) {
    return CommunityMediaType.image;
  }
  if (['mp4', 'mov', 'm4v', 'webm'].contains(extension)) {
    return CommunityMediaType.video;
  }
  if (['pdf', 'doc', 'docx', 'txt'].contains(extension)) {
    return CommunityMediaType.document;
  }
  return CommunityMediaType.other;
}

IconData _mediaIcon(CommunityMediaType type) => switch (type) {
      CommunityMediaType.image => Icons.image_outlined,
      CommunityMediaType.video => Icons.play_circle_outline_rounded,
      CommunityMediaType.document => Icons.description_outlined,
      CommunityMediaType.other => Icons.attach_file_rounded,
    };

String _kindLabel(ForumPostKind kind) => switch (kind) {
      ForumPostKind.discussion => 'Discussion',
      ForumPostKind.debate => 'Debate',
      ForumPostKind.experience => 'Experience',
      ForumPostKind.question => 'Question',
      ForumPostKind.announcement => 'Announcement',
    };

String _initials(String value) {
  final parts = value.trim().split(RegExp(r'\s+'));
  if (parts.isEmpty || parts.first.isEmpty) return '?';
  if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
  return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
}

String _relativeTime(DateTime time) {
  final difference = DateTime.now().difference(time.toLocal());
  if (difference.isNegative || difference.inMinutes < 1) return 'Just now';
  if (difference.inMinutes < 60) return '${difference.inMinutes}m';
  if (difference.inHours < 24) return '${difference.inHours}h';
  return '${difference.inDays}d';
}
