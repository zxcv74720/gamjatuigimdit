import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamjatuigimdit/features/post_list/data/datasource/post_list_remote_datasource.dart';
import 'package:gamjatuigimdit/features/post_list/data/repositories/post_list_repository.dart';
import 'package:gamjatuigimdit/features/post_list/domain/repositories/post_list_repository.dart';
import 'package:gamjatuigimdit/shared/domain/providers/dio_network_service_provider.dart';
import 'package:gamjatuigimdit/shared/remote/remote.dart';

final postListDatasourceProvider =
Provider.family<PostListDatasource, NetworkService>(
      (_, networkService) => PostListRemoteDatasource(networkService),
);

final postListRepositoryProvider = Provider<PostListRepository>((ref) {
  final networkService = ref.watch(networkServiceProvider);
  final datasource = ref.watch(postListDatasourceProvider(networkService));
  final repository = PostListRepositoryImpl(datasource);

  return repository;
});