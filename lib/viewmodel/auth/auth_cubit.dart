import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart'
    hide AuthState, AuthUser;

import 'auth_state.dart';

// تعريف ثابت الدلو (غير القيمة إذا كان اسم الـ bucket مختلفًا عندك)
const String kAvatarBucket = 'avatars';

class AuthCubit extends Cubit<AuthState> {
  final SupabaseClient _supabase;

  AuthCubit(this._supabase) : super(const AuthState());

  // ---------------------------------------------------------------------------
  // Public methods
  // ---------------------------------------------------------------------------

  Future<void> loadCurrentUser() async {
    emit(state.copyWith(status: AuthStatus.loading, clearError: true));
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        emit(state.copyWith(status: AuthStatus.unauthenticated, user: null));
      } else {
        emit(
          state.copyWith(
            status: AuthStatus.authenticated,
            user: AuthUser.fromSupabaseUser(user),
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(status: AuthStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    emit(state.copyWith(status: AuthStatus.loading, clearError: true));
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      final user = response.user;
      if (user == null) throw Exception('Invalid credentials');
      emit(
        state.copyWith(
          status: AuthStatus.authenticated,
          user: AuthUser.fromSupabaseUser(user),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: AuthStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  Future<void> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    emit(state.copyWith(status: AuthStatus.loading, clearError: true));
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': fullName},
      );
      final user = response.user;
      if (user == null) throw Exception('Unable to create account');
      emit(
        state.copyWith(
          status: AuthStatus.authenticated,
          user: AuthUser.fromSupabaseUser(user),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: AuthStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  Future<void> signOut() async {
    emit(state.copyWith(status: AuthStatus.loading, clearError: true));
    try {
      await _supabase.auth.signOut();
      emit(state.copyWith(status: AuthStatus.unauthenticated, user: null));
    } catch (e) {
      emit(
        state.copyWith(status: AuthStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  Future<void> updateProfile({
    String? fullName,
    Uint8List? avatarBytes,
    String? avatarExt,
  }) async {
    emit(state.copyWith(status: AuthStatus.loading, clearError: true));
    try {
      String? avatarUrl;
      if (avatarBytes != null && avatarExt != null) {
        avatarUrl = await _uploadAvatar(avatarBytes, avatarExt);
      }

      final metadata = <String, dynamic>{};
      if (fullName != null) metadata['full_name'] = fullName;
      if (avatarUrl != null) metadata['avatar_url'] = avatarUrl;

      if (metadata.isNotEmpty) {
        final response = await _supabase.auth.updateUser(
          UserAttributes(data: metadata),
        );
        final updatedUser = response.user ?? _supabase.auth.currentUser;
        if (updatedUser == null) throw Exception('No user session');
        emit(
          state.copyWith(
            status: AuthStatus.authenticated,
            user: AuthUser.fromSupabaseUser(updatedUser),
          ),
        );
      } else {
        final currentUser = _supabase.auth.currentUser;
        if (currentUser == null) throw Exception('No user session');
        emit(
          state.copyWith(
            status: AuthStatus.authenticated,
            user: AuthUser.fromSupabaseUser(currentUser),
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(status: AuthStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  // ---------------------------------------------------------------------------
  // Private helpers
  // ---------------------------------------------------------------------------

  Future<String> _uploadAvatar(Uint8List bytes, String ext) async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception('No user session');

    final fileName = '${DateTime.now().millisecondsSinceEpoch}.$ext';
    final path = '${user.id}/$fileName';

    await _supabase.storage
        .from(kAvatarBucket)
        .uploadBinary(
          path,
          bytes,
          fileOptions: FileOptions(contentType: 'image/$ext'),
        );

    return _supabase.storage.from(kAvatarBucket).getPublicUrl(path);
  }
}
