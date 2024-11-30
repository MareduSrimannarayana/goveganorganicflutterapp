import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gap/gap.dart';
import 'package:govegan_organics/SharedPreference/sharedprefernce.dart';
import 'package:govegan_organics/models/cartmodelmap.dart';
import 'package:govegan_organics/models/likemodel.dart';
import 'package:govegan_organics/views/cart.dart';
import 'package:govegan_organics/views/des.dart';
import 'package:govegan_organics/chatgptlogin/a.dart';
import 'package:govegan_organics/views/rameshwaram.dart';
import 'package:http/http.dart' as http;

final loadingprovider = StateProvider((ref) => true);

final paginatedDataProvider = StateNotifierProvider.autoDispose
    .family<PaginatedDataNotifier, List<Map<String, dynamic>>, String>(
  (ref, category) {
    return PaginatedDataNotifier(category: category);
  },
);

class PaginatedDataNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  final String category;

  PaginatedDataNotifier({required this.category}) : super([]);

  Future<void> fetchData(int page, WidgetRef ref) async {
    final uri = Uri.parse(
        "https://aimldeftech.com/laravel/public/api/products/category?page=$page&&per_page=10");
    String? bearerToken = await getToken();
    final response = await http.post(
      uri,
      body: {"category": category},
      headers: {
        'Authorization': 'Bearer $bearerToken',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData =
          json.decode(response.body);
      final List<dynamic> products = responseData['data'];

      if (products != null && products.isNotEmpty) {
        state ??= [];
        final List<String> productIdsInState =
            state.map((product) => product['ProductID'].toString()).toList();
        final List newProducts = products
            .where((product) =>
                !productIdsInState.contains(product['ProductID'].toString()))
            .toList();
        if (newProducts.isNotEmpty) {
          state = [...state, ...newProducts];
     

        } else {
          ref.read(loadingprovider.notifier).state = false;
        }
      } else {
        ref.read(loadingprovider.notifier).state = false;
      }
    } else {
      throw Exception('Failed to load products');
    }
  }

  void clear() {
    state.clear();
  }

  Future<void> loadMore(WidgetRef ref) async {
    final currentPage = state.length ~/ 5;

    await fetchData(currentPage + 1, ref);
  
  }
}

class ViewAllProducts extends ConsumerStatefulWidget {
  const ViewAllProducts({super.key, required this.cat});
  final String cat;

  @override
  ConsumerState<ViewAllProducts> createState() =>
      _ViewAllProductsConsumerState();
}

class _ViewAllProductsConsumerState extends ConsumerState<ViewAllProducts> {
  late ScrollController _scrollController;
  var uname = "";

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

    _loadInitialData();
    SharedUserPreferences.init().then((_) {
      setState(() {
        uname = SharedUserPreferences.getMobile() ?? "";
      });
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose(); // Dispose of the controller
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      _loadMoreData();
    }
  }

  void _loadInitialData() {
    ref.read(paginatedDataProvider(widget.cat).notifier).fetchData(1, ref);
  }

  void _loadMoreData() {
    ref.read(paginatedDataProvider(widget.cat).notifier).loadMore(ref);
  }

