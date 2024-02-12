import 'package:comman/api/data_fetching/get_user.dart';
import 'package:comman/pages/auth.dart';
import 'package:comman/pages/loading.dart';
import 'package:comman/pages/main_page.dart';
import 'package:comman/provider/theme_provider.dart';
import 'package:comman/provider/token_provider.dart';
import 'package:comman/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import './theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  // accessing local storage
  final storage = const FlutterSecureStorage();
  var isTokenAvailable = true;
  bool isLoading = true; // checking if app is busy in backend

  @override
  void initState() {
    super.initState();
    loadToken();
  }

  void loadToken() async {
    var token = await storage.read(key: 'token');
    if (token == null) isTokenAvailable = false;

    if (isTokenAvailable) {
      ref.read(tokenProvider.state).state = token;
      var userDetails = await getUser(token: token!);

      ref.read(userProvider).id = userDetails['id'];
      ref.read(userProvider).username = userDetails['username'];
      ref.read(userProvider).firstname = userDetails['first_name'];
      ref.read(userProvider).lastname = userDetails['last_name'];
      ref.read(userProvider).email = userDetails['email'];
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'COMMAN',

      // Dark Mode theme
      darkTheme: darkModeTheme,
      // Light Mode Theme
      theme: lightModeTheme,
      //initial theme
      themeMode: ref.watch(themeProvider) ? ThemeMode.light : ThemeMode.dark,

      // body of the main page
      home: Consumer(
        builder: (context, ref, child) {
          final token = ref.watch(tokenProvider);

          if (isLoading) {
            return const LoadingScreen();
          } else if (token == null) {
            return AuthScreen(
              storage: storage,
            );
          } else {
            return const HomePage();
          }
        },
      ),
    );
  }
}
