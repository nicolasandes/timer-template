import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

class WorkoutPreset extends Equatable {
  final String id;
  final String name;
  final int workDuration; // in seconds
  final int restDuration; // in seconds
  final int rounds;
  final DateTime createdAt;
  final String? userId; // null for local-only presets

  const WorkoutPreset({
    required this.id,
    required this.name,
    required this.workDuration,
    required this.restDuration,
    required this.rounds,
    required this.createdAt,
    this.userId,
  });

  /// Create a new preset with generated ID
  factory WorkoutPreset.create({
    required String name,
    required int workDuration,
    required int restDuration,
    required int rounds,
    String? userId,
  }) {
    return WorkoutPreset(
      id: const Uuid().v4(),
      name: name,
      workDuration: workDuration,
      restDuration: restDuration,
      rounds: rounds,
      createdAt: DateTime.now(),
      userId: userId,
    );
  }

  /// Calculate total workout duration
  int get totalDuration {
    return (workDuration + restDuration) * rounds;
  }

  /// Copy with method
  WorkoutPreset copyWith({
    String? id,
    String? name,
    int? workDuration,
    int? restDuration,
    int? rounds,
    DateTime? createdAt,
    String? userId,
  }) {
    return WorkoutPreset(
      id: id ?? this.id,
      name: name ?? this.name,
      workDuration: workDuration ?? this.workDuration,
      restDuration: restDuration ?? this.restDuration,
      rounds: rounds ?? this.rounds,
      createdAt: createdAt ?? this.createdAt,
      userId: userId ?? this.userId,
    );
  }

  /// Convert to JSON for Supabase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'work_duration': workDuration,
      'rest_duration': restDuration,
      'rounds': rounds,
      'created_at': createdAt.toIso8601String(),
      'user_id': userId,
    };
  }

  /// Create from JSON (Supabase response)
  factory WorkoutPreset.fromJson(Map<String, dynamic> json) {
    return WorkoutPreset(
      id: json['id'] as String,
      name: json['name'] as String,
      workDuration: json['work_duration'] as int,
      restDuration: json['rest_duration'] as int,
      rounds: json['rounds'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      userId: json['user_id'] as String?,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        workDuration,
        restDuration,
        rounds,
        createdAt,
        userId,
      ];
}
