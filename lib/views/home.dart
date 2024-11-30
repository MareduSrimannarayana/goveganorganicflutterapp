// ignore_for_file: camel_case_types, prefer_const_constructors, duplicate_ignore, non_constant_identifier_names, avoid_print, unnecessary_brace_in_string_interps, unused_result, use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';
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

import 'package:govegan_organics/views/settings.dart';
import 'package:govegan_organics/views/sri.dart';
import 'package:govegan_organics/views/usereditpro.dart';

import 'package:govegan_organics/views/view_all.dart';

import '../SharedPreference/sharedprefernce.dart';
import '../Sign/signin.dart';

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
    scrollwidget(),
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
final locationprovider = StateProvider((ref) => "Telangana");

class scrollwidget extends ConsumerStatefulWidget {
  const scrollwidget({
    super.key,
  });

  @override
  ConsumerState<scrollwidget> createState() => _scrollwidgetState();
}

class _scrollwidgetState extends ConsumerState<scrollwidget> {
  Future<Position> _determineLocation(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;
    try {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw 'Location services are disabled';
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw 'Location permission denied';
        }
      }

      if (permission == LocationPermission.deniedForever) {
        showErrorMessage(context,
            message: 'Location permissions are permanently denied');
        throw 'Location permissions are permanently denied';
      }

