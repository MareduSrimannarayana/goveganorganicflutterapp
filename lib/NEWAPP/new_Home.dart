// ignore_for_file: camel_case_types, prefer_const_constructors, duplicate_ignore, non_constant_identifier_names, avoid_print, unnecessary_brace_in_string_interps, unused_result, use_build_context_synchronously

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:govegan_organics/commonUI/SnackBar.dart';

import 'package:govegan_organics/dummy.dart';

import 'package:govegan_organics/models/cartmodelmap.dart';
import 'package:govegan_organics/models/likemodel.dart';
import 'package:govegan_organics/models/statemodel.dart';

import 'package:govegan_organics/views/cart.dart';
import 'package:govegan_organics/views/des.dart';
import 'package:govegan_organics/views/like.dart';

import 'package:govegan_organics/views/listview4.dart';

import 'package:govegan_organics/views/rameshwaram.dart';

import 'package:govegan_organics/views/sri.dart';

import 'package:govegan_organics/views/view_all.dart';

import '../SharedPreference/sharedprefernce.dart';
import '../views/orderdetailspage.dart';

class home extends ConsumerStatefulWidget {
  const home({super.key});

  @override
  ConsumerState<home> createState() => _homeState();
}

class _homeState extends ConsumerState<home> {
  @override
  void initState() {
    super.initState();
    call();
    initializeApp(ref);
    WidgetsBinding.instance.addObserver(MyAppLifecycleObserver(ref, context));
  }

  call() async {
    await ref.read(stateModelsNotifierProvider.notifier).appservercall("", ref);
  }

  Future<void> initializeApp(ref) async {
    await checkInternet(context, ref);
  }

