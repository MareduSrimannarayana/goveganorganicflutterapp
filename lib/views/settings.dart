// ignore_for_file: use_build_context_synchronously, avoid_print, unused_result, unused_catch_clause

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gap/gap.dart';
import 'package:govegan_organics/SharedPreference/sharedprefernce.dart';
import 'package:govegan_organics/Sign/signin.dart';
import 'package:govegan_organics/chatgptlogin/a.dart';
import 'package:govegan_organics/commonUI/SnackBar.dart';


import 'package:image_picker/image_picker.dart';

import 'package:govegan_organics/models/cartmodelmap.dart';

import 'package:govegan_organics/views/like.dart';
import 'package:govegan_organics/views/orderdetailspage.dart';

import 'package:govegan_organics/views/usereditpro.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

// ignore: camel_case_types
class pro extends ConsumerStatefulWidget {
  const pro({super.key});

  @override
  ConsumerState<pro> createState() => _proState();
}

// ignore: camel_case_types
class _proState extends ConsumerState<pro> {
  String username = "";
  String usermobile = "";
  String email = "";
  String address = "";
  String gender = "";

  @override
  void initState() {
    super.initState();
    SharedUserPreferences.init().whenComplete(() {
      setState(() {
        username = SharedUserPreferences.getUsername() ?? "";
        usermobile = SharedUserPreferences.getMobile() ?? "";
        email = SharedUserPreferences.getEmail() ?? "";
        address = SharedUserPreferences.getAddress() ?? "";
        gender = SharedUserPreferences.getGender() ?? "";
      });
    });
  }



  void clearPreferences(BuildContext context) async {
    await ref.read(cartProvider.notifier).submitCartData(ref, context);
    await logout();
    await SharedUserPreferences.logout();
    showSuccessMessage(context,
        message: "LogOut Successfully!\nThanks For Visiting");

    Navigator.of(context).pop();

  
    
    await Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const signin()));
          
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo.shade50,
        title: const Text('Account'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Material(
          color: Colors.indigo.shade50,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                height: 120,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 97, 202, 101),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(5),
                  ),
                ),
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(4.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 45,
                        child: Center(
                          child: Icon(
                            Icons.person,
                            size: 60,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "User: $username",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "Mobile: $usermobile",
                            style: const TextStyle(fontSize: 14),
                            maxLines: 2,
                          ),
                          const SizedBox(height: 5),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => EditProfile(
                                  name: username,
                                  email: email,
                                  address: address,
                                  mobile: usermobile,
                                  gender: gender,
                                ),
                              ));
                            },
                            child: const Row(
                              children: [
                                Text(
                                  "Edit",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(
                                  Icons.edit,
                                  color: Colors.red,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Container(
                height: 60,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(5),
                    bottomRight: Radius.circular(5),
                  ),
                ),
                child: const ListTile(
                  leading: Icon(
                    Icons.home_max_outlined,
                    color: Colors.white,
                  ),
                  title: Text(
                    "Renew Your Membership",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  trailing: Icon(
                    Icons.keyboard_arrow_right,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                       
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProductlikeListPage(),
                          ),
                        );
                      },
                      child: const ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: 20,
                          child: Icon(
                            CupertinoIcons.heart_fill,
                            color: Colors.red,
                          ),
                        ),
                        title: Text(
                          "Liked Products",
                          style: TextStyle(fontSize: 16),
                        ),
                        trailing: Icon(Icons.keyboard_arrow_right),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const OrderDetailsPage(),
                          ),
                        );
                      },
                      child: const ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: 20,
                          child: Icon(
                            Icons.delivery_dining,
                            color: Colors.black,
                          ),
                        ),
                        title: Text(
                          "Order Details",
                          style: TextStyle(fontSize: 16),
                        ),
                        trailing: Icon(Icons.keyboard_arrow_right),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const VeganChallengesPage(),
                          ),
                        );
                      },
                      child: const ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: 20,
                          child: Icon(
                            Icons.directions_run,
                            color: Colors.green,
                          ),
                        ),
                        title: Text(
                          "Vegan Challenges",
                          style: TextStyle(fontSize: 16),
                        ),
                        trailing: Icon(Icons.keyboard_arrow_right),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const VeganEventsPage(),
                          ),
                        );
                      },
                      child: const ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: 20,
                          child: Icon(
                            Icons.event,
                            color: Colors.blue,
                          ),
                        ),
                        title: Text(
                          "Vegan Events",
                          style: TextStyle(fontSize: 16),
                        ),
                        trailing: Icon(Icons.keyboard_arrow_right),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FeedbackPage(),
                          ),
                        );
                      },
                      child: const ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: 20,
                          child: Icon(
                            Icons.feedback,
                            color: Colors.black,
                          ),
                        ),
                        title: Text(
                          "Feed Back",
                          style: TextStyle(fontSize: 16),
                        ),
                        trailing: Icon(Icons.keyboard_arrow_right),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const TermsAndConditionsPage(),
                          ),
                        );
                      },
                      child: const ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: 20,
                          child: Icon(
                            Icons.description,
                            color: Colors.black,
                          ),
                        ),
                        title: Text(
                          "Terms and Conditions",
                          style: TextStyle(fontSize: 16),
                        ),
                        trailing: Icon(Icons.keyboard_arrow_right),
                      ),
                    ),
                    const Gap(10),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          showCupertinoDialog(
            context: context,
            builder: (BuildContext ctx) {
              return CupertinoAlertDialog(
                title: const Text('Please Confirm '),
                content: const Text('Are you sure to Logout?'),
                actions: [
                  CupertinoDialogAction(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      clearPreferences(context);
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
        },
        child: const Icon(Icons.logout),
      ),
    );
  }
}

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Terms and Conditions',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'By using our grocery app, you agree to the following terms and conditions:',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                '1. You must be 18 years or older to use our app.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                '2. All products listed on the app are subject to availability.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                '3. Prices displayed on the app are in USD and inclusive of all taxes.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                '4. We reserve the right to cancel any order or refuse service to anyone for any reason at any time.',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class VeganChallengesPage extends StatelessWidget {
  const VeganChallengesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vegan Challenges'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Explore various vegan challenges here!',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text('30-Day Vegan Challenge'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text('Meatless Mondays'),
            ),
          ],
        ),
      ),
    );
  }
}

