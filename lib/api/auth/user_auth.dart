import 'package:comman/utils/constants.dart';
import 'package:dio/dio.dart';

Future<String> userAuth(
    {required String username, required String password}) async {
  /* 
  return access token, and refresh token
      -> access token: for using api 
      -> access token: for getting new access token after expiry
  */

  Map<String, String> body = {
    "username": username,
    "password": password,
  };

  var url = 'http://$ipAddress:8000/api/token/';
  Dio dio = Dio();

  try {
    Response response = await dio.post(url, data: body);
    print(response.data['access']);
    return response.data['access'];
  } catch (error) {
    print('error');
    print(error);
  }

  return '';
}
