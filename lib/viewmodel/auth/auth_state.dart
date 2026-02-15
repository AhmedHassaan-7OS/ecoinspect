import 'package:ecoinspect/model/auth_model/auth_model.dart';
import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show User;

enum AuthStatus { initial, loading, authenticated, unauthenticated, failure }

class AuthState extends Equatable {
  final AuthStatus status;
  final AuthUser? user;
  final String? errorMessage;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.errorMessage,
  });

  AuthState copyWith({
    AuthStatus? status,
    AuthUser? user,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, user, errorMessage];
}

class AuthUser {
  final String id;
  final String email;
  final String fullName;
  final String avatarUrl;

  AuthUser({
    required this.id,
    required this.email,
    required this.fullName,
    required this.avatarUrl,
  });

  /// Create an AuthUser from a Supabase [User].
  factory AuthUser.fromSupabaseUser(User user) {
    final meta = user.userMetadata ?? <String, dynamic>{};
    return AuthUser(
      id: user.id,
      email: user.email ?? '',
      fullName: ((meta['full_name'] ?? meta['fullName']) as String?) ?? '',
      avatarUrl: (meta['avatar_url'] as String?) ?? '',
    );
  }
}
