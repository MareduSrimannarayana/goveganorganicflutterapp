// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:convert' as convert;
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:govegan_organics/SharedPreference/sharedprefernce.dart';
import 'package:govegan_organics/Sign/signin.dart';
import 'package:govegan_organics/chatgptlogin/a.dart';
import 'package:govegan_organics/commonUI/SnackBar.dart';

import 'package:govegan_organics/models/statemodel.dart';
import 'package:http/http.dart' as http;

final userProvider = StateProvider<String>((ref) {
  SharedUserPreferences.init();
  var g = SharedUserPreferences.getUsername();
  return g.toString();
});

final genderProvider = StateProvider<String>((ref) {
  SharedUserPreferences.init();
  var g = SharedUserPreferences.getGender();
  return g.toString();
});

class EditProfile extends ConsumerStatefulWidget {
  final String name, email, address, mobile, gender;

  const EditProfile({
    super.key,
    required this.name,
    required this.email,
    required this.address,
    required this.mobile,
    required this.gender,
  });

  @override
  ConsumerState<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends ConsumerState<EditProfile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _mobileController;
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _emailController = TextEditingController(text: widget.email);
    _mobileController = TextEditingController(text: widget.mobile);
    _addressController = TextEditingController(text: widget.address);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _delete(BuildContext context) async {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext ctx) {
        return CupertinoAlertDialog(
          title: const Text('Please Confirm'),
          content: const Text('Are you sure to remove the User Permanently?'),
          actions: [
            CupertinoDialogAction(
              onPressed: () async {
                await request(context);
                Navigator.of(context).pop();
              },
              isDefaultAction: true,
              isDestructiveAction: true,
              child: const Text('Yes'),
            ),
            CupertinoDialogAction(
              onPressed: () {
                Navigator.of(context).pop();
              },
              isDefaultAction: false,
              isDestructiveAction: false,
              child: const Text('No'),
            )
          ],
        );
      },
    );
  }

 

  Future<void> request(BuildContext context) async {
    try {
      final uri =
          Uri.parse("https://aimldeftech.com/laravel/public/api/removeuser");
      String? bearerToken = await getToken();
      final response = await http.post(
        uri,
        headers: {
          'Authorization': 'Bearer $bearerToken',
        },
        body: {
          'userid': _mobileController.text.toString(),
          'username': _nameController.text.toString(),
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
      
        showSuccessMessage(context,
            message: 'User(${widget.name}) Removed successfully!');

        logout();
         Navigator.of(context).pop();

       Navigator.of(context).pop();
        Navigator.of(context).pop();
    
    await Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const signin()));
       
      } else {
     
        showErrorMessage(context,
            message:
                'Failed to delete user and access token. Status code: ${response.statusCode}');
      }
    } catch (error) {
     
      showErrorMessage(context, message: 'Error occurred');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit profile"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  color: Colors.green.shade50,
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelStyle: TextStyle(color: Colors.green),
                      labelText: 'Name',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green, width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Enter Name';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  color: Colors.green.shade50,
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelStyle: TextStyle(color: Colors.green),
                      labelText: 'Email',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green, width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Enter The Email_Address';
                      }
                      if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                          .hasMatch(value)) {
                        return 'Please Enter a valid Email';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  color: Colors.green.shade50,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _mobileController,
                    decoration: const InputDecoration(
                      labelStyle: TextStyle(color: Colors.green),
                      labelText: 'Phone',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green, width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Enter Mobile Number';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Consumer(
                  builder: (_, WidgetRef ref, __) {
                    return Row(
                      children: [
                        const Text(
                          "Gender :",
                          style: TextStyle(fontSize: 20),
                        ),
                        DropdownButton<String>(
                          dropdownColor: Colors.green.shade100,
                          focusColor: Colors.green.shade50,
                          value: ref.watch(genderProvider).toString(),
                          icon: const Icon(Icons.arrow_drop_down),
                          onChanged: (newValue) {
                            ref
                                .read(genderProvider.notifier)
                                .update((state) => newValue ?? widget.gender);
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
                    );
                  },
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.green.shade50, // Custom background color
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: TextFormField(
                    keyboardType: TextInputType.multiline,
                    controller: _addressController,
                    decoration: InputDecoration(
                      labelStyle: const TextStyle(color: Colors.green),
                      labelText: 'Address',
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.green, width: 2.0),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      fillColor: Colors.green.shade50,
                      filled: true,
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Enter Address';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.green, // Text color
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      submit();
                    }
                  },
                  child: const Text(
                    "Submit",
                  ),
                ),
                const Gap(20),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _delete(context);
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(3.0),
                          child: Text(
                            "Delete Account",
                            style: TextStyle(
                              color: Colors.pink,
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                        ),
                      ),
                      const Text(
                        "Deleting your account will remove all your orders, wallet amount and any active referral",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void submit() async {
    final name = _nameController.text;
    final email = _emailController.text;
    final mobile = _mobileController.text;
    final address = _addressController.text;
    final gender = ref.read(genderProvider);
    final id1 = SharedUserPreferences.getMobile();
    print(id1);

    try {
      final url =
          await Uri.parse("https://aimldeftech.com/laravel/public/api/edit");

      final response = await http.post(
        url,
        body: {
          'name': name,
          'email': email,
          'mobile': mobile,
          'address': address,
          'gender': gender,
          'id': id1.toString(),
        },
      );

      if (response.statusCode == 200) {
        final user = convert.jsonDecode(response.body)['user'];
        SharedUserPreferences.setUsername(user['name']);
        SharedUserPreferences.setEmail(user['email']);
        SharedUserPreferences.setMobile(user['mobilenumber']);
        SharedUserPreferences.setGender(user['gender']);
        SharedUserPreferences.setAddress(user['address']);
        ref.read(userProvider.notifier).update(
              (state) => user['name'].toString(),
            );
        await refpro();
        showSuccessMessage(context,
            message: convert.jsonDecode(response.body)['message']);
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      } else {
        print("Server error: ${response.statusCode}");

        showErrorMessage(context,
            message: "${name} Did not Updated Since Status Code Failed!");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  refpro() {
    ref.read(stateModelsNotifierProvider.notifier).appservercall("", ref);
  }
}
