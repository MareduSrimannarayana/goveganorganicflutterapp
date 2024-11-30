// ignore_for_file: use_build_context_synchronously, unused_result

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:govegan_organics/NEWAPP/new_Home.dart';
import 'package:govegan_organics/Sign/signup.dart';
import 'package:govegan_organics/chatgptlogin/a.dart';
import 'package:govegan_organics/commonUI/SnackBar.dart';
import 'package:govegan_organics/views/usereditpro.dart';
import 'package:http/http.dart' as http;
import '../SharedPreference/sharedprefernce.dart';
import '../commonUI/InputDeco_design.dart';
import '../commonUI/textFieldRandome.dart';

// ignore: camel_case_types
class signin extends ConsumerStatefulWidget {
  const signin({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _signinConsumerState createState() => _signinConsumerState();
}

// ignore: camel_case_types
class _signinConsumerState extends ConsumerState<signin> {
  late TextEditingController _nameController;
  late TextEditingController _mobileController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _mobileController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  Future<void> signin() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16.0),
                Text('Validating user \n Account...'),
              ],
            ),
          ),
        );
      },
    );

    try {
      final response = await http.post(
        Uri.parse("https://aimldeftech.com/laravel/public/api/login"),
        body: {
          "mobilenumber": _mobileController.text,
          "password": _passwordController.text,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          final token = data['user']['token'];

          saveToken(token.toString());
          showSuccessMessage(context,
              message: "Welcome ${_nameController.text}");

          await SharedUserPreferences.setUsername(_nameController.text);
          await SharedUserPreferences.setEmail(
              data['user']['email'].toString());
          await SharedUserPreferences.setMobile(
              data['user']['mobilenumber'].toString());
          await SharedUserPreferences.setGender(
              data['user']['gender'].toString());
          await SharedUserPreferences.setAddress(
              data['user']['address'].toString());

          Navigator.of(context).pop();
          ref.refresh(userProvider);
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (context) => home()));
        }
      }
      showErrorMessage(context,
          message: "Failed to sign in. Please try again.");
    } catch (error) {
      Navigator.of(context).pop();

      showErrorMessage(context,
          message: "Failed to sign in (EXCEPTION OCCURED). Please try again.");
    }
  }

  @override
  Widget build(BuildContext context) {
    var n = generateRandomNumber(360, 600);
    var indexk = n % 20;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Center(
          child: Text(
            "Sign In",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Please Enter the Below Details!",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(110, 250, 5, 5)),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 15, left: 10, right: 10),
                  child: TextFormField(
                    controller: _nameController,
                    keyboardType: TextInputType.text,
                    decoration: buildInputDecoration(
                        Icons.person, "eg: ${nameRam[indexk]}", "Full Name"),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Enter Name';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 15, left: 10, right: 10),
                  child: TextFormField(
                    controller: _mobileController,
                    keyboardType: TextInputType.number,
                    decoration: buildInputDecoration(
                        Icons.phone, "eg: ${n}*******", "Phone No"),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter phone number ';
                      }
                      if (_mobileController.text.length > 11) {
                        return 'Please enter Mobile number lessthan 11 digits. ';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 15, left: 10, right: 10),
                  child: TextFormField(
                    controller: _passwordController,
                    keyboardType: TextInputType.text,
                    decoration: buildInputDecoration(
                        Icons.lock,
                        "eg: ${indexk + 43}${nameRam[indexk]}@${n}",
                        "Password"),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please a Enter Password';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  width: 200,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formkey.currentState!.validate()) {
                        signin();
                      }
                    },
                    child: const Text("Start Shopping"),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 60,
        child: FittedBox(
          fit: BoxFit.fitWidth,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Don't Have an Account? ",
                style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.black,
                    fontSize: 15),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const signup()));
                },
                child: const Text(
                  "Sign Up",
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.green,
                      fontSize: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
