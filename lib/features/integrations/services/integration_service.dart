import 'package:dio/dio.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/dio_client.dart';

class IntegrationService {
  IntegrationService(this._client);

  final DioClient _client;

  Future<Map<String, dynamic>> getSystems() {
    return _get('/integration-systems', query: {'per_page': 100});
  }

  Future<Map<String, dynamic>> createSystem({
    required String name,
    required String provider,
    String? description,
  }) {
    return _post(
      '/integration-systems',
      data: {
        'name': name,
        'provider': provider,
        'description': ?description,
        'active': true,
      },
    );
  }

  Future<Map<String, dynamic>> regenerateSystemToken(int systemId) {
    return _post(
      '/integration-systems/$systemId/regenerate-token',
      data: const {},
    );
  }

  Future<Map<String, dynamic>> getExternalIdentities() {
    return _get('/person-external-identities', query: {'per_page': 100});
  }

  Future<Map<String, dynamic>> createExternalIdentity({
    required int personId,
    required int integrationSystemId,
  }) {
    return _post(
      '/person-external-identities',
      data: {
        'person_id': personId,
        'integration_system_id': integrationSystemId,
        'active': true,
      },
    );
  }

  Future<Map<String, dynamic>> getDeliveryMetrics({int page = 1}) {
    return _get(
      '/person-delivery-metrics',
      query: {'page': page, 'per_page': 20, 'order[occurred_at]': 'desc'},
    );
  }

  Future<Map<String, dynamic>> _get(
    String path, {
    Map<String, dynamic>? query,
  }) async {
    try {
      final response = await _client.dio.get<Map<String, dynamic>>(
        path,
        queryParameters: query,
      );

      return response.data!;
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  Future<Map<String, dynamic>> _post(
    String path, {
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await _client.dio.post<Map<String, dynamic>>(
        path,
        data: data,
      );

      return response.data!;
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}