class VeganEventsPage extends StatelessWidget {
  const VeganEventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vegan Events'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Discover upcoming vegan events near you!',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text('View Upcoming Events'),
            ),
          ],
        ),
      ),
    );
  }
}

final feedbackLoadingProvider =
    StateNotifierProvider<FeedbackLoadingNotifier, bool>(
        (ref) => FeedbackLoadingNotifier());

class FeedbackLoadingNotifier extends StateNotifier<bool> {
  FeedbackLoadingNotifier() : super(false);

  void setLoading(bool loading) {
    state = loading;
  }
}

class FeedbackPage extends ConsumerWidget {
  final TextEditingController _feedbackController = TextEditingController();

  FeedbackPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(feedbackLoadingProvider);

    void submitFeedback() async {
      ref.read(feedbackLoadingProvider1.notifier).setLoading(true);

      await SharedUserPreferences.init();
      final String user = SharedUserPreferences.getMobile().toString();

      final url = Uri.parse("https://aimldeftech.com/feedback.php");
      String? bearerToken = await getToken();
      try {
        final response = await http.post(
          url,
          body: {
            'userid': user,
            'feedback': _feedbackController.text,
          },
          headers: {'Authorization': 'Bearer $bearerToken'},
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          showDialog(
            context: context,
            barrierDismissible: false,
            barrierColor: Colors.transparent,
            builder: (context) {
              return AlertDialog(
                insetPadding: EdgeInsets.zero,
                title: const Text('Feedback Submitted'),
                content: const Text('Thank you for your feedback!'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _feedbackController.clear();
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        } else {
          showDialog(
            context: context,
            barrierDismissible: true,
            barrierColor: Colors.transparent,
            builder: (context) {
              return AlertDialog(
                insetPadding: EdgeInsets.zero,
                title: const Text('Feedback Submission Failed'),
                content: const Text(
                    'Failed to submit feedback. Please try again later.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      } catch (er) {
        showErrorMessage(context, message: "failed ");
      } 
    
      ref.read(feedbackLoadingProvider1.notifier).setLoading(false);

   
      ref.read(raingprovider1.notifier).update((state) => 0.00);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Submit Feedback'),
        backgroundColor: Colors.white, // Customizing app bar color
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/image1.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment:
                  CrossAxisAlignment.stretch, // Align children to full width
              children: [
                Expanded(
                  child: TextField(
                    controller: _feedbackController,
                    maxLines: 100,
                    minLines: 5,
                    decoration: const InputDecoration(
                      labelText: 'Feedback in 350 words',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors
                          .white, // Adding background color to the text field
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
  onPressed: submitFeedback,
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.blue, // Set the button's background color
    padding: const EdgeInsets.symmetric(vertical: 16), // Increase button padding
  ),
  child: const Text('Submit',style: TextStyle(color: Colors.black),),
),

              ],
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.5), // Semi-transparent overlay
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}

final feedbackLoadingProvider1 =
    StateNotifierProvider<FeedbackLoadingNotifier, bool>(
        (ref) => FeedbackLoadingNotifier());

class FeedbackLoadingNotifier1 extends StateNotifier<bool> {
  FeedbackLoadingNotifier1() : super(false);

  void setLoading1(bool loading) {
    state = loading;
  }
}

class FeedbackPage1 extends ConsumerStatefulWidget {
  const FeedbackPage1({
    super.key,
    required this.orderid,
    required this.productid,
  });
  final String orderid;
  final String productid;

  @override
  ConsumerState<FeedbackPage1> createState() => _FeedbackPage1ConsumerState();
}

class _FeedbackPage1ConsumerState extends ConsumerState<FeedbackPage1> {
  final TextEditingController _feedback1Controller1 = TextEditingController();

  late final TextEditingController _feedback1Controller2;
  late final TextEditingController _feedback1Controller3;
  File? selectedImage;

  Uint8List? webselectedImage = Uint8List(8);

  @override
  void initState() {
    super.initState();
    _feedback1Controller2 = TextEditingController(text: widget.productid);
    _feedback1Controller3 = TextEditingController(text: widget.orderid);
  }

  Future pickImage(ImageSource imageSource) async {
    if (!kIsWeb) {
      XFile? returnedImage = await ImagePicker().pickImage(source: imageSource);
      if (returnedImage == null) return;
      setState(() {
        selectedImage = File(returnedImage.path);
      });
    } else if (kIsWeb) {
      XFile? returnedImage = await ImagePicker().pickImage(source: imageSource);

      if (returnedImage == null) {
        return;
      } else {
        var bytes = await returnedImage.readAsBytes();

        setState(() {
          webselectedImage = Uint8List.fromList(bytes);
          selectedImage = File(returnedImage.path);
        });
      }
    }
  }

  Future<void> _submitFeedback() async {
    final url = Uri.parse("https://aimldeftech.com/productsfeedback.php");
    String? bearerToken = await getToken();

    try {
      var request = http.MultipartRequest('POST', url)
        ..fields['userid'] = SharedUserPreferences.getMobile().toString()
        ..fields['productid'] = _feedback1Controller2.text.toString()
        ..fields['orderid'] = _feedback1Controller3.text.toString()
        ..fields['review'] = _feedback1Controller1.text.toUpperCase()
        ..fields['rating'] = ref.read(raingprovider1).toString()
        ..files.add(http.MultipartFile(
          'image',
          selectedImage!.readAsBytes().asStream(),
          selectedImage!.lengthSync(),
          filename: selectedImage!.path.split('/').last,
        ));

      request.headers.addAll({'Authorization': 'Bearer $bearerToken'});

      var response = await http.Response.fromStream(await request.send());

      if (response.statusCode == 200 || response.statusCode == 201) {
  
        showDialog(
          context: context,
          barrierDismissible: false,
          barrierColor: Colors.transparent,
          builder: (context) {
            return AlertDialog(
              insetPadding: EdgeInsets.zero,
              title: const Text('Feedback Submitted'),
              content: Text(response.body),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _feedback1Controller1.clear();
                    _feedback1Controller2.clear();
                    ref.refresh(raingprovider1);
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        print("Failed to submit feedback: ${response.statusCode}");
        
        showDialog(
          context: context,
          barrierDismissible: true,
          barrierColor: Colors.transparent,
          builder: (context) {
            return AlertDialog(
              insetPadding: EdgeInsets.zero,
              title: const Text('Feedback Submission Failed'),
              content: const Text(
                  'Failed to submit feedback. Please try again later.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } on SocketException catch (_) {
      showErrorMessage(context, message: "No internet connection");
    } on HttpException catch (e) {
      showErrorMessage(context, message: "HTTP error");
    } on FormatException catch (e) {
      showErrorMessage(context, message: "Format error");
    } catch (e) {
      showErrorMessage(context, message: "Unexpected error");
    }
  }

  SOURCE() {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.transparent,
      builder: (context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          title: const Text('select source'),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            ListTile(
              leading: const Icon(Icons.camera),
              title: const Text('Camera'),
              onTap: () {
                pickImage(ImageSource.camera);

                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.image),
              title: const Text('Gallery'),
              onTap: () {
                pickImage(ImageSource.gallery);

                Navigator.pop(context);
              },
            ),
          ]),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(feedbackLoadingProvider1);

    return Container(
      color: Colors.white,
      // decoration: const BoxDecoration(
      //     image: DecorationImage(
      //         image: AssetImage("images/image1.jpg"), fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Submit Feedback'),
        ),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      !kIsWeb
                          ? selectedImage != null
                              ? GestureDetector(
                                  onTap: () {
                                    SOURCE();
                                  },
                                  child: Image.file(
                                    selectedImage!,
                                    height: 170,
                                    width: 170,
                                    fit: BoxFit.contain,
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () {
                                    SOURCE();
                                  },
                                  child: Container(
                                    height: 170,
                                    width: 170,
                                    color: Colors.grey.shade100,
                                    padding: const EdgeInsets.all(5),
                                    child: const Center(
                                      child: Text(
                                        "Please Select/\nUpload the Image",
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                )
                          : selectedImage != null
                              ? Image.memory(
                                  webselectedImage!,
                                  height: 170,
                                  width: 170,
                                  fit: BoxFit.contain,
                                )
                              : const Text(
                                  "Please Select/Upload the Image",
                                  style: TextStyle(color: Colors.red),
                                ),
                      const SizedBox(height: 20),
                      const Gap(10),
                      TextField(
                        enabled: false,
                        controller: _feedback1Controller3,
                        maxLines: 1,
                        minLines: 1,
                        decoration: const InputDecoration(
                          labelText: 'orderid',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const Gap(10),
                      TextField(
                        enabled: false,
                        controller: _feedback1Controller2,
                        maxLines: 1,
                        minLines: 1,
                        decoration: const InputDecoration(
                          labelText: 'ProductID',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const Gap(10),
                      TextField(
                        controller: _feedback1Controller1,
                        maxLines: 10,
                        minLines: 1,
                        decoration: const InputDecoration(
                          labelText: 'Feedback',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          RatingBar.builder(
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              ref
                                  .read(raingprovider1.notifier)
                                  .update((state) => rating.toDouble());
                            },
                            initialRating: 0,
                            minRating: 0.5,
                            allowHalfRating: true,
                            direction: Axis.horizontal,
                            itemCount: 5,
                            itemSize: 15,
                          ),
                          Text(ref.watch(raingprovider1).toString())
                        ],
                      ),
                      const Gap(10),
                      ElevatedButton(style: ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(Colors.blue), // Change color as needed
  ),
                        onPressed: () async {
                          _submitFeedback();
                        },
                        child: const Text('Submit',style: TextStyle(color: Colors.black),),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

final raingprovider1 = StateProvider((ref) => 0.00);
