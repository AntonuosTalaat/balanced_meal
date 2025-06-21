import 'package:dio/dio.dart';

class ApiService {
  static final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://uz8if7.buildship.run',
    headers: {'Content-Type': 'application/json'},
  ));

  static Future<bool> placeOrder(List<Map<String, dynamic>> items) async {
    try {
      final payload = {'items': items};
      print('API → placeOrder payload: $payload');

      final response = await _dio.post('/placeOrder', data: payload);
      print('API ← statusCode: ${response.statusCode}');
      print('API ← data: ${response.data}');

      return response.data['result'] == true;
    } catch (e) {
      if (e is DioError) {
        print('DioError: ${e.response?.statusCode} – ${e.response?.data}');
      } else {
        print('Error: $e');
      }
      return false;
    }
  }
}
