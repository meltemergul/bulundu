import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bulundu/features/moderation/models/report_reason.dart';

class ModerationReport {
  const ModerationReport({
    required this.reporterId,
    required this.targetType,
    required this.targetId,
    required this.targetOwnerId,
    required this.reason,
    required this.note,
  });

  final String reporterId;
  final ReportTargetType targetType;
  final String targetId;
  final String targetOwnerId;
  final ReportReason reason;
  final String note;

  Map<String, dynamic> toCreateMap() => {
    'reporterId': reporterId,
    'targetType': targetType.name,
    'targetId': targetId,
    'targetOwnerId': targetOwnerId,
    'reason': reason.name,
    'note': note.trim(),
    'createdAt': FieldValue.serverTimestamp(),
  };
}
