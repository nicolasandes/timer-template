import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

class WorkoutHistory extends Equatable {
  final String id;
  final String? userId;
  final String? presetId;
  final String? presetName;
  final int completedRounds;
  final int totalDuration; // in seconds
  final DateTime completedAt;

  const WorkoutHistory({
    required this.id,
    this.userId,
    this.presetId,
    this.presetName,
    required this.completedRounds,
    required this.totalDuration,
    required this.completedAt,
  });

  /// Create a new history entry
  factory WorkoutHistory.create({
    required int completedRounds,
    required int totalDuration,
    String? userId,
    String? presetId,
    String? presetName,
  }) {
    return WorkoutHistory(
      id: const Uuid().v4(),
      userId: userId,
      presetId: presetId,
      presetName: presetName,
      completedRounds: completedRounds,
      totalDuration: totalDuration,
      completedAt: DateTime.now(),
    );
  }

  /// Convert to JSON for Supabase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'preset_id': presetId,
      'preset_name': presetName,
      'completed_rounds': completedRounds,
      'total_duration': totalDuration,
      'completed_at': completedAt.toIso8601String(),
    };
  }

  /// Create from JSON (Supabase response)
  factory WorkoutHistory.fromJson(Map<String, dynamic> json) {
    return WorkoutHistory(
      id: json['id'] as String,
      userId: json['user_id'] as String?,
      presetId: json['preset_id'] as String?,
      presetName: json['preset_name'] as String?,
      completedRounds: json['completed_rounds'] as int,
      totalDuration: json['total_duration'] as int,
      completedAt: DateTime.parse(json['completed_at'] as String),
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        presetId,
        presetName,
        completedRounds,
        totalDuration,
        completedAt,
      ];
}
