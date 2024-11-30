// ignore_for_file: camel_case_types, prefer_const_constructors_in_immutables, prefer_interpolation_to_compose_strings, sized_box_for_whitespace, unnecessary_brace_in_string_interps

import 'package:govegan_organics/models/likemodel.dart';
import 'package:govegan_organics/models/cartmodelmap.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:govegan_organics/SharedPreference/sharedprefernce.dart';


import 'package:govegan_organics/views/des.dart';

class list4 extends ConsumerStatefulWidget {
  list4({super.key, required this.cat, required this.data});
  final String cat;
  final data;

  @override
  ConsumerState<list4> createState() => _list4ConsumerState();
}

class _list4ConsumerState extends ConsumerState<list4> {
  var uname = "";
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var uname = SharedUserPreferences.getMobile();
    return ListView.builder(
      key: PageStorageKey("list1//${widget.cat}"),
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemCount: widget.data.length,
      itemBuilder: (BuildContext context, int index) {
        if (widget.data[index]['SubCategory'] == widget.cat) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 700),
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return description(rating:widget.data[index]['rating'].toString() ,
                      offer:widget.data[index]['offer'].toString(),
                        name: widget.data[index]['ProductName'].toString(),
                        image: widget.data[index]['imageurl'].toString(),
                        des: widget.data[index]['Descriptions'].toString(),
                        weight: widget.data[index]['ProductWeight'].toString(),
                        price: widget.data[index]['ProductCount'].toString(),
                        quantity:
                            widget.data[index]['Productquantity'].toString(),
                        cate: widget.data[index]['SubCategory'].toString(),
                        id: widget.data[index]['ProductID'].toString());
                  },
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    var begin = const Offset(0.0, 1.0);
                    var end = Offset.zero;
                    var curve = Curves.fastLinearToSlowEaseIn;

                    var tween = Tween(begin: begin, end: end)
                        .chain(CurveTween(curve: curve));

                    return SlideTransition(
                      position: animation.drive(tween),
                      child: child,
                    );
                  },
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(5),
              height: 250,
              width: 170,
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: widget.data[index]['imageurl'].toString(),
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
                                  widget.data[index]['ProductID'].toString(),
                                  ref,
                                  uname,
                                  context,widget.data[index]['ProductName'].toString());
                            },
                            child: Container(
                                color: Colors.transparent,
                                child: Consumer(
                                  builder: (context, WidgetRef ref, child) {
                                    final likedItems =
                                        ref.watch(likedItemProvider);
                                

                                    return Icon(
                                      !likedItems.contains(
                                              widget.data[index]['ProductID'].toString())
                                          ? Icons.favorite_border
                                          : Icons.favorite,
                                      color: !likedItems.contains(
                                              widget.data[index]['ProductID'].toString())
                                          ? Colors.red
                                          : Colors.red,
                                      size: 30,
                                    );
                                  },
                                )),
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
                              '${widget.data[index]['offer'].toString()} \n OFF',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    widget.data[index]['ProductName'].toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Gap(1),
                  Text(widget.data[index]['ProductWeight'].toString()),
                  const Gap(2),
                  Container(
                    padding: const EdgeInsets.only(left: 3, right: 3),
                    height: 23,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.purple.shade100,
                        borderRadius: BorderRadius.circular(5)),
                    margin: const EdgeInsets.all(1),
                    child: const FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text("Get for premium "),
                    ),
                  ),
                  const Gap(1),
                  Text(
                    "  ₹ " + widget.data[index]["ProductPrice"].toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Consumer(
                      builder: (context, ref, child) {
                        final cart = ref.watch(cartProvider);

                        final productId =
                            widget.data[index]['ProductID'].toString();
                        final quantity = cart[productId] ?? 0;

                        return quantity == 0
                            ? InkWell(
                                onTap: () {
                                  uname == ""
                                      ? (ScaffoldMessenger.of(context)
                                        ..removeCurrentSnackBar()
                                        ..showSnackBar(const SnackBar(
                                            duration: Duration(seconds: 2),
                                            content: Text(
                                                '!Please Signin/SignUp!'))))
                                      : ref
                                          .read(cartProvider.notifier)
                                          .increment(
                                              widget.data[index]['ProductID']
                                                  .toString(),
                                              ref,
                                              uname,
                                              context,  widget.data[index]['ProductName']
                                                  .toString(), widget.data[index]['ProductWeight']
                                                  .toString());
                                },
                                child: Container(
                                    height: 35,
                                    width: double.infinity,
                                    decoration: const BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              width: 1.0, color: Colors.pink),
                                          top: BorderSide(
                                              width: 1.0, color: Colors.pink),
                                          right: BorderSide(
                                              width: 1.0, color: Colors.pink),
                                          left: BorderSide(
                                              width: 1.0, color: Colors.pink)),
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                    ),
                                    child: const Center(
                                        child: Text(
                                      "Add to Cart",
                                      style: TextStyle(
                                          color: Colors.pink,
                                          fontWeight: FontWeight.bold),
                                    ))),
                              )
                            : Container(
                                padding: const EdgeInsets.all(2),
                                height: 35,
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            width: 1.0, color: Colors.green),
                                        top: BorderSide(
                                            width: 1.0, color: Colors.green),
                                        right: BorderSide(
                                            width: 1.0, color: Colors.green),
                                        left: BorderSide(
                                            width: 1.0, color: Colors.green)),
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(7))),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          ref
                                              .read(cartProvider.notifier)
                                              .decrement(
                                                  widget.data[index]
                                                          ['ProductID']
                                                      .toString(),
                                                  ref,
                                                  uname,
                                                  context,  widget.data[index]['ProductName']
                                                  .toString());
                                        },
                                        child: Container(
                                          color: Colors.green.shade100,
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
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          ref
                                              .read(cartProvider.notifier)
                                              .increment(
                                                  widget.data[index]
                                                          ['ProductID']
                                                      .toString(),
                                                  ref,
                                                  uname,
                                                  context,  widget.data[index]['ProductName']
                                                  .toString(), widget.data[index]['ProductWeight']
                                                  .toString());
                                        },
                                        child: Container(
                                          color: Colors.green.shade100,
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
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