      Position position = await Geolocator.getCurrentPosition();
      return position;
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        showErrorMessage(context, message: 'Location permission denied');
        throw 'Location permission denied';
      } else if (e.code == 'PERMISSION_DENIED_FOREVER') {
        showErrorMessage(context,
            message: 'Location permissions are permanently denied');
        throw 'Location permissions are permanently denied';
      } else {
        showErrorMessage(context,
            message: 'Error occurred while getting location: ${e.toString()}');
        throw 'Error occurred while getting location: ${e.toString()}';
      }
    } catch (e) {
      showErrorMessage(context, message: 'Please turn on your location!');
      rethrow;
    }
  }

  Future<void> _refre() async {
    await Future.delayed(const Duration(milliseconds: 1500));
  }

  @override
  void initState() {
    super.initState();
    _determineLocation(context);
  }

  @override
  Widget build(BuildContext context) {
    final username = ref.watch(userProvider);
    return RefreshIndicator(
      onRefresh: _refre,
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
                                builder: (context) => GrocerySearchPage()));
                      },
                      child: Icon(
                        CupertinoIcons.search,
                        size: 24,
                        color: Colors.black,
                      )),
                  Gap(9)
                ],
                backgroundColor: Colors.green,
                floating: true,
                snap: true,
                expandedHeight: 95,
                leading: InkWell(
                  onTap: () {
                    if (username.isEmpty) {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => signin()));
                    } else {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          transitionDuration: Duration(milliseconds: 500),
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return pro();
                          },
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            var begin = Offset(1.0, 0.0);
                            var end = Offset.zero;
                            var curve = Curves.ease;

                            var tween = Tween(begin: begin, end: end)
                                .chain(CurveTween(curve: curve));

                            return SlideTransition(
                              position: animation.drive(tween),
                              child: child,
                            );
                          },
                        ),
                      );
                    }
                  },
                  child: Icon(
                    username.isEmpty
                        ? Icons.login_sharp
                        : Icons.person_3_rounded,
                    size: 30,
                    color: username.isEmpty ? Colors.red : Colors.black,
                  ),
                ),
                centerTitle: true,
                title: Column(
                  children: [
                    const Text("MyLocation",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis),
                    GestureDetector(
                      onTap: () {
                        _determineLocation(context).then((value) {
                          ref.read(locationprovider.notifier).update((state) =>
                              "longitude: ${value.longitude}\nlatitude: ${value.latitude}");
                        });
                      },
                      child: FittedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              ref.watch(locationprovider),
                              style: const TextStyle(fontSize: 15),
                            ),
                            const Icon(
                              Icons.arrow_drop_down,
                              size: 30,
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(15),
                  child: Container(
                    child: username.isEmpty
                        ? const Text(
                            "Please SignIn/Signup To Continue Shopping",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.redAccent,
                            ),
                          )
                        : Text(
                            "Welcome ${username} ",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                  ),
                ),
              );
            },
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return const mainscreen();
            }, childCount: 1),
          )
        ],
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
            Container(
              margin: const EdgeInsets.all(10),
              height: MediaQuery.sizeOf(context).height * 0.18,
              width: double.infinity * 0.8,
              child: Image.asset(
                "images/vegan.jpg",
                fit: BoxFit.cover,
              ),
            ),
            GridView.builder(
              key: PageStorageKey("jhhhgchg"),
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 150,
                  mainAxisExtent: 190,
                  mainAxisSpacing: 3,
                  crossAxisSpacing: 3),
              itemCount: 9,
              itemBuilder: (BuildContext context, int index) {
                if (index < 8) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          transitionDuration: Duration(milliseconds: 700),
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return description(
                                offer:
                                    data['products'][index]['offer'].toString(),
                                rating: data['products'][index]['rating']
                                    .toString(),
                                name: data['products'][index]['ProductName']
                                    .toString(),
                                image: data['products'][index]['imageurl']
                                    .toString(),
                                des: data['products'][index]['Descriptions']
                                    .toString(),
                                weight: data['products'][index]['ProductWeight']
                                    .toString(),
                                price: data['products'][index]['ProductPrice']
                                    .toString(),
                                quantity: data['products'][index]
                                        ['Productquantity']
                                    .toString(),
                                cate: data['products'][index]['SubCategory']
                                    .toString(),
                                id: data['products'][index]['ProductID']
                                    .toString());
                          },
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            var begin = Offset(0.0, 1.0);
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
                      margin: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                          border:
                              Border.all(color: Colors.black.withOpacity(.2))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(children: [
                            Container(
                              margin: EdgeInsets.all(2),
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                child: CachedNetworkImage(
                                  height: 90,
                                  width: double.infinity,
                                  fit: BoxFit.fill,
                                  filterQuality: FilterQuality.medium,
                                  imageUrl: data['products'][index]['imageurl']
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
                                  '${data['products'][index]['offer'].toString()} \n OFF',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Consumer(
                                builder: (context, ref, child) {
                                  final cart = ref.watch(cartProvider);

                                  final productId = data['products'][index]
                                          ['ProductID']
                                      .toString();
                                  final quantity = cart[productId] ?? 0;

                                  return quantity == 0
                                      ? InkWell(
                                          onTap: () {
                                            username == ""
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
                                                        data['products'][index]
                                                                ['ProductID']
                                                            .toString(),
                                                        ref,
                                                        username,
                                                        context,
                                                        data['products'][index]
                                                                ['ProductName']
                                                            .toString(),
                                                        data['products'][index][
                                                                'ProductWeight']
                                                            .toString());
                                          },
                                          child: Container(
                                              height: 28,
                                              width: 50,
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
                                                  child: FittedBox(
                                                fit: BoxFit.fitWidth,
                                                child: Text(
                                                  "Add",
                                                  style: TextStyle(
                                                      color: Colors.pink,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ))),
                                        )
                                      : Container(
                                          padding: const EdgeInsets.all(2),
                                          height: 28,
                                          width: 76,
                                          decoration: const BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(
                                                      width: 1.0,
                                                      color: Colors.green),
                                                  top: BorderSide(
                                                      width: 1.0,
                                                      color: Colors.green),
                                                  right: BorderSide(
                                                      width: 1.0,
                                                      color: Colors.green),
                                                  left: BorderSide(
                                                      width: 1.0,
                                                      color: Colors.green)),
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
                                                            data['products']
                                                                        [index][
                                                                    'ProductID']
                                                                .toString(),
                                                            ref,
                                                            username,
                                                            context,
                                                            data['products']
                                                                        [index][
                                                                    'ProductName']
                                                                .toString());
                                                  },
                                                  child: Container(
                                                    color:
                                                        Colors.green.shade100,
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
                                                        TextStyle(fontSize: 10),
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
                                                            data['products']
                                                                        [index][
                                                                    'ProductID']
                                                                .toString(),
                                                            ref,
                                                            username,
                                                            context,
                                                            data['products']
                                                                        [index][
                                                                    'ProductName']
                                                                .toString(),
                                                            data['products']
                                                                        [index][
                                                                    'ProductWeight']
                                                                .toString());
                                                  },
                                                  child: Container(
                                                    color:
                                                        Colors.green.shade100,
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
                          ]),
                          Padding(
                            padding: const EdgeInsets.all(.9),
                            child: Text(
                              data['products'][index]['ProductName'],
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(.9),
                            child: Text(
                              data['products'][index]['ProductWeight'],
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(1),
                            child: Text(
                                "₹${data['products'][index]['ProductPrice']}"),
                          )
                        ],
                      ),
                    ),
                  );
                } else {
                  return Card(
                    elevation: 4,
                    child: InkWell(
                      onTap: () {
                        ref.read(currprovider.notifier).update((state) => 1);
                      },
                      hoverColor: Colors.amberAccent,
                      splashColor: const Color.fromARGB(255, 229, 183, 198),
                      borderRadius: BorderRadius.circular(5),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.pink[400],
                            borderRadius: BorderRadius.circular(5)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            Text(
                              "See All",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            Gap(2),
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 10,
                              child: Icon(
                                Icons.arrow_forward_ios_outlined,
                                color: Colors.pink,
                                size: 10,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
        Gap(3),
        Column(
          children: [
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
          label: "Go Vegan",
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