  @override
  Widget build(BuildContext context) {
    final badgecount = ref.watch(cartProvider).length;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(widget.cat),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () {
              ref.read(resuldata.notifier).update((state) => []);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const GrocerySearchPage()));
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
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollInfo) {
          if (scrollInfo is ScrollEndNotification) {
            _scrollListener();
          }
          return true;
        },
        child: Consumer(builder: (context, ref, child) {
          final data = ref.watch(paginatedDataProvider(widget.cat));

          return GridView.builder(
            controller: _scrollController,
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              crossAxisSpacing: 1,
              mainAxisSpacing: 1,
              maxCrossAxisExtent: 280,
              mainAxisExtent: 260,
            ),
            itemCount:
                ref.watch(loadingprovider) ? data.length + 1 : data.length,
            itemBuilder: (BuildContext context, int index) {
                      if (data.length <8 && (data.length!=9)) {
  ref.read(loadingprovider.notifier).state = false;
}
              if (index < data.length) {
                return buildProductItem(data[index], ref);
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          );
        }),
      ),
    );
  }

  Widget buildProductItem(Map<String, dynamic> productData, WidgetRef ref) {
    final productId = productData['ProductID'].toString();
    final cart = ref.watch(cartProvider);
    final quantity = cart[productId] ?? 0;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => description(
            offer:productData['offer'].toString(),
            rating: productData['rating'].toString(),
            name: productData['ProductName'].toString(),
            image: productData['imageurl'].toString(),
            des: productData['Descriptions'].toString(),
            weight: productData['ProductWeight'].toString(),
            price: productData['ProductCount'].toString(),
            quantity: productData['Productquantity'].toString(),
            cate: productData['SubCategory'].toString(),
            id: productId,
          ),
        ));
      },
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(5),
        height: 230,
        width: 170,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow:  [
            BoxShadow(
              offset: const Offset(0, 6),
              blurRadius: 8,
              color: Colors.black.withOpacity(.1),
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              child: Container(
                height: double.infinity,
                width: double.infinity,
                padding: const EdgeInsets.all(1),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child: Stack(
                  children: [
                    CachedNetworkImage(
                      fit: BoxFit.fill,width: double.infinity,height: double.infinity,
                      imageUrl: productData['imageurl'].toString(),
                      progressIndicatorBuilder: (context, url, downloadProgress) =>
                          Center(
                        child: CircularProgressIndicator(
                            value: downloadProgress.progress),
                      ),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: InkWell(
                        onTap: () {
                          ref.read(likedItemProvider.notifier).toggleLikeda(
                            productId,
                            ref,
                            uname,context,productData['ProductName'].toString());
                        },
                        child: Container(
                          color: Colors.transparent,
                          child: Consumer(
                            builder: (context, WidgetRef ref, child) {
                              final likedItems =
                                  ref.watch(likedItemProvider);

                              return Icon(
                                !likedItems.contains(productId)
                                    ? Icons.favorite_border
                                    : Icons.favorite,
                                color: !likedItems.contains(
                                    productId)
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
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child:  Text(
                          '${ productData['offer'].toString()} \n OFF',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Text(
              productData['ProductName'].toString(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const Gap(1),
            Text(productData['ProductWeight'].toString()),
            const Gap(1),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("  ₹ ${productData["ProductPrice"]}"),
                Consumer(
                  builder: (context, ref, child) {
                    final cart = ref.watch(cartProvider);

                    final productId = productData['ProductID'].toString();
                    final quantity = cart[productId] ?? 0;

                    return quantity == 0
                        ? InkWell(
                      onTap: () {
                        uname == ""
                            ? (ScaffoldMessenger.of(context)
                            ..removeCurrentSnackBar()
                            ..showSnackBar(const SnackBar(
                              duration: Duration(seconds: 2),
                              content: Text('Please Sign in/Sign Up!'),
                            )))
                            : ref.read(cartProvider.notifier).increment(
                            productData['ProductID'].toString(),
                            ref,
                            uname,
                            context,productData['ProductName'].toString(),productData['ProductWeight'].toString());
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
                              ref.read(cartProvider.notifier).decrement(
                                  productData['ProductID'].toString(),
                                  ref,
                                  uname,
                                  context,productData['ProductName'].toString());
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
                                fontSize: 12, color: Colors.white),
                          ),
                          const SizedBox(width: 5),
                          InkWell(
                            onTap: () {
                              ref.read(cartProvider.notifier).increment(
                                  productData['ProductID'].toString(),
                                  ref,
                                  uname,
                                  context,productData['ProductName'].toString(),productData['ProductWeight'].toString());
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
          ],
        ),
      ),
    );
  }
}
