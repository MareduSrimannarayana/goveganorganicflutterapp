// ignore_for_file: unused_result

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:govegan_organics/models/statemodel.dart';
import 'package:govegan_organics/views/settings.dart';

class Ordercheckout extends ConsumerWidget {
  const Ordercheckout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderDetails = ref.watch(stateModelsNotifierProvider)['Orders'];

    double totalPrice = orderDetails.fold(
      0.0,
      (previousValue, order) =>
          previousValue +
          double.parse(order['price'].toString()) *
              double.parse(order['quantity'].toString()),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: orderDetails.length,
              itemBuilder: (BuildContext context, int index) {
                final order = orderDetails[index];
                return Card(
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            ref.refresh(raingprovider1);
                            return FeedbackPage1(
                                orderid: order['order_id'].toString(),
                                productid: order['ProductID'].toString());
                          },
                        ),
                      );
                    },
                    leading: CachedNetworkImage(
                      height: 50,
                      width: 50,
                      imageUrl: order['imageurl'].toString(),
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                    title: Text(
                      'Order ID: ${order['order_id']}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Product Name: ${order['ProductName']}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          'Weight: ${order['weight']}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                        Text(
                          'Quantity: ${order['quantity']}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    trailing: Text(
                      "₹ ${order['price'].toString()}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.green,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Color.fromARGB(255, 30, 141, 232),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total Price:",
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              Text(
                "₹ $totalPrice",
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
