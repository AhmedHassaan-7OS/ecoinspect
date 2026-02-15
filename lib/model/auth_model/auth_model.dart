import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthUser extends Equatable {
  final String id;
  final String email;
  final String? fullName;
  final String? avatarUrl;

  const AuthUser({
    required this.id,
    required this.email,
    this.fullName,
    this.avatarUrl,
  });

  factory AuthUser.fromSupabaseUser(User user) {
    final meta = user.userMetadata ?? {};
    return AuthUser(
      id: user.id,
      email: user.email ?? '',
      fullName: meta['full_name'] as String?,
      avatarUrl: meta['avatar_url'] as String?,
    );
  }

  AuthUser copyWith({
    String? id,
    String? email,
    String? fullName,
    String? avatarUrl,
  }) {
    return AuthUser(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  @override
  List<Object?> get props => [id, email, fullName, avatarUrl];
}
