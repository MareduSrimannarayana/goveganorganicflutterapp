// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously, avoid_print

import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:govegan_organics/SharedPreference/sharedprefernce.dart';

import 'package:govegan_organics/models/cartmodelmap.dart';
import 'package:govegan_organics/models/statemodel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

int generateRandomNumber() {
  Random random = Random();
  return random.nextInt(999999) + 100000;
}

final buttonStateProvider = StateProvider<bool>((ref) => false);
final checkoutProvider = ChangeNotifierProvider((ref) => CheckoutDetails());
final paymentprovider = StateProvider((ref) => 0);
final refpro = ProviderContainer();

class CheckoutDetails extends ChangeNotifier {
  String firstName = SharedUserPreferences.getUsername().toString();

  String address = SharedUserPreferences.getAddress().toString();

  bool isCashOnDelivery = true;
  DateTime OrderDate = DateTime.now();
  DateTime deliveryDate = DateTime.now().add(const Duration(days: 3));

  void updateCheckout({
    required String firstName,
    required String address,
    required bool isCashOnDelivery,
    required DateTime OrderDate,
    required DateTime deliveryDate,
  }) {
    this.firstName = firstName;

    this.address = address;

    this.isCashOnDelivery = isCashOnDelivery;
    this.deliveryDate = OrderDate;
    this.deliveryDate = deliveryDate;
    notifyListeners();
  }
}

class CheckoutPage extends ConsumerWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final checkout = ref.watch(checkoutProvider);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text(' Name: ${checkout.firstName}'),
                const SizedBox(height: 10),
                Text('Address: ${checkout.address}'),
                const SizedBox(height: 10),
                Text('Total Amount: ${ref.watch(paymentprovider).toString()}'),
                const SizedBox(height: 10),
                Text(
                    'Payment Method: ${checkout.isCashOnDelivery ? 'Cash on Delivery' : 'Online Payment'}'),
                const SizedBox(height: 10),
                Text('Delivery Date: ${checkout.deliveryDate.toString()}'),
                const SizedBox(height: 10),
                Text('Ordered Date: ${checkout.OrderDate.toString()}'),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CheckoutPage1()));
                  },
                  child: const Text('Confirm Order'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class YourCheckoutForm extends ConsumerWidget {
  const YourCheckoutForm({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final checkout = ref.read(checkoutProvider);

    return Column(
      children: [
        CheckboxListTile(
          title: const Text('Cash on Delivery'),
          value: checkout.isCashOnDelivery,
          onChanged: (value) {
            checkout.updateCheckout(
                firstName: checkout.firstName,
                address: checkout.address,
                isCashOnDelivery: value ?? false,
                deliveryDate: checkout.deliveryDate,
                OrderDate: checkout.OrderDate);
          },
        ),
      ],
    );
  }
}

class CheckoutPage1 extends ConsumerWidget {
  const CheckoutPage1({super.key});

  Future<void> submitOrderDetails(
      CheckoutDetails checkoutDetails, BuildContext context, ref) async {
    const url = 'https://aimldeftech.com/orderdetails.php';

    final jsonBody = convert.json.encode({
      'mobile': SharedUserPreferences.getMobile(),
      'firstName': SharedUserPreferences.getUsername(),
      'address': SharedUserPreferences.getAddress(),
      'isCashOnDelivery': checkoutDetails.isCashOnDelivery,
      'deliveryDate': checkoutDetails.deliveryDate.toIso8601String(),
      'OrderDate': checkoutDetails.OrderDate.toIso8601String(),
    });
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonBody,
      );

      if (response.statusCode == 200 ||response.statusCode==201) {
        print(
            " this is deleviry date sent t0 the server ${checkoutDetails.deliveryDate.toIso8601String()}");
        ref.read(cartProvider.notifier).delete();
 
   await   ref.read(stateModelsNotifierProvider.notifier).appservercall("", ref);

        print('Order details submitted successfully');
        
        await showSuccessDialog(context);
      } else {
        print('Failed to submit order details: ${response.body}');
      }
    } catch (e) {
      print('Error submitting order details: $e');
    }
  }

  Future<void> showSuccessDialog(BuildContext context) async {
    await showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          title: const Text('Success'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Icon(Icons.check_circle, color: Colors.green, size: 50),
                Text('Order submitted successfully!'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSubmitting = ref.watch(buttonStateProvider);
    final checkout = ref.read(checkoutProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/image1.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(color: Colors.black.withOpacity(0.5)),
            ),
          ),
          Center(
            child: Container(
              width: 200,
              height: 200,
              color: Colors.white,
              child: isSubmitting
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                            'ORDER DATE: ${checkout.OrderDate.day}:${checkout.OrderDate.month}:${checkout.OrderDate.year}'),
                        Text(
                            'ORDER TIME: ${checkout.OrderDate.hour}:${checkout.OrderDate.minute}:${checkout.OrderDate.second}'),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () async {
                            ref
                                .read(buttonStateProvider.notifier)
                                .update((state) => true);
                            await submitOrderDetails(
                                ref.read(checkoutProvider), context, ref);
                            ref
                                .read(buttonStateProvider.notifier)
                                .update((state) => false);
                          },
                          child: const Text('Confirm Order'),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
