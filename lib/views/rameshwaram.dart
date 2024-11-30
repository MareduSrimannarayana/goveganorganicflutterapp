import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:govegan_organics/SharedPreference/sharedprefernce.dart';
import 'package:govegan_organics/chatgptlogin/a.dart';
import 'package:govegan_organics/models/cartmodelmap.dart';
import 'package:govegan_organics/models/likemodel.dart';
import 'package:govegan_organics/views/cart.dart';
import 'package:govegan_organics/views/des.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final loading = StateProvider((ref) => false);
final resuldata = StateProvider((ref) => []);

class GrocerySearchPage extends ConsumerStatefulWidget {
  const GrocerySearchPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _GrocerySearchPageConsumerState createState() =>
      _GrocerySearchPageConsumerState();
}

class _GrocerySearchPageConsumerState extends ConsumerState<GrocerySearchPage> {
  var userid = "";
  @override
  void initState() {
    super.initState();
    _initStateAsync();
  }

  Future<void> _initStateAsync() async {
    SharedUserPreferences.init().then((_) {
      setState(() {
        userid = SharedUserPreferences.getMobile() ?? "";
      });
    });
  }

  final TextEditingController _inputsearch = TextEditingController();

  void _performSearch(BuildContext context, String query, WidgetRef ref) {
    search(ref, query);
  }

  Future<void> search(WidgetRef ref, String query) async {
    String? bearerToken = await getToken();
    ref.read(loading.notifier).update((state) => true);
    await Future.delayed(const Duration(seconds: 2));
    final url = Uri.parse("https://aimldeftech.com/laravel/public/api/search");
    final response = await http.post(
      url,
      body: {'query': query},
      headers: {'Authorization': 'Bearer $bearerToken'},
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      ref.read(loading.notifier).update((state) => false);
      final responseData = json.decode(response.body);
      ref.read(resuldata.notifier).state = responseData;
    } else {
      
      ref.read(loading.notifier).update((state) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final badgecount = ref.watch(cartProvider).length;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const cart()),
    );
  },
  icon: Stack(
    alignment: Alignment.center,
    children: [
      const Icon(Icons.shopping_cart),
      if (badgecount != 0)
        Positioned(
          top: 0,
          right: 0,
          child: CircleAvatar(
            backgroundColor: Colors.red,
            radius: 9,
            child: Text(
              badgecount.toString(),
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white,
              ),
            ),
          ),
        ),
    ],
  ),
),

        ],
        title: const Text('Search Groceries'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _inputsearch,
                        onChanged: (value) {
                          _performSearch(context, value, ref);
                        },
                        decoration: const InputDecoration(
                          hintText: 'Search for groceries',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        _inputsearch.clear();
                      },
                      icon: const Icon(Icons.clear),
                    ),
                    IconButton(
                      onPressed: () {
                        _performSearch(context, _inputsearch.text, ref);
                      },
                      icon: const Icon(Icons.search),
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: ref.watch(loading),
              child: const LinearProgressIndicator(),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _buildSearchResults(context, ref),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults(BuildContext context, WidgetRef ref) {
    final data = ref.watch(resuldata);
    if (data.isEmpty && _inputsearch.text.isNotEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.sentiment_dissatisfied,
              size: 50,
              color: Colors.red,
            ),
            SizedBox(height: 10),
            Text(
              'No results found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Try a different search term',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    if (_inputsearch.text.isEmpty && data.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Please search ",
              style: TextStyle(
                fontSize: 24, 
                fontWeight: FontWeight.bold, 
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 10), 
            Icon(
              Icons.search,
              size: 40, 
              color: Colors.grey[700], 
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 180, mainAxisExtent: 200),
      itemCount: data.length,
      itemBuilder: (context, index) {
        final result = data[index];
        final productId = result['ProductID'].toString();
        final quantity = ref.watch(cartProvider)[productId] ?? 0;
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => description(offer: result['offer'].toString(),rating:result['rating'].toString() ,
                  name: result['ProductName'].toString(),
                  image: result['imageurl'].toString(),
                  des: result['Descriptions'].toString(),
                  weight: result['ProductWeight'].toString(),
                  price: result['ProductPrice'].toString(),
                  quantity: result['Productquantity'].toString(),
                  cate: result['SubCategory'].toString(),
                  id: result['ProductID'].toString(),
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Material(elevation: 2,
              child: Container(
                height: double.infinity,
                width: double.infinity,
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(border: Border.all(color: Colors.black.withOpacity(.1)), 
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.white,
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3), 
                    ),
                  ],
                ),
            
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
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
                                imageUrl: result['imageurl'].toString(),
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) => Center(
                                  child: CircularProgressIndicator(
                                      value: downloadProgress.progress),
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),Padding(
                                              padding: const EdgeInsets.all(4),
                                              child: InkWell(
                                                onTap: () {
                                                  ref
                                                      .read(likedItemProvider
                                                          .notifier)
                                                      .toggleLikeda(
                                                          result
                                                                  ['ProductID']
                                                              .toString(),
                                                          ref,
                                                          userid.toString(),
                                                          context,
                                                       result[
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
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            result['ProductName'].toString(),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          RichText(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(
                              style: const TextStyle(fontSize: 13),
                              children: [
                                const TextSpan(
                                  text: 'Price: ',
                                  style: TextStyle(
                                 
                                    color: Colors.black,
                                  ),
                                ),
                                const TextSpan(
                                  text: '₹ ',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: result['ProductPrice'].toString(),
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 2, 6, 2),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 3, left: 3),
                      child: Container(
                        decoration: BoxDecoration(color:quantity == 0 ? Colors.white : Colors.pink ,
                          border: Border.all(
                              color: quantity == 0 ? Colors.pink : Colors.pink),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: FittedBox(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                quantity == 0
                                    ? InkWell(
                                        onTap: () {
                                          ref.read(cartProvider.notifier).increment(
                                                productId,
                                                ref,
                                                userid.toString(),
                                                context, result['ProductName'].toString(),result['ProductWeight'].toString()
                                              );
                                        },
                                        child: const Text(
                                          'ADD',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.pink,
                                              fontSize: 23),
                                        ),
                                      )
                                    : Row(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              ref
                                                  .read(cartProvider.notifier)
                                                  .decrement(
                                                    productId,
                                                    ref,
                                                    userid.toString(),
                                                    context, result['ProductName'].toString()
                                                  );
                                            },
                                            child: const Icon(
                                              Icons.remove,
                                              color: Colors.white,
                                              size: 24,
                                            ),
                                          ),
                                          const Gap(1),
                                          Text(
                                            quantity.toString(),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontSize: 23),
                                          ),
                                          const Gap(1),
                                          InkWell(
                                            onTap: () {
                                              ref
                                                  .read(cartProvider.notifier)
                                                  .increment(
                                                    productId,
                                                    ref,
                                                    userid.toString(),
                                                    context, result['ProductName'].toString(),result['ProductWeight'].toString()
                                                  );
                                            },
                                            child: const Icon(
                                              Icons.add,
                                              color: Colors.white,
                                              size: 24,
                                            ),
                                          ),
                                        ],
                                      ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
