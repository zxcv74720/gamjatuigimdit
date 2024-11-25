import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamjatuigimdit/shared/remote/remote.dart';

final networkServiceProvider = Provider<DioNetworkService>(
      (ref) {
    final Dio dio = Dio();
    return DioNetworkService(dio);
  },
);