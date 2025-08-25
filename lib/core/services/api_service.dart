import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:io';
import 'dart:typed_data';
import '../constants/navigator_key.dart';

class ApiService {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: const String.fromEnvironment('API_BASE_URL', defaultValue: 'http://31.97.98.47:9000/api/'),
      connectTimeout: const Duration(minutes: 10),
      receiveTimeout: const Duration(minutes: 10),
    ),
  );

  static final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static void init() {
    _dio.interceptors.clear();
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.read(key: 'access_token');
        if (token != null && !(options.extra['open'] == true)) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onResponse: (response, handler) {
        return handler.next(response);
      },
      onError: (DioException e, handler) async {
        if (e.response?.statusCode == 401) {
          await _storage.delete(key: 'access_token');
          // Optionally, you can use a callback or event to trigger navigation to login
          if (navigatorKey.currentState != null) {
            navigatorKey.currentState!.pushNamedAndRemoveUntil('/login', (route) => false);
          }
        }
        return handler.next(e);
      },
    ));
  }

  static Future<Response<T>> request<T>({
    required String url,
    bool open = false,
    String method = 'GET',
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    final options = Options(
      method: method,
      headers: headers,
      extra: {'open': open},
    );
    return _dio.request<T>(
      url,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  // Method for file uploads
  static Future<Response<T>> uploadFile<T>({
    required String url,
    bool open = false,
    String method = 'POST',
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    final token = await _storage.read(key: 'access_token');
    
    final options = Options(
      method: method,
      headers: {
        ...headers ?? {},
        'Content-Type': 'multipart/form-data',
        if (token != null && !open) 'Authorization': 'Bearer $token',
      },
    );

    // Convert data to FormData if it contains file paths
    dynamic formData;
    if (data != null) {
      formData = FormData();
      
      for (var entry in data.entries) {
        if (entry.value is Uint8List) {
          // This is image bytes, add as file
          formData.files.add(MapEntry(
            'avatar', // Use 'avatar' as the field name for the API
            MultipartFile.fromBytes(
              entry.value,
              filename: 'avatar.jpg',
            ),
          ));
        } else if (entry.value is String && entry.value.toString().startsWith('/')) {
          // This is a file path, add as file
          final file = File(entry.value);
          if (await file.exists()) {
            formData.files.add(MapEntry(
              entry.key,
              await MultipartFile.fromFile(
                file.path,
                filename: file.path.split('/').last,
              ),
            ));
          }
        } else if (entry.value is String && entry.value.toString().startsWith('blob:')) {
          // This is a blob URL, we need to convert it to bytes
          try {
            // For web, we need to fetch the blob data
            // This is a simplified approach - in a real app you might want to use a different method
            final response = await _dio.get(
              entry.value.toString(),
              options: Options(responseType: ResponseType.bytes),
            );
            
            if (response.data is Uint8List) {
              formData.files.add(MapEntry(
                entry.key,
                MultipartFile.fromBytes(
                  response.data,
                  filename: 'avatar.jpg',
                ),
              ));
            }
          } catch (e) {
            // If blob conversion fails, send as field
            formData.fields.add(MapEntry(entry.key, entry.value.toString()));
          }
        } else {
          // This is regular data
          formData.fields.add(MapEntry(entry.key, entry.value.toString()));
        }
      }
    }

    return _dio.request<T>(
      url,
      data: formData,
      queryParameters: queryParameters,
      options: options,
    );
  }
}

 