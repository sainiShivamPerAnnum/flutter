// import 'package:dio/dio.dart';
// import 'package:dio_http2_adapter/dio_http2_adapter.dart';

// class DioService {
//   final dio = Dio();
//   DioService() {
//     dio
//       ..options.baseUrl = 'https://pub.dev'
//       ..interceptors.add(LogInterceptor())
//       ..httpClientAdapter = Http2Adapter(
//         ConnectionManager(idleTimeout: const Duration(seconds: 10)),
//       );
//   }

//   Future<void> get() async {
//     Response<String>? response = await dio.get('/?xx=6');
//     for (final e in response.redirects) {
//       print('redirect: ${e.statusCode} ${e.location}');
//     }
//     print(response.data);
//   }
// }
