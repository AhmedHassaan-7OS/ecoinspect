import 'package:equatable/equatable.dart';

enum UserRole { owner, procurement, technician, manager }

class Profile extends Equatable {
  final String id;
  final String? fullName;
  final UserRole? role;
  final String? companyName;
  final DateTime createdAt;

  const Profile({
    required this.id,
    this.fullName,
    this.role,
    this.companyName,
    required this.createdAt,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'] as String,
      fullName: json['full_name'] as String?,
      role: json['role'] != null
          ? UserRole.values.firstWhere(
              (e) => e.name == json['role'],
              orElse: () => UserRole.owner,
            )
          : null,
      companyName: json['company_name'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'role': role?.name,
      'company_name': companyName,
      'created_at': createdAt.toIso8601String(),
    };
  }

  Profile copyWith({
    String? id,
    String? fullName,
    UserRole? role,
    String? companyName,
    DateTime? createdAt,
  }) {
    return Profile(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      role: role ?? this.role,
      companyName: companyName ?? this.companyName,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, fullName, role, companyName, createdAt];
}
