// ignore_for_file: camel_case_types, unnecessary_null_comparison


import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:govegan_organics/SharedPreference/sharedprefernce.dart';
import 'package:govegan_organics/Sign/signin.dart';
import 'package:govegan_organics/chatgptlogin/a.dart';

import 'package:govegan_organics/models/cartmodelmap.dart';
import 'package:govegan_organics/models/statemodel.dart';
import 'package:govegan_organics/views/check.dart';

import 'package:govegan_organics/views/rameshwaram.dart';
import 'package:shimmer/shimmer.dart';

class cart extends ConsumerStatefulWidget {
  const cart({super.key});

  @override
  ConsumerState<cart> createState() => _cartState();
}

final totalpro = StateProvider<num>((ref) => 0);

class _cartState extends ConsumerState<cart> {
  var uname = "";

  num totalAmount = 0;

  @override
  void initState() {
    super.initState();
    _initStateAsync();
    ref.read(stateModelsNotifierProvider.notifier).appservercall("", ref);
  }

  Future<void> _initStateAsync() async {
    SharedUserPreferences.init().then((_) {
      setState(() {
        uname = SharedUserPreferences.getMobile() ?? "";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartitems = ref.watch(stateModelsNotifierProvider)['cartItems'];
    if (cartitems == null || cartitems == "") {
      return ListView.builder(
        itemCount: 5,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                ),
        
                width: double.infinity,
                height: 100.0,
              ),
            ),
          );
        },
      );
    }
    return Scaffold(
      backgroundColor: Colors.indigo.shade50,
      appBar: AppBar(
        actions: [
          GestureDetector(
              onTap: () {
                ref.read(resuldata.notifier).update((state) => []);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const GrocerySearchPage()));
              },
              child: const Icon(
                CupertinoIcons.search,
                size: 24,
                color: Colors.black,
              )),
          const Gap(9),
        ],
        backgroundColor: Colors.white,
        title: const Text("Items in bag"),
        centerTitle: true,
      ),
      body: uname != null
          ? cartitems.length > 0
              ? Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          itemCount: cartitems.length,
                          itemBuilder: (context, i) {
                            return Container(
                              margin: const EdgeInsets.all(8.0),
                              padding: const EdgeInsets.all(8.0),
                              color: Colors.white,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CachedNetworkImage(
                                          height: 100,
                                          width: 100,
                                          fit: BoxFit.cover,
                                          imageUrl: cartitems[i]["imageurl"]
                                              .toString(),
                                          progressIndicatorBuilder: (context,
                                                  url, downloadProgress) =>
                                              Center(
                                            child: CircularProgressIndicator(
                                                value:
                                                    downloadProgress.progress),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: Column(children: [
                                            Text(
                                                cartitems[i]['ProductName']
                                                    .toString(),
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text(
                                              " Quantity : ${cartitems[i]['quantity'].toString()} \n Weight : ${cartitems[i]['weight'].toString()} \n Price: ${"₹ ${cartitems[i]['ProductPrice']}"}",
                                              style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w100),
                                            ),
                                            const Gap(15),
                                          ]),
                                        ),
                                        Consumer(
                                          builder: (_, WidgetRef ref, __) {
                                            final cart =
                                                ref.watch(cartProvider);

                                            final productId = cartitems[i]
                                                    ['ProductID']
                                                .toString();
                                            final quantity =
                                                cart[productId] ?? 0;
                                            final sub = cartitems[i]
                                                    ['ProductPrice'] *
                                                quantity;

                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                "₹ $sub",
                                                style: const TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Gap(5),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Consumer(
                                      builder: (context, ref, child) {
                                        final cart = ref.watch(cartProvider);

                                        final productId = cartitems[i]
                                                ['ProductID']
                                            .toString();
                                        final quantity = cart[productId] ?? 0;

                                        return quantity == 0
                                            ? Container()
                                            : Container(
                                                padding:
                                                    const EdgeInsets.all(2),
                                                height: 35,
                                                width: double.infinity,
                                                decoration: const BoxDecoration(
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            width: 1.0,
                                                            color:
                                                                Colors.green),
                                                        top: BorderSide(
                                                            width: 1.0,
                                                            color:
                                                                Colors.green),
                                                        right: BorderSide(
                                                            width: 1.0,
                                                            color:
                                                                Colors.green),
                                                        left: BorderSide(
                                                            width: 1.0,
                                                            color:
                                                                Colors.green)),
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                7))),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Expanded(
                                                      child: InkWell(
                                                        onTap: () async {
                                                          ref
                                                              .read(cartProvider
                                                                  .notifier)
                                                              .decrement(
                                                                  cartitems[i][
                                                                          'ProductID']
                                                                      .toString(),
                                                                  ref,
                                                                  uname,
                                                                  context,cartitems[i][
                                                                          'ProductName']
                                                                      .toString());
                                                        },
                                                        child: Container(
                                                          color: Colors
                                                              .green.shade100,
                                                          child: const Icon(
                                                            Icons.remove,
                                                            color: Colors.green,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const Gap(5),
                                                    Flexible(
                                                      child: Center(
                                                        child: Text(
                                                          '$quantity',
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 12),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: InkWell(
                                                        onTap: () {
                                                          ref
                                                              .read(cartProvider
                                                                  .notifier)
                                                              .increment(
                                                                  cartitems[i][
                                                                          'ProductID']
                                                                      .toString(),
                                                                  ref,
                                                                  uname,
                                                                  context,cartitems[i][
                                                                          'ProductName']
                                                                      .toString(),cartitems[i][
                                                                          'ProductWeight']
                                                                      .toString());
                                                        },
                                                        child: Container(
                                                          color: Colors
                                                              .green.shade100,
                                                          child: const Icon(
                                                            Icons.add,
                                                            color: Colors.green,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                      },
                                    ),
                                  )
                                ],
                              ),
                            );
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Total ",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Consumer(
                            builder: (_, WidgetRef ref, __) {
                              final cart = ref.watch(cartProvider);
                              totalAmount = 0;
                              for (int i = 0; i < cartitems.length; i++) {
                                final productId =
                                    cartitems[i]['ProductID'].toString();
                                final quantity = cart[productId] ?? 0;
                                final sub =
                                    cartitems[i]['ProductPrice'] * quantity;
                                totalAmount += sub;
                              }

                              return Text(
                                "₹ $totalAmount",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              );
                            },
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              ref
                                  .read(cartProvider.notifier)
                                  .submitCartData(ref, context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const PaymentScreen()));
                              ref
                                  .read(paymentprovider.notifier)
                                  .update((state) => totalAmount.toInt());
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.green),
                            ),
                            icon: const Icon(Icons.payment),
                            label: const Text(
                              "Pay",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Badge(
                          backgroundColor: Colors.blue,
                          smallSize: 10,
                          label: Text("0"),
                          child: Icon(Icons.shopping_bag)),
                      Gap(5),
                      Text("Your cart is empty"),
                    ],
                  ),
                )
          : Center(
              child: ElevatedButton(
                onPressed: () {
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
                              Text('Logging in...'),
                            ],
                          ),
                        ),
                      );
                    },
                  );

                  Future.delayed(const Duration(seconds: 2), () {
                    Navigator.of(context).pop();

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const signin()),
                    );
                  });
                },
                child: const Text('Login/Signup'),
              ),
            ),
    );
  }
}
