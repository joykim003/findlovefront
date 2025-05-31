import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/data/models/match.dart';
import 'package:frontend/data/services/api_service.dart';

final matchServiceProvider = Provider<ApiService>((ref) => ApiService());

final matchesProvider = FutureProvider<List<Match>>((ref) async {
  final service = ref.watch(matchServiceProvider);
  return service.getMatches();
});

class MatchNotifier extends StateNotifier<AsyncValue<List<Match>>> {
  final ApiService _service;

  MatchNotifier(this._service) : super(const AsyncValue.loading()) {
    _loadMatches();
  }

  Future<void> _loadMatches() async {
    try {
      final matches = await _service.getMatches();
      state = AsyncValue.data(matches);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> refreshMatches() async {
    state = const AsyncValue.loading();
    await _loadMatches();
  }
}

final matchNotifierProvider = StateNotifierProvider<MatchNotifier, AsyncValue<List<Match>>>((ref) {
  final service = ref.watch(matchServiceProvider);
  return MatchNotifier(service);
}); 