import 'models.dart';

/// Backend-agnostic contracts for the Benue campaign platform.
///
/// The current Flutter prototype can use in-memory implementations. Production
/// implementations can later call Django/DRF, WebSockets and offline storage
/// without changing page-level business intent.
abstract interface class CommunicationsRepository {
  Future<List<CommunicationRoom>> listRooms({
    required CampaignUser user,
  });

  Future<List<CampaignMessage>> listMessages({
    required String roomId,
    DateTime? before,
  });

  Future<CampaignMessage> sendMessage({
    required String roomId,
    required String senderId,
    required String body,
    String? replyToMessageId,
    String? incidentId,
    List<EvidenceAttachment> attachments = const [],
  });

  Future<CommunicationRoom> createOperationalRoom({
    required String title,
    required ConversationType type,
    required GeographicScope scope,
    required List<String> memberIds,
    String? incidentId,
    String? description,
  });

  Future<void> markRoomRead({
    required String roomId,
    required String userId,
  });
}

abstract interface class IncidentRepository {
  Future<List<CampaignIncident>> listIncidents({
    IncidentStatus? status,
    IncidentSeverity? minimumSeverity,
    GeographicScope? scope,
  });

  Future<CampaignIncident> getIncident(String incidentId);

  Future<CampaignIncident> createIncident({
    required String title,
    required String category,
    required IncidentSeverity severity,
    required GeographicScope scope,
    required String reporterId,
    String? summary,
  });

  Future<CampaignIncident> acknowledge({
    required String incidentId,
    required String actorId,
  });

  Future<CampaignIncident> assign({
    required String incidentId,
    required String team,
    required String actorId,
  });

  Future<CampaignIncident> changeStatus({
    required String incidentId,
    required IncidentStatus status,
    required String actorId,
    String? reason,
  });
}

abstract interface class TaskRepository {
  Future<List<CampaignTask>> listTasks({
    String? ownerId,
    TaskStatus? status,
    GeographicScope? scope,
  });

  Future<CampaignTask> createTask({
    required String title,
    required String ownerId,
    required GeographicScope scope,
    required IncidentSeverity priority,
    DateTime? dueAt,
    String? sourceConversationId,
    String? sourceMessageId,
    String? incidentId,
  });

  Future<CampaignTask> updateStatus({
    required String taskId,
    required TaskStatus status,
    required String actorId,
  });
}

abstract interface class FieldReportRepository {
  Future<List<FieldReport>> listReports({
    GeographicScope? scope,
    RecordStatus? status,
  });

  Future<FieldReport> submitReport({
    required String category,
    required String summary,
    required GeographicScope scope,
    required String reporterId,
    List<EvidenceAttachment> attachments = const [],
  });

  Future<FieldReport> verifyReport({
    required String reportId,
    required String verifierId,
    required bool accepted,
    required String reason,
  });
}

abstract interface class ElectionResultRepository {
  Future<List<ElectionResultSubmission>> listSubmissions({
    GeographicScope? scope,
    RecordStatus? status,
  });

  Future<ElectionResultSubmission> submitResult({
    required GeographicScope pollingUnitScope,
    required String submittedBy,
    required Map<String, int> partyVotes,
    EvidenceAttachment? resultImage,
  });

  Future<ElectionResultSubmission> verifyResult({
    required String submissionId,
    required String verifierId,
  });

  Future<ElectionResultSubmission> disputeResult({
    required String submissionId,
    required String verifierId,
    required String reason,
  });
}

abstract interface class IntelligenceRepository {
  Future<List<IntelligenceObservation>> listObservations({
    DataSourceType? sourceType,
    GeographicScope? scope,
    VerificationState? verificationState,
  });

  Future<IntelligenceObservation> addObservation({
    required String title,
    required String summary,
    required DataSourceType sourceType,
    required GeographicScope scope,
    required double confidence,
    required VerificationState verificationState,
    String? sourceReference,
  });
}

abstract interface class AuditRepository {
  Future<List<AuditEvent>> listEvents({
    String? entityType,
    String? entityId,
    String? actorId,
  });

  Future<void> record({
    required String actorId,
    required String action,
    required String entityType,
    required String entityId,
    String? detail,
  });
}
