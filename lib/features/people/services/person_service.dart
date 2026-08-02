import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/dio_client.dart';
import '../models/contract_type.dart';
import '../models/seniority_level.dart';

/// Raw HTTP calls to `/people`. Returns decoded JSON — mapping JSON into
/// [Person] instances is the [PersonRepository]'s job, not this class's.
class PersonService {
  PersonService(this._client);

  final DioClient _client;

  static final _dateFormat = DateFormat('yyyy-MM-dd');

  Future<Map<String, dynamic>> index({
    int page = 1,
    int? teamId,
    String? search,
    int? perPage,
  }) async {
    try {
      final response = await _client.dio.get<Map<String, dynamic>>(
        '/people',
        queryParameters: {
          'page': page,
          'per_page': ?perPage,
          'filters[team_id]': ?teamId,
          if (search != null && search.isNotEmpty) 'search': search,
        },
      );

      return response.data!;
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  Future<Map<String, dynamic>> show(int id) async {
    try {
      final response = await _client.dio.get<Map<String, dynamic>>(
        '/people/$id',
      );

      return response.data!;
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  Future<Map<String, dynamic>> store({
    required String name,
    required int teamId,
    DateTime? birthDate,
    required String position,
    required ContractType contractType,
    DateTime? admissionDate,
    required SeniorityLevel seniority,
    String? email,
    String? phone,
  }) async {
    try {
      final response = await _client.dio.post<Map<String, dynamic>>(
        '/people',
        data: {
          'name': name,
          'team_id': teamId,
          if (birthDate != null) 'birth_date': _dateFormat.format(birthDate),
          'position': position,
          'contract_type': contractType.apiValue,
          if (admissionDate != null)
            'admission_date': _dateFormat.format(admissionDate),
          'seniority': seniority.apiValue,
          'email': ?email,
          'phone': ?phone,
        },
      );

      return response.data!;
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}
