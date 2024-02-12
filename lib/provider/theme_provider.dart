import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeProvider = StateProvider<bool>((ref) => true);

void toggleTheme(WidgetRef ref) {
  ref.read(themeProvider.notifier).state =
      ref.read(themeProvider.notifier).state ? false : true;
}
