import 'package:comman/utils/constants.dart';
import 'package:dio/dio.dart';

Future<List<dynamic>?> getEmployeeOrgs({
  required String token,
}) async {
  Map<String, String> body = {
    "Authorization": "Bearer $token",
  };

  print('im here');

  var url = 'http://$ipAddress:8000/hrm/employee/organizations/';
  Dio dio = Dio();

  try {
    Response response =
        await dio.get(url, data: body, options: Options(headers: body));

    print(response.data);

    if (response.statusCode == 200) {
      return response.data;
    }
  } catch (error) {
    print('error');
    print(error);
  }

  return null;
}
