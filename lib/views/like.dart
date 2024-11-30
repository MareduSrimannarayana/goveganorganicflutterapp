import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:govegan_organics/SharedPreference/sharedprefernce.dart';


import 'package:govegan_organics/models/cartmodelmap.dart';
import 'package:govegan_organics/models/likemodel.dart';

import 'package:flutter/material.dart';
import 'package:govegan_organics/models/statemodel.dart';
import 'package:govegan_organics/views/cart.dart';
import 'package:govegan_organics/views/des.dart';
import 'package:govegan_organics/views/rameshwaram.dart';

class ProductlikeListPage extends ConsumerStatefulWidget {
  const ProductlikeListPage({super.key});

  @override
  ConsumerState<ProductlikeListPage> createState() =>
      _ProductlikeListPageConsumerState();
}

class _ProductlikeListPageConsumerState
    extends ConsumerState<ProductlikeListPage> {
  var uname = "";
  @override
  void initState() {
    super.initState();
    call();

    SharedUserPreferences.init().whenComplete(() {
      setState(() {
        uname = SharedUserPreferences.getMobile() ?? "";
      });
    });
  }

  call() async {
    await ref.read(stateModelsNotifierProvider.notifier).appservercall("", ref);
  }

  @override
  Widget build(BuildContext context) {
    final badgecount = ref.watch(cartProvider).length;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Wishlist"),
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
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const cart()));
            },
            child: badgecount == 0
                ? const Icon(
                    CupertinoIcons.shopping_cart,
                    size: 24,
                    color: Colors.black,
                  )
                : Badge(
                    label: Text(badgecount.toString()),
                    child: const Icon(
                      CupertinoIcons.shopping_cart,
                      size: 24,
                      color: Colors.black,
                    )),
          ),
          const Gap(9)
        ],
        backgroundColor: Colors.white,
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final likeproducts =
              ref.watch(stateModelsNotifierProvider)['likedProducts'];
        

          return (likeproducts.isEmpty || likeproducts == null)
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.favorite_border,
                        size: 60,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Your wishlist is empty',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : GridView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 220,
                    mainAxisExtent: 300,
                  ),
                  itemCount: likeproducts.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => description(offer:likeproducts[index]['offer']
                                    .toString() ,rating:likeproducts[index]['rating']
                                    .toString() ,
                                name: likeproducts[index]['ProductName']
                                    .toString(),
                                image:
                                    likeproducts[index]['imageurl'].toString(),
                                des: likeproducts[index]['Descriptions']
                                    .toString(),
                                weight: likeproducts[index]['ProductWeight']
                                    .toString(),
                                price: likeproducts[index]['ProductPrice']
                                    .toString(),
                                quantity: likeproducts[index]['Productquantity']
                                    .toString(),
                                cate: likeproducts[index]['SubCategory']
                                    .toString(),
                                id: likeproducts[index]['ProductID']
                                    .toString())));
                      },
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.all(5),
                        height: 250,
                        width: 170,
                        decoration:
                            BoxDecoration(color: Colors.white, boxShadow: [
                          BoxShadow(
                              offset: const Offset(0, 6),
                              blurRadius: 8,
                              color: Colors.black.withOpacity(.1),
                              spreadRadius: 2)
                        ]),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Stack(
                                children: [
                                  Container(
                                    height: double.infinity,
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(1),
                                    decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5))),
                                    child: CachedNetworkImage(
                                      fit: BoxFit.fill,
                                      imageUrl: likeproducts[index]['imageurl']
                                          .toString(),
                                      progressIndicatorBuilder:
                                          (context, url, downloadProgress) =>
                                              Center(
                                        child: CircularProgressIndicator(
                                            value: downloadProgress.progress),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: InkWell(
                                      onTap: () {
                                        ref
                                            .read(likedItemProvider.notifier)
                                            .toggleLikeda(
                                                likeproducts[index]['ProductID']
                                                    .toString(),
                                                ref,
                                                uname,
                                                context,likeproducts[index]['ProductName'].toString());
                                     
                                      },
                                      child: Container(
                                          color: Colors.transparent,
                                          child: Consumer(
                                            builder: (context, WidgetRef ref,
                                                child) {
                                              final likedItems =
                                                  ref.watch(likedItemProvider);

                                              return Icon(
                                                !likedItems.contains(
                                                        likeproducts[index]
                                                                ['ProductID']
                                                            .toString())
                                                    ? Icons.favorite_border
                                                    : Icons.favorite,
                                                color: !likedItems.contains(
                                                        likeproducts[index]
                                                                ['ProductID']
                                                            .toString())
                                                    ? Colors.black
                                                    : Colors.red,
                                                size: 30,
                                              );
                                            },
                                          )),
                                    ),
                                  ),
                                  //
                                            Positioned(
                                              top: 0,
                                              right: 0,
                                              child: Container(
                                                decoration: const BoxDecoration(
                                                    color: Colors.green,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                5))),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 4),
                                                child: Text(
                                                  '${likeproducts[index]['offer'].toString()} \n OFF',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                            ),
                                  //
                                ],
                              ),
                            ),
                            Text(
                              likeproducts[index]['ProductName'].toString(),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const Gap(1),
                            Text(likeproducts[index]['ProductWeight']
                                .toString()),
                            const Gap(2),
                            Container(
                              padding: const EdgeInsets.only(left: 3, right: 3),
                              height: 23,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Colors.purple.shade100,
                                  borderRadius: BorderRadius.circular(5)),
                              margin: const EdgeInsets.all(1),
                              child: const Center(
                                child: Text("Get for premium"),
                              ),
                            ),
                            const Gap(1),
                            Text(
                              "  ₹ ${likeproducts[index]['ProductPrice']}",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Consumer(
                                builder: (context, ref, child) {
                                  final cart = ref.watch(cartProvider);

                                  final productId = likeproducts[index]
                                          ['ProductID']
                                      .toString();
                                  final quantity = cart[productId] ?? 0;

                                  return quantity == 0
                                      ? InkWell(
                                          onTap: () {
                                            uname == ""
                                                ? (ScaffoldMessenger.of(context)
                                                  ..removeCurrentSnackBar()
                                                  ..showSnackBar(const SnackBar(
                                                      duration:
                                                          Duration(seconds: 2),
                                                      content: Text(
                                                          '!Please Signin/SignUp!'))))
                                                : ref
                                                    .read(cartProvider.notifier)
                                                    .increment(
                                                        likeproducts[index]
                                                                ['ProductID']
                                                            .toString(),
                                                        ref,
                                                        uname,
                                                        context,likeproducts[index]
                                                                ['ProductName']
                                                            .toString(),likeproducts[index]
                                                                ['ProductWeight']
                                                            .toString());
                                          },
                                          child: Container(
                                              height: 35,
                                              width: double.infinity,
                                              decoration: const BoxDecoration(
                                                border: Border(
                                                    bottom: BorderSide(
                                                        width: 1.0,
                                                        color: Colors.pink),
                                                    top: BorderSide(
                                                        width: 1.0,
                                                        color: Colors.pink),
                                                    right: BorderSide(
                                                        width: 1.0,
                                                        color: Colors.pink),
                                                    left: BorderSide(
                                                        width: 1.0,
                                                        color: Colors.pink)),
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5)),
                                              ),
                                              child: const Center(
                                                  child: Text(
                                                "Add to Cart",
                                                style: TextStyle(
                                                    color: Colors.pink,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ))),
                                        )
                                      : Container(
                                          padding: const EdgeInsets.all(2),
                                          height: 35,
                                          width: double.infinity,
                                          decoration: const BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(
                                                      width: 1.0,
                                                      color: Colors.pink),
                                                  top: BorderSide(
                                                      width: 1.0,
                                                      color: Colors.pink),
                                                  right: BorderSide(
                                                      width: 1.0,
                                                      color: Colors.pink),
                                                  left: BorderSide(
                                                      width: 1.0,
                                                      color: Colors.pink)),
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(7))),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: InkWell(
                                                  onTap: () {
                                                    ref
                                                        .read(cartProvider
                                                            .notifier)
                                                        .decrement(
                                                            likeproducts[index][
                                                                    'ProductID']
                                                                .toString(),
                                                            ref,
                                                            uname,
                                                            context,likeproducts[index]
                                                                ['ProductName']
                                                            .toString());
                                                  },
                                                  child: Container(
                                                    color: Colors.pink.shade100,
                                                    child: const Icon(
                                                      Icons.remove,
                                                      color: Colors.pink,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const Gap(5),
                                              Flexible(
                                                child: Center(
                                                  child: Text(
                                                    '$quantity',
                                                    style: const TextStyle(
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
                                                            likeproducts[index][
                                                                    'ProductID']
                                                                .toString(),
                                                            ref,
                                                            uname,
                                                            context,likeproducts[index]
                                                                ['ProductName']
                                                            .toString(),likeproducts[index]
                                                                ['ProductWeight']
                                                            .toString());
                                                  },
                                                  child: Container(
                                                    color: Colors.pink.shade100,
                                                    child: const Icon(
                                                      Icons.add,
                                                      color: Colors.pink,
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
                      ),
                    );
                  },
                );
        },
      ),
    );
  }
}
