import 'package:comman/provider/token_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

var ipAddress = '10.7.80.212';

Options getOpts(WidgetRef ref) {
  return Options(
    headers: {
      "Authorization": "Bearer ${ref.read(tokenProvider.state).state}",
    },
  );
}
