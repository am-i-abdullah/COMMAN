import 'package:comman/utils/constants.dart';
import 'package:dio/dio.dart';

Future<List<dynamic>?> getOrgPendingTasks({
  required String token,
  required String id,
}) async {
  Map<String, String> body = {
    "Authorization": "Bearer $token",
  };

  print('fetching organization pending tasks');

  var url =
      'http://$ipAddress:8000/hrm/employee/organization/$id/organization-tasks/';
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

  return null;
}
