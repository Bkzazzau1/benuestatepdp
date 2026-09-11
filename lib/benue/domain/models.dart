/// Shared domain models for the Benue State campaign command platform.
///
/// UI pages should gradually move away from page-local mock classes and use
/// these models so the Flutter prototype can later connect cleanly to Django/
/// DRF, WebSocket and offline-sync services without rewriting the product model.
library;

enum CampaignRole {
  candidate,
  directorGeneral,
  situationRoomDirector,
  stateAdministrator,
  operationsOfficer,
  mediaIntelligenceOfficer,
  legalOfficer,
  logisticsOfficer,
  financeOfficer,
  lgaCoordinator,
  wardCoordinator,
  pollingUnitAgent,
  fieldReporter,
  readOnlyExecutive,
}

enum GeographyLevel { state, lga, ward, pollingUnit }

enum RecordStatus { draft, submitted, verified, rejected, archived }

enum IncidentSeverity { info, low, medium, high, critical }

enum IncidentStatus {
  reported,
  acknowledged,
  assigned,
  investigating,
  escalated,
  resolved,
  closed,
}

enum TaskStatus { open, inProgress, blocked, completed, cancelled }

enum ConversationType { direct, group, incident, broadcast }

enum MessageDeliveryState { sending, sent, delivered, read, failed }

enum EvidenceType { photo, video, audio, document, resultForm, location }

enum VerificationState {
  unverified,
  investigating,
  verifiedTrue,
  verifiedFalse,
  misleading,
  insufficientEvidence,
}

enum DataSourceType {
  inec,
  campaignField,
  independentPoll,
  publicMedia,
  publicSocial,
  analystReview,
  modelDerived,
}

class GeographicScope {
  const GeographicScope({
    required this.level,
    required this.state,
    this.lga,
    this.ward,
    this.pollingUnit,
  });

  final GeographyLevel level;
  final String state;
  final String? lga;
  final String? ward;
  final String? pollingUnit;

  static const benueState = GeographicScope(
    level: GeographyLevel.state,
    state: 'Benue',
  );

  String get label => switch (level) {
        GeographyLevel.state => state,
        GeographyLevel.lga => '$lga LGA, $state',
        GeographyLevel.ward => '$ward Ward, $lga LGA',
        GeographyLevel.pollingUnit => '$pollingUnit • $ward • $lga',
      };
}

class CampaignUser {
  const CampaignUser({
    required this.id,
    required this.displayName,
    required this.role,
    required this.scope,
    required this.isActive,
  });

  final String id;
  final String displayName;
  final CampaignRole role;
  final GeographicScope scope;
  final bool isActive;
}

class CampaignTask {
  const CampaignTask({
    required this.id,
    required this.title,
    required this.ownerId,
    required this.scope,
    required this.status,
    required this.priority,
    required this.createdAt,
    this.dueAt,
    this.sourceConversationId,
    this.sourceMessageId,
    this.incidentId,
  });

  final String id;
  final String title;
  final String ownerId;
  final GeographicScope scope;
  final TaskStatus status;
  final IncidentSeverity priority;
  final DateTime createdAt;
  final DateTime? dueAt;
  final String? sourceConversationId;
  final String? sourceMessageId;
  final String? incidentId;
}

class CampaignIncident {
  const CampaignIncident({
    required this.id,
    required this.title,
    required this.category,
    required this.severity,
    required this.status,
    required this.scope,
    required this.reportedAt,
    required this.reporterId,
    this.assignedTeam,
    this.conversationId,
    this.summary,
  });

  final String id;
  final String title;
  final String category;
  final IncidentSeverity severity;
  final IncidentStatus status;
  final GeographicScope scope;
  final DateTime reportedAt;
  final String reporterId;
  final String? assignedTeam;
  final String? conversationId;
  final String? summary;
}

class CommunicationRoom {
  const CommunicationRoom({
    required this.id,
    required this.title,
    required this.type,
    required this.scope,
    required this.memberIds,
    required this.createdAt,
    this.incidentId,
    this.description,
  });

  final String id;
  final String title;
  final ConversationType type;
  final GeographicScope scope;
  final List<String> memberIds;
  final DateTime createdAt;
  final String? incidentId;
  final String? description;
}

class CampaignMessage {
  const CampaignMessage({
    required this.id,
    required this.roomId,
    required this.senderId,
    required this.body,
    required this.sentAt,
    required this.deliveryState,
    this.incidentId,
    this.replyToMessageId,
    this.attachments = const [],
  });

  final String id;
  final String roomId;
  final String senderId;
  final String body;
  final DateTime sentAt;
  final MessageDeliveryState deliveryState;
  final String? incidentId;
  final String? replyToMessageId;
  final List<EvidenceAttachment> attachments;
}

class EvidenceAttachment {
  const EvidenceAttachment({
    required this.id,
    required this.type,
    required this.fileName,
    required this.createdAt,
    required this.uploaderId,
    this.contentHash,
    this.caption,
  });

  final String id;
  final EvidenceType type;
  final String fileName;
  final DateTime createdAt;
  final String uploaderId;
  final String? contentHash;
  final String? caption;
}

class FieldReport {
  const FieldReport({
    required this.id,
    required this.category,
    required this.summary,
    required this.scope,
    required this.reporterId,
    required this.reportedAt,
    required this.status,
    this.incidentId,
    this.attachments = const [],
  });

  final String id;
  final String category;
  final String summary;
  final GeographicScope scope;
  final String reporterId;
  final DateTime reportedAt;
  final RecordStatus status;
  final String? incidentId;
  final List<EvidenceAttachment> attachments;
}

class ElectionResultSubmission {
  const ElectionResultSubmission({
    required this.id,
    required this.pollingUnitScope,
    required this.submittedBy,
    required this.submittedAt,
    required this.status,
    required this.partyVotes,
    this.resultImage,
    this.verifiedBy,
    this.verifiedAt,
    this.disputeReason,
  });

  final String id;
  final GeographicScope pollingUnitScope;
  final String submittedBy;
  final DateTime submittedAt;
  final RecordStatus status;
  final Map<String, int> partyVotes;
  final EvidenceAttachment? resultImage;
  final String? verifiedBy;
  final DateTime? verifiedAt;
  final String? disputeReason;

  /// Campaign-collected figures must remain explicitly unofficial until INEC
  /// declares the official result.
  bool get isOfficial => false;
}

class IntelligenceObservation {
  const IntelligenceObservation({
    required this.id,
    required this.title,
    required this.summary,
    required this.sourceType,
    required this.observedAt,
    required this.scope,
    required this.confidence,
    required this.verificationState,
    this.sourceReference,
  });

  final String id;
  final String title;
  final String summary;
  final DataSourceType sourceType;
  final DateTime observedAt;
  final GeographicScope scope;
  final double confidence;
  final VerificationState verificationState;
  final String? sourceReference;
}

class AuditEvent {
  const AuditEvent({
    required this.id,
    required this.actorId,
    required this.action,
    required this.entityType,
    required this.entityId,
    required this.timestamp,
    this.detail,
  });

  final String id;
  final String actorId;
  final String action;
  final String entityType;
  final String entityId;
  final DateTime timestamp;
  final String? detail;
}
