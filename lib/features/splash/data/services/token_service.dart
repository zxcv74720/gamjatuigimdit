import 'package:gamjatuigimdit/configs/app_configs.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gamjatuigimdit/shared/domain/models/either.dart';
import 'package:gamjatuigimdit/shared/domain/models/token/token_model.dart';
import 'package:gamjatuigimdit/shared/exceptions/http_exception.dart';
import 'package:logger/logger.dart';

class TokenService {
  final String clientId = dotenv.env['REDDIT_CLIENT_ID']!;
  final String clientSecret = dotenv.env['REDDIT_CLIENT_SECRET']!;

  Future<Either<AppException, Token>> fetchAccessToken() async {
    try {
      final basicAuth = base64.encode(
          utf8.encode('$clientId:$clientSecret')
      );

      final response = await http.post(
        Uri.parse('${AppConfigs.authUrl}/api/v1/access_token'),
        headers: {
          'Authorization': 'Basic $basicAuth',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'grant_type': 'client_credentials',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Right(Token(
          accessToken: data['access_token'],
          tokenType: data['token_type'],
          expiresIn: data['expires_in'],
        ));
      }

      return Left(AppException(
        message: 'Failed to get access token',
        statusCode: response.statusCode,
        identifier: 'AuthService',
      ));
    } catch (e) {
      return Left(AppException(
        message: e.toString(),
        statusCode: 500,
        identifier: 'AuthService',
      ));
    }
  }
}

