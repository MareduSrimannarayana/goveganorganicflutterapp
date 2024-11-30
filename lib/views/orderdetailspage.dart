import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:govegan_organics/commonUI/SnackBar.dart';

import 'package:govegan_organics/models/cartmodelmap.dart';
import 'package:govegan_organics/models/statemodel.dart';
import 'package:govegan_organics/views/cart.dart';
import 'package:govegan_organics/views/order.dart';

import 'package:govegan_organics/views/rameshwaram.dart';
import 'package:govegan_organics/views/usereditpro.dart';

import 'package:http/http.dart' as http;

class NoOrdersPage extends StatelessWidget {
  const NoOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_bag_outlined,
              size: 60,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'You have no orders yet',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderDetailsPage extends ConsumerStatefulWidget {
  const OrderDetailsPage({super.key});

  @override
  ConsumerState<OrderDetailsPage> createState() =>
      _OrderDetailsPageConsumerState();
}

class _OrderDetailsPageConsumerState extends ConsumerState<OrderDetailsPage> {
  deleteallorders(BuildContext context) async {
    var user = ref.watch(userProvider).toString();
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return _loadingDialog();
      },
    );

    try {
      final response = await http.post(
        Uri.parse('https://aimldeftech.com/deleteallordersdetails.php'),
        body: {'user': user},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        call();
        Navigator.of(context).pop();
      } else {
        Navigator.of(context).pop();
        showDialog(
          context: context,
          barrierDismissible: false,
          barrierColor: Colors.transparent,
          builder: (BuildContext context) {
            return _errorDialog();
          },
        );
      }
    } catch (e) {
      Navigator.of(context).pop();
      showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.transparent,
        builder: (BuildContext context) {
          return _errorDialog();
        },
      );
    }
  }

  Widget _loadingDialog() {
    return Dialog(
      insetPadding: EdgeInsets.zero,
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
            Text('Deleting all orders Details...'),
          ],
        ),
      ),
    );
  }

  Widget _errorDialog() {
    return Dialog(
      insetPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error, color: Colors.red, size: 48.0),
            SizedBox(height: 16.0),
            Text('Failed to delete orders'),
          ],
        ),
      ),
    );
  }

  deleteOrders(BuildContext context, String id) async {
    try {
      final response = await http.post(
          Uri.parse('https://aimldeftech.com/deleteorderdetails.php'),
          body: {'id': id});
      if (response.statusCode == 200) {
        call();

        showSuccessMessage(context, message: 'Order deleted successfully');
      } else {
        showErrorMessage(context, message: 'Failed to delete order');
      }
    } catch (e) {
      showErrorMessage(context, message: 'Failed to delete order');
    }
  }

  @override
  void initState() {
    super.initState();
    call();
  }

  call() async {
    await ref.read(stateModelsNotifierProvider.notifier).appservercall("", ref);
  }

  @override
  Widget build(BuildContext context) {
    final OrderDetails = ref.watch(stateModelsNotifierProvider)['OrderDetails'];
    final badgecount = ref.watch(cartProvider).length;
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        actions: [
          GestureDetector(
              child: GestureDetector(
                  onTap: () => deleteallorders(context),
                  child: const Icon(Icons.delete, color: Colors.white))),
          const Gap(9),
          GestureDetector(
            onTap: () {
              ref.read(resuldata.notifier).update((state) => []);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const GrocerySearchPage(),
                ),
              );
            },
            child: const Icon(CupertinoIcons.search,
                size: 24, color: Colors.white),
          ),
          const Gap(9),
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const cart()));
            },
            child: badgecount == 0
                ? const Icon(CupertinoIcons.shopping_cart,
                    size: 24, color: Colors.white)
                : Badge(
                    label: Text(badgecount.toString()),
                    child: const Icon(CupertinoIcons.shopping_cart,
                        color: Colors.white)),
          ),
          const Gap(9),
        ],
        backgroundColor: Colors.black,
        title: const Text(
          'Order Details',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: OrderDetails.isNotEmpty
          ? ListView.builder(
              itemCount: OrderDetails.length,
              itemBuilder: (context, index) {
                final order = OrderDetails[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: Card(
                    elevation: 2.0,
                    child: ListTile(
                      onTap: () async {
                        await ref
                            .read(stateModelsNotifierProvider.notifier)
                            .appservercall(order['random'].toString(), ref);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Ordercheckout()));
                      },
                      title: Text(
                        'Name: ${order['first_name']}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("id : ${order['random']}"),
                          Text('Address: ${order['address']}'),
                          Text('Delivery Date: ${order['delivery_date']}'),
                        ],
                      ),
                      trailing: GestureDetector(
                          onTap: () {
                            deleteOrders(context, order['random'].toString());
                          },
                          child: const Icon(Icons.delete, color: Colors.black)),
                    ),
                  ),
                );
              },
            )
          : const Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_bag_outlined,
                      size: 60,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'You have no orders yet',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
