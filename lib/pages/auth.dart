import 'dart:io';
import 'package:comman/api/auth/register_user.dart';
import 'package:comman/api/auth/user_auth.dart';
import 'package:comman/provider/token_provider.dart';
import 'package:comman/widgets/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen(
      {super.key,
      required this.changeTheme,
      required this.currentTheme,
      required this.storage});

  final void Function() changeTheme;
  final currentTheme;
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
  var isBusy = false;

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
        isBusy = true;
      });

      // login mode, authentication
      if (isLogin) {
        print('logging.....');

        var token = await userAuth(
          username: userName,
          password: userPassword,
        );

        if (token.isEmpty) return;

        print('token: ${ref.read(tokenProvider.state).state}');

        ref.read(tokenProvider.state).state = token;

        widget.storage.write(key: 'token', value: token);

        print('token: ${ref.read(tokenProvider.state).state}');
      } else {
        print('registering...');

        await registerUser(
          username: userName,
          password: userPassword,
          email: userEmail,
          firstName: firstName,
          lastName: lastName,
        );
      }

      setState(() {
        isBusy = false;
      });

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              isLogin ? "Login Successfully" : "Account created Successfuly"),
          duration: const Duration(seconds: 3),
        ),
      );
    }
    // incase things go wrong
    catch (error) {
      print(error);

      setState(() {
        isBusy = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    var logoContainer = Container(
      width: 200,
      margin: const EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 20),
      child: Image.asset('assets/logo.png'),
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
                          !value.contains("@")) {
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

                if (isBusy) const CircularProgressIndicator(),

                // signing in or signing up
                if (!isBusy)
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
                if (!isBusy)
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
      // backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
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
    );
  }
}



// sign up mode, creating account
      // else {
      //   final userCredential = await firebase.createUserWithEmailAndPassword(
      //       email: userEmail, password: userPassword);

      //   // targeting user_images folder on storage at firebase, if the user_images folder doesn't exist it will be created automatically
      //   final storageRef = FirebaseStorage.instance
      //       .ref()
      //       .child('user_images')
      //       .child('${userCredential.user!.uid}.jpg');

      //   await storageRef.putFile(userImage!);
      //   final imageURL = await storageRef.getDownloadURL();

      //   await FirebaseFirestore.instance
      //       .collection('users')
      //       .doc(userCredential.user!.uid)
      //       .set({
      //     'username': userName,
      //     'email': userEmail,
      //     'image_url': imageURL,
      //   });
      // }
      // incase things go well