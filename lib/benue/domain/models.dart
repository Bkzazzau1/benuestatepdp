/// Shared domain models for the Benue State campaign command platform.
///
/// UI pages should use these models so the Flutter prototype can later connect
/// cleanly to Django/DRF, WebSocket and offline-sync services without rewriting
/// the product model.
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

enum RecordOrigin { prototypeSeed, campaignEntry, imported, systemDerived }

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

enum AssignmentStatus { vacant, assigned, training, ready, suspended }

enum ActivityStatus { planned, approved, active, completed, cancelled }

enum AssetStatus { available, assigned, inUse, maintenance, unavailable }

enum ElectionReadinessStatus { notStarted, incomplete, ready, attentionRequired }

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
    this.lgaId,
    this.lga,
    this.wardId,
    this.ward,
    this.pollingUnitId,
    this.pollingUnit,
  });

  final GeographyLevel level;
  final String state;
  final String? lgaId;
  final String? lga;
  final String? wardId;
  final String? ward;
  final String? pollingUnitId;
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
    this.origin = RecordOrigin.campaignEntry,
  });

  final String id;
  final String displayName;
  final CampaignRole role;
  final GeographicScope scope;
  final bool isActive;
  final RecordOrigin origin;
}

class FieldAssignment {
  const FieldAssignment({
    required this.id,
    required this.userId,
    required this.scope,
    required this.role,
    required this.status,
    required this.updatedAt,
    this.trainingComplete = false,
    this.checkedIn = false,
    this.origin = RecordOrigin.campaignEntry,
  });

  final String id;
  final String userId;
  final GeographicScope scope;
  final CampaignRole role;
  final AssignmentStatus status;
  final DateTime updatedAt;
  final bool trainingComplete;
  final bool checkedIn;
  final RecordOrigin origin;
}

class CampaignActivity {
  const CampaignActivity({
    required this.id,
    required this.title,
    required this.category,
    required this.scope,
    required this.ownerUnit,
    required this.status,
    required this.startsAt,
    this.endsAt,
    this.notes,
    this.origin = RecordOrigin.campaignEntry,
  });

  final String id;
  final String title;
  final String category;
  final GeographicScope scope;
  final String ownerUnit;
  final ActivityStatus status;
  final DateTime startsAt;
  final DateTime? endsAt;
  final String? notes;
  final RecordOrigin origin;
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
    this.origin = RecordOrigin.campaignEntry,
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
  final RecordOrigin origin;
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
    this.origin = RecordOrigin.campaignEntry,
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
  final RecordOrigin origin;
}

class CampaignAsset {
  const CampaignAsset({
    required this.id,
    required this.name,
    required this.category,
    required this.scope,
    required this.status,
    required this.updatedAt,
    this.custodianId,
    this.conditionNote,
    this.origin = RecordOrigin.campaignEntry,
  });

  final String id;
  final String name;
  final String category;
  final GeographicScope scope;
  final AssetStatus status;
  final DateTime updatedAt;
  final String? custodianId;
  final String? conditionNote;
  final RecordOrigin origin;
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
    this.origin = RecordOrigin.campaignEntry,
  });

  final String id;
  final String title;
  final ConversationType type;
  final GeographicScope scope;
  final List<String> memberIds;
  final DateTime createdAt;
  final String? incidentId;
  final String? description;
  final RecordOrigin origin;
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
    this.origin = RecordOrigin.campaignEntry,
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
  final RecordOrigin origin;
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
    this.origin = RecordOrigin.campaignEntry,
  });

  final String id;
  final EvidenceType type;
  final String fileName;
  final DateTime createdAt;
  final String uploaderId;
  final String? contentHash;
  final String? caption;
  final RecordOrigin origin;
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
    this.origin = RecordOrigin.campaignEntry,
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
  final RecordOrigin origin;
}

class ElectionReadinessRecord {
  const ElectionReadinessRecord({
    required this.id,
    required this.scope,
    required this.status,
    required this.agentCoveragePercent,
    required this.communicationReady,
    required this.logisticsReady,
    required this.updatedAt,
    this.note,
    this.origin = RecordOrigin.campaignEntry,
  });

  final String id;
  final GeographicScope scope;
  final ElectionReadinessStatus status;
  final double agentCoveragePercent;
  final bool communicationReady;
  final bool logisticsReady;
  final DateTime updatedAt;
  final String? note;
  final RecordOrigin origin;
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
    this.origin = RecordOrigin.campaignEntry,
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
  final RecordOrigin origin;

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
    this.origin = RecordOrigin.campaignEntry,
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
  final RecordOrigin origin;
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
