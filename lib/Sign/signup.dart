// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:govegan_organics/NEWAPP/new_Home.dart';
import 'package:govegan_organics/chatgptlogin/a.dart';
import 'package:govegan_organics/commonUI/SnackBar.dart';
import 'package:govegan_organics/views/usereditpro.dart';

import '../SharedPreference/sharedprefernce.dart';
import '../commonUI/textFieldRandome.dart';

import 'package:http/http.dart';

import '../commonUI/InputDeco_design.dart';
import 'signin.dart';

// ignore: camel_case_types
class signup extends ConsumerStatefulWidget {
  const signup({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _signupState createState() => _signupState();
}

// ignore: camel_case_types
class _signupState extends ConsumerState<signup> {
  String name = "", email = "", phone = "", address = "", gender = "";

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _confirmpasswordController =
      TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  Future<void> sigupf(ref) async {
    try {
      var response = await post(
        Uri.parse("https://aimldeftech.com/laravel/public/api/register"),
        body: {
          "name": _nameController.text,
          "email": _emailController.text,
          "mobilenumber": _mobileController.text,
          "address": _addressController.text,
          "password": _passwordController.text,
          "conformpassword": _passwordController.text,
          "gender": dropdowngender,
        },
      );

      var data = jsonDecode(response.body);

      if (response.statusCode == 200 &&
          data['message'] == "User registered successfully") {
        showSuccessMessage(context, message: "User registered successfully");

        final token = jsonDecode(response.body)['user']['token'];

        saveToken(token.toString());

        showSuccessMessage(context, message: "Welcome ${_nameController.text}");

        await SharedUserPreferences.setUsername(_nameController.text);
        await SharedUserPreferences.setEmail(_emailController.text);
        await SharedUserPreferences.setMobile(_mobileController.text);
        await SharedUserPreferences.setAddress(_addressController.text);
        await SharedUserPreferences.setGender(dropdowngender!);
        ref.refresh(userProvider);
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const home()));
      } else {
        showErrorMessage(context, message: data['message']);
      }
    } catch (er) {
      showErrorMessage(context,
          message: "Unable To SignUp! \n Please Try Again");
    }
  }

  String? dropdowngender = "Male";

  @override
  Widget build(BuildContext context) {
    var n = generateRandomNumber(360, 600);
    var indexk = n % 20;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Center(
          child: Text(
            "SignUp",
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
                  "Create a New account",
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
                    onSaved: (value) {
                      name = value!;
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 15, left: 10, right: 10),
                  child: TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.text,
                    decoration: buildInputDecoration(Icons.email,
                        "eg: ${nameRam[indexk]}${n % 60}@gmail.com", "Email"),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please a Enter The Email_Address';
                      }
                      if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                          .hasMatch(value)) {
                        return 'Please Enter a valid Email';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      email = value!;
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
                        Icons.phone, 'eg: $n*******', "Phone No"),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter phone number ';
                      }
                      if (_mobileController.text.length > 11) {
                        return 'Please enter Mobile number lessthan 11 digits. ';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      phone = value!;
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 15, left: 10, right: 10),
                  child: TextFormField(
                    controller: _addressController,
                    keyboardType: TextInputType.multiline,
                    decoration: buildInputDecoration(
                        Icons.location_history,
                        "eg: ${n - 57}/${3 + indexk},${placeRam[(indexk * n) % 20]}",
                        "address"),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please a Enter The Address';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.all(10),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(bottom: 15, left: 10, right: 10),
                    child: Row(
                      children: [
                        const Text(
                          "Gender :",
                          style: TextStyle(fontSize: 20),
                        ),
                        DropdownButton<String>(
                          dropdownColor:
                              const Color.fromARGB(255, 81, 177, 255),
                          value: dropdowngender,
                          icon: const Icon(Icons.arrow_drop_down),
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdowngender = newValue;
                            });
                          },
                          items: const [
                            DropdownMenuItem<String>(
                              value: "Male",
                              child: Text("Male"),
                            ),
                            DropdownMenuItem<String>(
                              value: "Female",
                              child: Text("Female"),
                            ),
                            DropdownMenuItem<String>(
                              value: "Others",
                              child: Text("Others"),
                            ),
                          ],
                        ),
                      ],
                    ),
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
                        "eg: ${indexk + 60}${nameRam[indexk]}@${n % 90}",
                        "Password"),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please a Enter Password';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 15, left: 10, right: 10),
                  child: TextFormField(
                    controller: _confirmpasswordController,
                    obscureText: true,
                    keyboardType: TextInputType.text,
                    decoration: buildInputDecoration(
                        Icons.lock,
                        "eg: ${indexk + 60}${nameRam[indexk]}@${n % 90}",
                        "Confirm Password"),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please re-enter password';
                      }
                      print(_passwordController.text);

                      print(_confirmpasswordController.text);

                      if (_passwordController.text !=
                          _confirmpasswordController.text) {
                        return "Password does not match";
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
                        sigupf(ref);

                        print("data has no error in validation");
                      } else {
                        print("data has error in validation");
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
                "Do you Have an Account?",
                style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.black,
                    fontSize: 15),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const signin()));
                },
                child: const Text(
                  "Signin",
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
