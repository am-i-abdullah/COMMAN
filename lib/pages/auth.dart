// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:comman/api/data_fetching/get_user.dart';
import 'package:comman/api/auth/register_user.dart';
import 'package:comman/api/auth/user_auth.dart';
import 'package:comman/provider/theme_provider.dart';
import 'package:comman/provider/token_provider.dart';
import 'package:comman/provider/user_provider.dart';
import 'package:comman/widgets/image_picker.dart';
import 'package:comman/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key, required this.storage});

  final storage;

  @override
  ConsumerState<AuthScreen> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  // for getting values out of form and other stuff
  final formKey = GlobalKey<FormState>();
  // switching between login and signup content
  var isLogin = true;
  // if it is busy in uploading the credentials
  var isLoading = false;

  // user credentials and meta data
  var userName = "";
  var userEmail = "";
  var userPassword = "";
  var firstName = "";
  var lastName = "";
  File? userImage;

  // upon form submission, validating and authenticating process
  void submit() async {
    // validating if the user has entered right data, before moving on
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    // saving the data, in case user make changes while it's busy in backend
    formKey.currentState!.save();

    try {
      // now busy in backend
      setState(() {
        isLoading = true;
      });

      // registeration mode
      if (!isLogin) {
        print('registering user...');
        await registerUser(
          context: context,
          username: userName,
          password: userPassword,
          email: userEmail,
          firstName: firstName,
          lastName: lastName,
        );
      }

      // logging back user, or authenticating
      var token = await userAuth(
        username: userName,
        password: userPassword,
      );

      if (token.isEmpty && isLogin) {
        showSnackBar(context, 'Un-Authorized User!');
        setState(() {
          isLoading = false;
        });
        return;
      }

      // accessing user based upon token
      var userDetails = await getUser(token: token);

      ref.read(userProvider.notifier).state.username = userDetails['username'];
      ref.read(userProvider.notifier).state.firstname =
          userDetails['first_name'];
      ref.read(userProvider.notifier).state.lastname = userDetails['last_name'];
      ref.read(userProvider.notifier).state.email = userDetails['email'];
      ref.read(userProvider.notifier).state.id = userDetails['id'];

      ref.read(tokenProvider.notifier).state = token;
      await widget.storage.write(key: 'token', value: token);

      setState(() {
        isLoading = false;
      });

      showSnackBar(context,
          isLogin ? "Login Successfully" : "Account created Successfuly");
    }
    // incase things go wrong
    catch (error) {
      if (isLogin) showSnackBar(context, 'Something went wrong');
      print('straight...');
      print(error);

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    var logoContainer = Container(
      width: 300,
      margin: const EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 20),
      child: Image.asset(!ref.read(themeProvider)
          ? 'assets/logo.png'
          : 'assets/logo_light.png'),
    );

    var authCard = Card(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      // child: SingleChildScrollView(), // will use it later ***
      child: SizedBox(
        width: width > 600 ? width * 0.35 : width * 0.8,
        child: Padding(
          padding:
              const EdgeInsets.only(top: 20, bottom: 10, left: 20, right: 20),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                if (!isLogin)
                  UserImagePicker(
                    onPickImage: (image) {
                      userImage = image;
                    },
                  ),

                // user name
                TextFormField(
                  decoration: const InputDecoration(
                    label: Text("Username: "),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty ||
                        value.length < 4) {
                      return "Minimum Lenght is 4 characters!";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    userName = value!;
                  },
                ),

                // email address
                if (!isLogin)
                  TextFormField(
                    decoration: const InputDecoration(
                      label: Text("Email Address: "),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    textCapitalization: TextCapitalization.none,
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty ||
                          !value.contains("@") ||
                          !value.contains(".com")) {
                        return "Please Enter Valid Email Address";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      userEmail = value!;
                    },
                  ),
                // user password
                TextFormField(
                  decoration: const InputDecoration(
                    label: Text("Password: "),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty ||
                        value.length < 6) {
                      return "Minimum Lenght is 6 characters!";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    userPassword = value!;
                  },
                ),

                // first name
                if (!isLogin)
                  TextFormField(
                    decoration: const InputDecoration(
                      label: Text("First Name: "),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Can't be Empty!";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      firstName = value!;
                    },
                  ),

                // Last Name
                if (!isLogin)
                  TextFormField(
                    decoration: const InputDecoration(
                      label: Text("Last Name: "),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Can't be Empty!";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      print("i'm here");
                      lastName = value!;
                    },
                  ),

                const SizedBox(height: 20),

                if (isLoading) const CircularProgressIndicator(),

                // signing in or signing up
                if (!isLoading)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).colorScheme.primaryContainer,
                    ),
                    onPressed: submit,
                    child: Text(isLogin ? "Log in" : "Sign Up"),
                  ),
                const SizedBox(height: 10),
                // switching between signup and login mode
                if (!isLoading)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isLogin = !isLogin;
                      });
                    },
                    child: Text(
                      isLogin
                          ? "Create New Account"
                          : "Already have an Account?",
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );

    return Scaffold(
      body: Stack(
        children: [
          Center(
            // to lift the content up, when keyboard appears
            child: SingleChildScrollView(
              child: width < 600
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        logoContainer,
                        // form in card to take inputs for sing in / sign up
                        authCard,
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        logoContainer,
                        authCard,
                      ],
                    ),
            ),
          ),
          Positioned(
            top: 20,
            right: 20,
            child: IconButton(
              icon: Icon(
                ref.read(themeProvider) ? Icons.light_mode : Icons.dark_mode,
              ),
              onPressed: () {
                toggleTheme(ref);
              },
            ),
          )
        ],
      ),
    );
  }
}