  Future<void> checkInternet(BuildContext context, WidgetRef ref) async {
    final List<ConnectivityResult> connectivityResult =
        await Connectivity().checkConnectivity();

    if (connectivityResult.contains(ConnectivityResult.wifi) ||
        connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.vpn) ||
        connectivityResult.contains(ConnectivityResult.ethernet) ||
        connectivityResult.contains(ConnectivityResult.other) ||
        connectivityResult.contains(ConnectivityResult.bluetooth)) {
      print("true");
      showSuccessMessage(context, message: "connected to internet");
      ref.read(internetConnectionProvider.notifier).update((state) => true);
    } else {
      print("false");
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => AlertDialog(
          title: const Text('No Internet Connection'),
          content: const Text(
              'Please check your internet connection and try again.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                initializeApp(ref);
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }
  }

  List body = [
    ScrollWidget(),
    NewWidget(),
    GrocerySearchPage(),
    ProductlikeListPage(),
    cart()
  ];

  @override
  Widget build(BuildContext context) {
    final isConnected = ref.watch(internetConnectionProvider);

    return Scaffold(
      body: isConnected
          ? body[ref.watch(currprovider)]
          : Center(child: CircularProgressIndicator()),
      bottomNavigationBar: const navwid(),
    );
  }
}

final internetConnectionProvider = StateProvider<bool>((ref) {
  return false;
});

class ScrollWidget extends ConsumerStatefulWidget {
  @override
  _ScrollWidgetState createState() => _ScrollWidgetState();
}

class _ScrollWidgetState extends ConsumerState<ScrollWidget> {
  Future<void> _refresh() async {
    await Future.delayed(const Duration(milliseconds: 1500));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 80, 243, 85),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'USER',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              onTap: () => Navigator.of(context).pop(),
              // onTap: () => Navigator.of(context).push(
              //   MaterialPageRoute(
              //     builder: (context) => GrocerySearchPage(),
              //   ),
              // ),
              leading: Icon(
                Icons.home,
                color: Color.fromARGB(255, 41, 233, 47),
              ),
              title: Text('Home'),
            ),
            Divider(),
            ListTile(
              // onTap: () => Navigator.of(context).push(
              //   MaterialPageRoute(
              //     builder: (context) => (),
              //   ),
              // ),
              leading: Icon(Icons.account_circle,
                  color: Color.fromARGB(255, 41, 233, 47)),
              title: Text('Profile'),
            ),
            Divider(),
            ListTile(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => cart(),
                ),
              ),
              leading: Icon(Icons.shopping_cart_outlined,
                  color: Color.fromARGB(255, 41, 233, 47)),
              title: Text('Cart'),
            ),
            Divider(),
            ListTile(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ProductlikeListPage(),
                ),
              ),
              leading: Icon(CupertinoIcons.heart,
                  color: Color.fromARGB(255, 41, 233, 47)),
              title: Text('Liked Products'),
            ),
            Divider(),
            ListTile(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => OrderDetailsPage(),
                ),
              ),
              leading: Icon(Icons.shopping_bag_outlined,
                  color: Color.fromARGB(255, 41, 233, 47)),
              title: Text('My Orders'),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.logout_rounded,
                  color: Color.fromARGB(255, 41, 233, 47)),
              title: Text('Logout'),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: CustomScrollView(
          key: const PageStorageKey('p'),
          slivers: [
            Consumer(
              builder: (_, WidgetRef ref, __) {
                return SliverAppBar(
                  elevation: 8,
                  actions: [
                    GestureDetector(
                      onTap: () {
                        ref.read(resuldata.notifier).update((state) => []);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GrocerySearchPage(),
                          ),
                        );
                      },
                      child: Icon(
                        CupertinoIcons.search,
                        size: 24,
                        color: Colors.black,
                      ),
                    ),
                    Gap(9),
                  ],
                  backgroundColor: const Color.fromARGB(255, 41, 233, 47),
                  floating: true,
                  snap: true,
                  centerTitle: true,
                  title: Text(
                    "Harith Organics",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              },
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return const mainscreen();
                },
                childCount: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: camel_case_types
class mainscreen extends ConsumerStatefulWidget {
  const mainscreen({
    super.key,
  });

  @override
  ConsumerState<mainscreen> createState() => _mainscreenState();
}

// ignore: camel_case_types
class _mainscreenState extends ConsumerState<mainscreen> {
  var username = "";
  @override
  void initState() {
    super.initState();
    _initStateAsync();
    ref.read(stateModelsNotifierProvider.notifier).appservercall("", ref);
  }

  Future<void> _initStateAsync() async {
    SharedUserPreferences.init().then((_) {
      setState(() {
        username = SharedUserPreferences.getMobile() ?? "";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<String> imgList = [
      'images/vegan.jpg',
      'images/a.jpg',
      'images/b.jpg',
      'images/c.jpg',
      'images/d.jpg',
      'images/e.jpg',
    ];
    final data = ref.watch(stateModelsNotifierProvider);

    if (data['subcategories'] == null || data['subcategories'].isEmpty) {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.green,
        ),
      );
    }

    return Column(
      children: [
        Column(
          children: [
            CarouselSlider(
              options: CarouselOptions(
                height: MediaQuery.of(context).size.height * 0.32,
                enlargeCenterPage: true,
                autoPlay: true,
                aspectRatio: 16 / 9,
                autoPlayCurve: Curves.fastOutSlowIn,
                enableInfiniteScroll: true,
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                viewportFraction: 0.8,
              ),
              items: imgList
                  .map((item) => Container(
                        margin: const EdgeInsets.all(10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          child: Image.asset(
                            item,
                            fit: BoxFit.contain,
                            width: double.infinity,
                          ),
                        ),
                      ))
                  .toList(),
            ),
            Text(
              "Category",
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
            ),
            GridView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 100,
                mainAxisExtent: 100,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemCount: data['products_by_subcategory'].length,
              itemBuilder: (context, index) {
                final subcategory =
                    data['products_by_subcategory'].keys.toList()[index];
                final products =
                    data['products_by_subcategory'][subcategory]['data'];
                final firstProduct = products.isNotEmpty ? products[0] : null;

                return GestureDetector(
                  onTap: () {
                    print('Subcategory tapped: $subcategory');
                    ref.read(pointer.notifier).state = index;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const NewWidget()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: FittedBox(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            firstProduct != null
                                ? CachedNetworkImage(
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.cover,
                                    imageUrl: firstProduct['imageurl'],
                                    progressIndicatorBuilder:
                                        (context, url, downloadProgress) {
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: downloadProgress.progress,
                                        ),
                                      );
                                    },
                                    errorWidget: (context, url, error) {
                                      return const Icon(Icons.error);
                                    },
                                  )
                                : Container(
                                    width: 100,
                                    height: 100,
                                    color: Colors.grey,
                                  ),
                            const SizedBox(height: 8),
                            Text(
                              subcategory,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: data['subcategories'].length,
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemBuilder: (context, i) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              data['subcategories'][i],
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          TextButton(
                              onPressed: () async {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ViewAllProducts(
                                      cat: data['subcategories'][i]),
                                ));
                              },
                              child: Text(
                                "View All",
                                style: TextStyle(color: Colors.pink),
                              ))
                        ],
                      ),
                    ),
                    Container(
                      height: 320,
                      color: Colors.transparent,
                      child: list4(
                          cat: data['subcategories'][i],
                          data: data['products_by_subcategory']
                              ['${data['subcategories'][i]}']['data']),
                    ),
                  ],
                );
              }),
        ),
        const Gap(15),
        Text(
          "Find More Products \n By Category",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}

class navwid extends ConsumerWidget {
  const navwid({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final badgecount = ref.watch(cartProvider).length;
    final likecount = ref.watch(likedItemProvider).length;

    return BottomNavigationBar(
      backgroundColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      selectedItemColor: Color.fromARGB(255, 9, 117, 12),
      currentIndex: ref.watch(currprovider),
      elevation: 8,
      onTap: (value) =>
          ref.read(currprovider.notifier).update((state) => value),
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard_customize_rounded),
          activeIcon: Icon(Icons.dashboard_customize),
          label: "Categories",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          activeIcon: Icon(Icons.search),
          label: "Search",
        ),
        BottomNavigationBarItem(
          icon: likecount == 0
              ? Icon(CupertinoIcons.heart)
              : Badge(
                  label: Text(likecount.toString()),
                  child: Icon(CupertinoIcons.heart),
                ),
          activeIcon: likecount == 0
              ? Icon(CupertinoIcons.heart)
              : Badge(
                  label: Text(likecount.toString()),
                  child: Icon(CupertinoIcons.heart),
                ),
          label: "Like",
        ),
        BottomNavigationBarItem(
          icon: badgecount == 0
              ? Icon(CupertinoIcons.shopping_cart)
              : Badge(
                  label: Text(badgecount.toString()),
                  child: Icon(CupertinoIcons.shopping_cart),
                ),
          activeIcon: badgecount == 0
              ? Icon(CupertinoIcons.shopping_cart)
              : Badge(
                  label: Text(badgecount.toString()),
                  child: Icon(CupertinoIcons.shopping_cart),
                ),
          label: "Cart",
        ),
      ],
    );
  }
}

final currprovider = StateProvider<int>((ref) {
  return 0;
});
