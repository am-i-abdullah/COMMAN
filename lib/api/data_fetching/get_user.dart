import 'package:comman/utils/constants.dart';
import 'package:dio/dio.dart';

Future<dynamic> getUser({
  required String token,
}) async {
  Map<String, String> body = {
    "Authorization": "Bearer $token",
  };

  var url = 'http://$ipAddress:8000/hrm/user/';
  Dio dio = Dio();

  try {
    Response response =
        await dio.get(url, data: body, options: Options(headers: body));

    if (response.statusCode == 200) {
      return response.data;
    }
  } catch (error) {
    print('error');
    print(error);
  }
}
