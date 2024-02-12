import 'package:comman/utils/constants.dart';
import 'package:comman/widgets/snackbar.dart';
import 'package:dio/dio.dart';

Future registerUser({
  required String username,
  required String password,
  required String email,
  required String firstName,
  required String lastName,
  required context,
}) async {
  Map<String, String> body = {
    "username": username,
    "password": password,
    "password_confirmation": password,
    "email": email,
    "first_name": firstName,
    "last_name": lastName,
  };

  var url = 'http://$ipAddress:8000/hrm/register/';
  Dio dio = Dio();

  try {
    print('sending request');
    Response response = await dio.post(url, data: body);
    return response;
  } catch (error) {
    showSnackBar(context, 'Something went wrong!');
  }
}


// 10.7.81.11:8000