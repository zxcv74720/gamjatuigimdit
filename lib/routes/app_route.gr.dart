// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i4;
import 'package:flutter/material.dart' as _i5;
import 'package:gamjatuigimdit/features/post_detail/presentation/screens/post_detail_screen.dart'
    as _i1;
import 'package:gamjatuigimdit/features/post_list/presentation/screens/post_list_screen.dart'
    as _i2;
import 'package:gamjatuigimdit/features/splash/presentation%20/screens/splash_screen.dart'
    as _i3;
import 'package:gamjatuigimdit/shared/domain/models/post/post_model.dart'
    as _i6;

/// generated route for
/// [_i1.PostDetailScreen]
class PostDetailRoute extends _i4.PageRouteInfo<PostDetailRouteArgs> {
  PostDetailRoute({
    _i5.Key? key,
    required _i6.Post post,
    List<_i4.PageRouteInfo>? children,
  }) : super(
          PostDetailRoute.name,
          args: PostDetailRouteArgs(
            key: key,
            post: post,
          ),
          initialChildren: children,
        );

  static const String name = 'PostDetailRoute';

  static _i4.PageInfo page = _i4.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<PostDetailRouteArgs>();
      return _i1.PostDetailScreen(
        key: args.key,
        post: args.post,
      );
    },
  );
}

class PostDetailRouteArgs {
  const PostDetailRouteArgs({
    this.key,
    required this.post,
  });

  final _i5.Key? key;

  final _i6.Post post;

  @override
  String toString() {
    return 'PostDetailRouteArgs{key: $key, post: $post}';
  }
}

/// generated route for
/// [_i2.PostListScreen]
class PostListRoute extends _i4.PageRouteInfo<void> {
  const PostListRoute({List<_i4.PageRouteInfo>? children})
      : super(
          PostListRoute.name,
          initialChildren: children,
        );

  static const String name = 'PostListRoute';

  static _i4.PageInfo page = _i4.PageInfo(
    name,
    builder: (data) {
      return const _i2.PostListScreen();
    },
  );
}

/// generated route for
/// [_i3.SplashScreen]
class SplashRoute extends _i4.PageRouteInfo<void> {
  const SplashRoute({List<_i4.PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static _i4.PageInfo page = _i4.PageInfo(
    name,
    builder: (data) {
      return const _i3.SplashScreen();
    },
  );
}
