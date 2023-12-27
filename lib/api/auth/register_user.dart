import 'package:dio/dio.dart';

Future registerUser({
  required String username,
  required String password,
  required String email,
  required String firstName,
  required String lastName,
}) async {
  /* 
  return access token, and refresh token
      -> access token: for using api 
      -> access token: for getting new access token after expiry
  */

  Map<String, String> body = {
    "username": username,
    "password": password,
    "password_confirmation": password,
    "email": email,
    "first_name": 'abc',
    "last_name": 'xyz',
  };

  var url = 'http://192.168.43.185:8000/hrm/register/';
  Dio dio = Dio();

  try {
    print('sending request');
    Response response = await dio.post(url, data: body);

    print(response.data);
  } catch (error) {
    print('error');
    print(error);
  }
}


// 10.7.81.11:8000