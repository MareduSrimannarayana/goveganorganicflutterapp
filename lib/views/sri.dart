import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:govegan_organics/SharedPreference/sharedprefernce.dart';

import 'package:govegan_organics/models/cartmodelmap.dart';
import 'package:govegan_organics/models/likemodel.dart';
import 'package:govegan_organics/models/statemodel.dart';

import 'package:govegan_organics/views/check.dart';
import 'package:govegan_organics/views/des.dart';
import 'package:govegan_organics/views/rameshwaram.dart';
import 'package:shimmer/shimmer.dart';

final loadingprovider1 = StateProvider<bool>((ref) => true);

final pointer = StateProvider((ref) => 0);

class NewWidget extends ConsumerStatefulWidget {
  const NewWidget({super.key});

  @override
  ConsumerState<NewWidget> createState() => _NewWidgetConsumerState();
}

class _NewWidgetConsumerState extends ConsumerState<NewWidget> {
  @override
  void initState() {
    super.initState();

    call();
  }

  call() async {
    ref.read(stateModelsNotifierProvider.notifier).appservercall("", ref);
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(stateModelsNotifierProvider);

    if (context.mounted) {
      print("mounted state");
    }

    final i = ref.watch(pointer);

    final isLoading = ref.watch(loadingprovider1);

    if (data['subcategories'] == null || data['subcategories'].isEmpty) {
      return GridView.builder(
        itemCount: 10,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
        ),
        itemBuilder: (BuildContext context, int index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
              ),
              width: 150.0,
              height: 150.0,
            ),
          );
        },
      );
    }

    final mobile = SharedUserPreferences.getMobile();

    print(data['products_by_subcategory'][data['subcategories'][i]]['data'][0]
        ['SubCategory']);
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
            child: const Padding(
              padding: EdgeInsets.all(6.0),
              child: Icon(Icons.search, size: 24, color: Colors.black),
            ),
          ),
          const Gap(9),
        ],
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(data['products_by_subcategory'][data['subcategories'][i]]
            ['data'][0]['SubCategory']),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: MediaQuery.of(context).size.width > 400 ? 1 : 1,
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: data['subcategories'].length ?? 0,
                    itemBuilder: (context, index) {
                      var an = data['products_by_subcategory']
                              [data['subcategories'][index]]['data']
                          .length;
                      var n = generateRandomNumber();
                      var b = n % an;
                      print("${an} => ${b}=>$n");
                      final subcategory = data['subcategories'][index];
                      final image = data['products_by_subcategory']
                          [data['subcategories'][index]]['data'][b]['imageurl'];
                      return Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.white,
                                index == i ? Colors.green : Colors.white,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              ref.read(pointer.notifier).state = index;
                            },
                            child: SizedBox(
                              width: 50,
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: CachedNetworkImage(
                                      imageUrl: image,
                                      fit: BoxFit.fill,
                                      height: 80,
                                      width: 80,
                                      progressIndicatorBuilder:
                                          (context, url, downloadProgress) =>
                                              Center(
                                        child: CircularProgressIndicator(
                                          value: downloadProgress.progress,
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                  ),
                                  const Gap(3),
                                  Text(
                                    subcategory,
                                    style: TextStyle(
                                      color: index != i
                                          ? Colors.black
                                          : Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  flex: MediaQuery.of(context).size.width > 600 ? 5 : 3,
                  child: GridView.builder(
                    key: PageStorageKey(data['subcategories'][i]),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 150,
                      mainAxisExtent: 180,
                    ),
                    itemCount: data['products_by_subcategory']
                                [data['subcategories'][i]]['data']
                            .length ??
                        0,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration:
                                  const Duration(milliseconds: 700),
                              pageBuilder:
                                  (context, animation, secondaryAnimation) {
                                return description(
                                  offer: data['products_by_subcategory']
                                              [data['subcategories'][i]]['data']
                                          [index]['offer']
                                      .toString(),
                                  rating: data['products_by_subcategory']
                                              [data['subcategories'][i]]['data']
                                          [index]['rating']
                                      .toString(),
                                  name: data['products_by_subcategory']
                                              [data['subcategories'][i]]['data']
                                          [index]['ProductName']
                                      .toString(),
                                  image: data['products_by_subcategory']
                                              [data['subcategories'][i]]['data']
                                          [index]['imageurl']
                                      .toString(),
                                  des: data['products_by_subcategory']
                                              [data['subcategories'][i]]['data']
                                          [index]['Descriptions']
                                      .toString(),
                                  weight: data['products_by_subcategory']
                                              [data['subcategories'][i]]['data']
                                          [index]['ProductWeight']
                                      .toString(),
                                  price: data['products_by_subcategory']
                                              [data['subcategories'][i]]['data']
                                          [index]['ProductPrice']
                                      .toString(),
                                  quantity: data['products_by_subcategory']
                                              [data['subcategories'][i]]['data']
                                          [index]['Productquantity']
                                      .toString(),
                                  cate: data['products_by_subcategory']
                                              [data['subcategories'][i]]['data']
                                          [index]['SubCategory']
                                      .toString(),
                                  id: data['products_by_subcategory']
                                              [data['subcategories'][i]]['data']
                                          [index]['ProductID']
                                      .toString(),
                                );
                              },
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
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
                          margin: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: Colors.black.withOpacity(.2),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.all(2),
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5)),
                                  child: Stack(
                                    children: [
                                      CachedNetworkImage(
                                        height: 90,
                                        width: double.infinity,
                                        fit: BoxFit.fill,
                                        filterQuality: FilterQuality.medium,
                                        imageUrl:
                                            data['products_by_subcategory'][
                                                        data['subcategories']
                                                            [i]]['data'][index]
                                                    ['imageurl']
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
                                      Padding(
                                        padding: const EdgeInsets.all(4),
                                        child: InkWell(
                                          onTap: () {
                                            ref.read(likedItemProvider.notifier).toggleLikeda(
                                                data['products_by_subcategory'][
                                                            data['subcategories']
                                                                [i]]['data']
                                                        [index]['ProductID']
                                                    .toString(),
                                                ref,
                                                mobile,
                                                context,
                                                data['products_by_subcategory'][
                                                            data['subcategories']
                                                                [i]]['data']
                                                        [index]['ProductName']
                                                    .toString());
                                          },
                                          child: Container(
                                            color: Colors.transparent,
                                            child: Consumer(
                                              builder: (context, WidgetRef ref,
                                                  child) {
                                                final likedItems = ref
                                                    .watch(likedItemProvider);
                                                return Icon(
                                                  !likedItems.contains(data[
                                                                  'products_by_subcategory'][data[
                                                                      'subcategories']
                                                                  [i]]['data'][
                                                              index]['ProductID']
                                                          .toString())
                                                      ? Icons.favorite_border
                                                      : Icons.favorite,
                                                  color: !likedItems.contains(data[
                                                                  'products_by_subcategory'][data[
                                                                      'subcategories']
                                                                  [i]]['data'][
                                                              index]['ProductID']
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
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5))),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          child: Text(
                                            '${data['products_by_subcategory'][data['subcategories'][i]]['data'][index]['offer'].toString()} \n OFF',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 10),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: Consumer(
                                          builder: (context, ref, child) {
                                            final cart =
                                                ref.watch(cartProvider);
                                            final productId =
                                                data['products_by_subcategory'][
                                                            data['subcategories']
                                                                [i]]['data']
                                                        [index]['ProductID']
                                                    .toString();
                                            final quantity =
                                                cart[productId] ?? 0;
                                            return quantity == 0
                                                ? InkWell(
                                                    onTap: () {
                                                      mobile == ""
                                                          ? (ScaffoldMessenger.of(
                                                              context)
                                                            ..removeCurrentSnackBar()
                                                            ..showSnackBar(
                                                              const SnackBar(
                                                                duration:
                                                                    Duration(
                                                                        seconds:
                                                                            2),
                                                                content: Text(
                                                                    '!Please Signin/SignUp!'),
                                                              ),
                                                            ))
                                                          : ref.read(cartProvider.notifier).increment(
                                                              data['products_by_subcategory'][data['subcategories'][i]]
                                                                              ['data']
                                                                          [index][
                                                                      'ProductID']
                                                                  .toString(),
                                                              ref,
                                                              mobile,
                                                              context,
                                                              data['products_by_subcategory']
                                                                              [data['subcategories'][i]]
                                                                          ['data'][index][
                                                                      'ProductName']
                                                                  .toString(),
                                                              data['products_by_subcategory']
                                                                              [data['subcategories'][i]]
                                                                          ['data'][index]
                                                                      ['ProductWeight']
                                                                  .toString());
                                                    },
                                                    child: Container(
                                                      height: 28,
                                                      width: 50,
                                                      decoration:
                                                          const BoxDecoration(
                                                        border: Border(
                                                          bottom: BorderSide(
                                                              width: 1.0,
                                                              color:
                                                                  Colors.pink),
                                                          top: BorderSide(
                                                              width: 1.0,
                                                              color:
                                                                  Colors.pink),
                                                          right: BorderSide(
                                                              width: 1.0,
                                                              color:
                                                                  Colors.pink),
                                                          left: BorderSide(
                                                              width: 1.0,
                                                              color:
                                                                  Colors.pink),
                                                        ),
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    5)),
                                                      ),
                                                      child: const Center(
                                                        child: FittedBox(
                                                          fit: BoxFit.fitWidth,
                                                          child: Text(
                                                            "Add",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.pink,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : Container(
                                                    padding:
                                                        const EdgeInsets.all(2),
                                                    height: 28,
                                                    width: 76,
                                                    decoration:
                                                        const BoxDecoration(
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
                                                                Colors.green),
                                                      ),
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  7)),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Expanded(
                                                          child: InkWell(
                                                            onTap: () {
                                                              ref.read(cartProvider.notifier).decrement(
                                                                  data['products_by_subcategory'][data['subcategories'][i]]['data']
                                                                              [
                                                                              index]
                                                                          [
                                                                          'ProductID']
                                                                      .toString(),
                                                                  ref,
                                                                  mobile,
                                                                  context,
                                                                  data['products_by_subcategory']
                                                                              [
                                                                              data['subcategories'][i]]['data'][index]
                                                                          [
                                                                          'ProductName']
                                                                      .toString());
                                                            },
                                                            child: Container(
                                                              color: Colors
                                                                  .green
                                                                  .shade100,
                                                              child: const Icon(
                                                                Icons.remove,
                                                                color: Colors
                                                                    .green,
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
                                                                fontSize: 10,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: InkWell(
                                                            onTap: () {
                                                              ref.read(cartProvider.notifier).increment(
                                                                  data['products_by_subcategory'][data['subcategories'][i]]['data']
                                                                              [index]
                                                                          [
                                                                          'ProductID']
                                                                      .toString(),
                                                                  ref,
                                                                  mobile,
                                                                  context,
                                                                  data['products_by_subcategory']
                                                                              [data['subcategories'][i]]['data'][index]
                                                                          [
                                                                          'ProductName']
                                                                      .toString(),
                                                                  data['products_by_subcategory'][data['subcategories'][i]]['data']
                                                                              [index]
                                                                          ['ProductWeight']
                                                                      .toString());
                                                            },
                                                            child: Container(
                                                              color: Colors
                                                                  .green
                                                                  .shade100,
                                                              child: const Icon(
                                                                Icons.add,
                                                                color: Colors
                                                                    .green,
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
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(.9),
                                      child: Text(
                                        data['products_by_subcategory']
                                                    [data['subcategories'][i]]
                                                ['data'][index]['ProductName']
                                            .toString(),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(.9),
                                      child: Text(
                                        data['products_by_subcategory']
                                                    [data['subcategories'][i]]
                                                ['data'][index]['ProductWeight']
                                            .toString(),
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(1),
                                      child: Text(
                                        "₹${data['products_by_subcategory'][data['subcategories'][i]]['data'][index]['ProductPrice']}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    const Gap(5)
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
