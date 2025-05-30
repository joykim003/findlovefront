import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/auth_user.dart';
import '../data/services/auth_service.dart';
import 'package:uuid/uuid.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final authStateProvider = StateNotifierProvider<AuthNotifier, AsyncValue<AuthUser?>>((ref) {
  return AuthNotifier(AuthService());
});

class AuthNotifier extends StateNotifier<AsyncValue<AuthUser?>> {
  final AuthService _authService;
  final _uuid = const Uuid();

  AuthNotifier(this._authService) : super(const AsyncValue.data(null)) {
    _init();
  }

  Future<void> _init() async {
    try {
      final user = await _authService.getCurrentUser();
      state = AsyncValue.data(user);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    try {
      final user = await _authService.login(email: email, password: password);
      state = AsyncValue.data(user);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String name,
    required int age,
    required String gender,
    required String orientation,
    required String bio,
    String? location,
    required List<String> interests,
    required List<File> photos,
  }) async {
    state = const AsyncValue.loading();
    try {
      // Upload des photos
      final photoUrls = await Future.wait(
        photos.map((photo) async {
          final extension = photo.path.split('.').last;
          final fileName = '${_uuid.v4()}.$extension';
          return await _authService.uploadPhoto(photo, fileName);
        }),
      );

      final user = await _authService.register(
        email: email,
        password: password,
        name: name,
        age: age,
        gender: gender,
        orientation: orientation,
        bio: bio,
        location: location,
        interests: interests,
        photos: photoUrls,
      );
      state = AsyncValue.data(user);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await _authService.logout();
      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }
} 