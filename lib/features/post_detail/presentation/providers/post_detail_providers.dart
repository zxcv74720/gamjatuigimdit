import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamjatuigimdit/features/post_detail/data/repositories/post_detail_repository_impl.dart';
import 'package:gamjatuigimdit/features/post_detail/data/service/post_detail_service.dart';
import 'package:gamjatuigimdit/features/post_detail/domain/repositories/post_detail_repository.dart';
import 'package:gamjatuigimdit/features/post_detail/presentation/providers/state/post_detail_notifier.dart';
import 'package:gamjatuigimdit/features/post_detail/presentation/providers/state/post_detail_state.dart';
import 'package:gamjatuigimdit/features/splash/domain/providers/token_providers.dart';
import 'package:gamjatuigimdit/shared/domain/models/post/post_model.dart';

/// Service Provider
final postDetailServiceProvider = Provider<PostDetailService>((ref) {
  final token = ref.watch(tokenProvider);
  return PostDetailService(token);
});

/// Repository Provider
final postDetailRepositoryProvider = Provider<PostDetailRepository>((ref) {
  final service = ref.watch(postDetailServiceProvider);
  return PostDetailRepositoryImpl(service);
});

/// StateNotifier Provider (family를 사용하여 Post 객체를 파라미터로 받음)
final postDetailNotifierProvider = StateNotifierProvider.family<PostDetailNotifier, PostDetailState, Post>((ref, post) {
  final repository = ref.watch(postDetailRepositoryProvider);
  return PostDetailNotifier(repository, post);
});