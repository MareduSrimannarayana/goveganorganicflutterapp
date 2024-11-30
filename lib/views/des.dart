// ignore_for_file: non_constant_identifier_names, prefer_const_constructors_in_immutables, camel_case_types

import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:govegan_organics/SharedPreference/sharedprefernce.dart';

import 'package:govegan_organics/models/cartmodelmap.dart';
import 'package:govegan_organics/models/likemodel.dart';
import 'package:govegan_organics/models/statemodel.dart';
import 'package:govegan_organics/views/cart.dart';
import 'package:govegan_organics/views/rameshwaram.dart';

class description extends ConsumerStatefulWidget {
  description({
    super.key,
    required this.name,
    required this.image,
    required this.des,
    required this.weight,
    required this.price,
    required this.quantity,
    required this.cate,
    required this.id,
    required this.offer,
    required this.rating,
  });

  final String name;
  final String image;
  final String des;
  final String weight;
  final String price;
  final String quantity;
  final String cate;
  final String id;
  final String offer;
  final String rating;

  @override
  ConsumerState<description> createState() => _descriptionState();
}

class _descriptionState extends ConsumerState<description> {
  var uname = "";
  @override
  void initState() {
    super.initState();
    _initStateAsync();
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
    print(widget.id.toString());
    final badgecount = ref.watch(cartProvider).length;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(widget.name.toString()),
          actions: [
            GestureDetector(
              onTap: () {
                ref.read(resuldata.notifier).update((state) => []);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const GrocerySearchPage()));
              },
              child: const Padding(
                padding: EdgeInsets.all(6.0),
                child: Icon(
                  Icons.search,
                  size: 24,
                  color: Colors.green,
                ),
              ),
            ),
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
                      color: Colors.green,
                    )
                  : Badge(
                      label: Text(badgecount.toString()),
                      child: const Icon(
                        CupertinoIcons.shopping_cart,
                        size: 24,
                        color: Colors.green,
                      )),
            ),
            const Gap(9),
          ],
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.all(8),
                  height: MediaQuery.of(context).size.height * 0.40,
                  width: double.infinity,
                  child: Stack(
                    children: [
                      Container(
                        height: double.infinity,
                        width: double.infinity,
                        padding: const EdgeInsets.all(1),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: CachedNetworkImage(
                          fit: BoxFit.fill,
                          imageUrl: widget.image.toString(),
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) => Center(
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
                            ref.read(likedItemProvider.notifier).toggleLikeda(
                                widget.id.toString(),
                                ref,
                                uname.toString(),
                                context,
                                widget.name.toString());
                          },
                          child: Container(
                            color: Colors.transparent,
                            child: Consumer(
                              builder: (context, WidgetRef ref, child) {
                                final likedItems = ref.watch(likedItemProvider);
                                return Icon(
                                  !likedItems.contains(widget.id.toString())
                                      ? Icons.favorite_border
                                      : Icons.favorite,
                                  color:
                                      !likedItems.contains(widget.id.toString())
                                          ? Colors.red
                                          : Colors.red,
                                  size: 30,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          decoration: const BoxDecoration(
                              color: Colors.green,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          child: Text(
                            '${widget.offer} \n OFF',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 22),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  widget.name,
                  style: const TextStyle(
                      fontSize: 25,
                      color: Colors.pink,
                      fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    RatingBar(
                      ratingWidget: RatingWidget(
                        full:  const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        half: const Icon(
                          Icons.star_half,
                          color: Colors.amber,
                        ),
                        empty:  const Icon(
                          Icons.star_border_outlined,
                        ),
                      ),
                      onRatingUpdate: (value) {},
                      initialRating: double.parse(widget.rating),
                      minRating: 1,
                      allowHalfRating: true,
                      maxRating: 5,
                      itemSize: 15,
                      ignoreGestures: true,
                    ),
                    const SizedBox(width: 5),
                    const Text("total 12 reviews",
                        style: TextStyle(fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Description:",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: ExpandableText(
                        widget.des,
                        style: const TextStyle(fontSize: 16),
                        expandText: 'Read more',
                        collapseText: 'Read less',
                        maxLines:
                            3, // Adjust the number of lines to display before truncating
                        linkColor:
                            Colors.blue, // Customize link color if needed
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "₹ ${widget.price}",
                      style: const TextStyle(
                          fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    Consumer(
                      builder: (context, ref, child) {
                        final cart = ref.watch(cartProvider);

                        final productId = widget.id;
                        final quantity = cart[productId] ?? 0;

                        return quantity == 0
                            ? InkWell(
                                onTap: () {
                                  uname == ""
                                      ? (ScaffoldMessenger.of(context)
                                        ..removeCurrentSnackBar()
                                        ..showSnackBar(const SnackBar(
                                          duration: Duration(seconds: 2),
                                          content:
                                              Text('Please Sign in/Sign Up!'),
                                        )))
                                      : ref
                                          .read(cartProvider.notifier)
                                          .increment(widget.id, ref, uname,
                                              context, widget.name.toString(),widget.weight.toString());
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  height: 27,
                                  width: 60,
                                  decoration: const BoxDecoration(
                                    color: Colors.pink,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      "ADD",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              )
                            : AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                padding: const EdgeInsets.all(5),
                                height: 33,
                                width: 90,
                                decoration: const BoxDecoration(
                                  color: Colors.pink,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(7)),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        ref
                                            .read(cartProvider.notifier)
                                            .decrement(
                                                widget.id,
                                                ref,
                                                uname,
                                                context,
                                                widget.name.toString());
                                      },
                                      child: const Icon(
                                        Icons.remove,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      '$quantity',
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.black),
                                    ),
                                    const SizedBox(width: 5),
                                    InkWell(
                                      onTap: () {
                                        ref
                                            .read(cartProvider.notifier)
                                            .increment(
                                                widget.id,
                                                ref,
                                                uname,
                                                context,
                                                widget.name.toString(),widget.weight.toString());
                                      },
                                      child: const Icon(
                                        Icons.add,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text("Weight: ${widget.weight}",
                    style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 5),
                Text("Category: ${widget.cate}",
                    style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 5),
                Text("Quantity: ${widget.quantity}",
                    style: const TextStyle(fontSize: 16)),
                const Gap(20),
                Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(0.0),
                        child: Text(
                          "Similar Products",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Consumer(
                        builder: (context, ref, child) {
                          final d = ref.watch(stateModelsNotifierProvider);

                          final data = d['products_by_subcategory']
                              [widget.cate.toString()]['data'];
                          return GridView.builder(
                            scrollDirection: Axis.vertical,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 220,
                              mainAxisExtent: 300,
                            ),
                            itemCount: data.length??0,
                            itemBuilder: (BuildContext context, int index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => description(rating: data[index]['rating'].toString(),
                                          offer:
                                              data[index]['offer'].toString(),
                                          name: data[index]['ProductName']
                                              .toString(),
                                          image: data[index]['imageurl']
                                              .toString(),
                                          des: data[index]['Descriptions']
                                              .toString(),
                                          weight: data[index]['ProductWeight']
                                              .toString(),
                                          price: data[index]['ProductPrice']
                                              .toString(),
                                          quantity: data[index]
                                                  ['Productquantity']
                                              .toString(),
                                          cate: data[index]['SubCategory']
                                              .toString(),
                                          id: data[index]['ProductID']
                                              .toString())));
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(8),
                                  padding: const EdgeInsets.all(5),
                                  height: 250,
                                  width: 170,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                            offset: const Offset(0, 6),
                                            blurRadius: 8,
                                            color: Colors.black.withOpacity(.1),
                                            spreadRadius: 2)
                                      ]),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Stack(
                                          children: [
                                            Container(
                                              height: double.infinity,
                                              width: double.infinity,
                                              padding: const EdgeInsets.all(1),
                                              decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5))),
                                              child: CachedNetworkImage(
                                                fit: BoxFit.fill,
                                                imageUrl: data[index]
                                                        ['imageurl']
                                                    .toString(),
                                                progressIndicatorBuilder:
                                                    (context, url,
                                                            downloadProgress) =>
                                                        Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                          value:
                                                              downloadProgress
                                                                  .progress),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(Icons.error),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(4),
                                              child: InkWell(
                                                onTap: () {
                                                  ref
                                                      .read(likedItemProvider
                                                          .notifier)
                                                      .toggleLikeda(
                                                          data[index]
                                                                  ['ProductID']
                                                              .toString(),
                                                          ref,
                                                          uname.toString(),
                                                          context,
                                                          data[index][
                                                                  'ProductName']
                                                              .toString());
                                                },
                                                child: Container(
                                                  color: Colors.transparent,
                                                  child: Consumer(
                                                    builder: (context,
                                                        WidgetRef ref, child) {
                                                      final likedItems =
                                                          ref.watch(
                                                              likedItemProvider);
                                                      return Icon(
                                                        !likedItems.contains(data[
                                                                        index][
                                                                    'ProductID']
                                                                .toString())
                                                            ? Icons
                                                                .favorite_border
                                                            : Icons.favorite,
                                                        color: !likedItems
                                                                .contains(data[
                                                                            index]
                                                                        [
                                                                        'ProductID']
                                                                    .toString())
                                                            ? Colors.red
                                                            : Colors.red,
                                                        size: 30,
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
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
                                                  '${data[index]['offer'].toString()} \n OFF',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        data[index]['ProductName'].toString(),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const Gap(1),
                                      Text(data[index]['ProductWeight']
                                          .toString()),
                                      const Gap(2),
                                      Container(
                                        padding: const EdgeInsets.only(
                                            left: 3, right: 3),
                                        height: 23,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            color: Colors.purple.shade100,
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        margin: const EdgeInsets.all(1),
                                        child: const Center(
                                          child: Text("Get for premium"),
                                        ),
                                      ),
                                      const Gap(1),
                                      Text(
                                        "  ₹ ${data[index]["ProductPrice"]}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Consumer(
                                          builder: (context, ref, child) {
                                            final cart =
                                                ref.watch(cartProvider);

                                            final productId = data[index]
                                                    ['ProductID']
                                                .toString();
                                            final quantity =
                                                cart[productId] ?? 0;

                                            return quantity == 0
                                                ? InkWell(
                                                    onTap: () {
                                                      uname == ""
                                                          ? (ScaffoldMessenger
                                                              .of(context)
                                                            ..removeCurrentSnackBar()
                                                            ..showSnackBar(const SnackBar(
                                                                duration:
                                                                    Duration(
                                                                        seconds:
                                                                            2),
                                                                content: Text(
                                                                    '!Please Signin/SignUp!'))))
                                                          : ref
                                                              .read(cartProvider
                                                                  .notifier)
                                                              .increment(
                                                                  data[index][
                                                                          'ProductID']
                                                                      .toString(),
                                                                  ref,
                                                                  uname,
                                                                  context,
                                                                  data[index][
                                                                          'ProductName']
                                                                      .toString(),data[index][
                                                                          'ProductWeight']
                                                                      .toString());
                                                    },
                                                    child: Container(
                                                        height: 35,
                                                        width: double.infinity,
                                                        decoration:
                                                            const BoxDecoration(
                                                          border: Border(
                                                              bottom: BorderSide(
                                                                  width: 1.0,
                                                                  color: Colors
                                                                      .pink),
                                                              top: BorderSide(
                                                                  width: 1.0,
                                                                  color: Colors
                                                                      .pink),
                                                              right: BorderSide(
                                                                  width: 1.0,
                                                                  color: Colors
                                                                      .pink),
                                                              left: BorderSide(
                                                                  width: 1.0,
                                                                  color: Colors
                                                                      .pink)),
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5)),
                                                        ),
                                                        child: const Center(
                                                            child: Text(
                                                          "Add to Cart",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.pink,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ))),
                                                  )
                                                : Container(
                                                    padding:
                                                        const EdgeInsets.all(2),
                                                    height: 35,
                                                    width: double.infinity,
                                                    decoration: const BoxDecoration(
                                                        border: Border(
                                                            bottom: BorderSide(
                                                                width: 1.0,
                                                                color: Colors
                                                                    .pink),
                                                            top: BorderSide(
                                                                width: 1.0,
                                                                color: Colors
                                                                    .pink),
                                                            right: BorderSide(
                                                                width: 1.0,
                                                                color: Colors
                                                                    .pink),
                                                            left: BorderSide(
                                                                width: 1.0,
                                                                color: Colors
                                                                    .pink)),
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    7))),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Expanded(
                                                          child: InkWell(
                                                            onTap: () {
                                                              ref
                                                                  .read(cartProvider
                                                                      .notifier)
                                                                  .decrement(
                                                                      data[index]
                                                                              [
                                                                              'ProductID']
                                                                          .toString(),
                                                                      ref,
                                                                      uname,
                                                                      context,
                                                                      data[index]
                                                                              [
                                                                              'ProductName']
                                                                          .toString());
                                                            },
                                                            child: Container(
                                                              color: Colors.pink
                                                                  .shade100,
                                                              child: const Icon(
                                                                Icons.remove,
                                                                color:
                                                                    Colors.pink,
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
                                                                      fontSize:
                                                                          12),
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
                                                                      data[index]
                                                                              [
                                                                              'ProductID']
                                                                          .toString(),
                                                                      ref,
                                                                      uname,
                                                                      context,
                                                                      data[index]
                                                                              [
                                                                              'ProductName']
                                                                          .toString(),data[index][
                                                                          'Productweight']
                                                                      .toString());
                                                            },
                                                            child: Container(
                                                              color: Colors.pink
                                                                  .shade100,
                                                              child: const Icon(
                                                                Icons.add,
                                                                color:
                                                                    Colors.pink,
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
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
