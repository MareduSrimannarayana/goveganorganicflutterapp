// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:govegan_organics/SharedPreference/sharedprefernce.dart';
import 'package:govegan_organics/chatgptlogin/a.dart';
import 'package:govegan_organics/commonUI/SnackBar.dart';

import 'package:govegan_organics/models/statemodel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

final cartProvider = StateNotifierProvider<CartNotifier, Map<String, int>>(
  (ref) => CartNotifier(),
);

class CartNotifier extends StateNotifier<Map<String, int>> {
  CartNotifier() : super({});

  Future<void> submitCartData(ref, context) async {
    await cartlifecycleupdate(ref);
  }

  Future<void> cartlifecycleupdate(WidgetRef ref) async {
    await SharedUserPreferences.init();

    final username = SharedUserPreferences.getMobile() ?? '';

      final uri =
          Uri.parse("https://aimldeftech.com/laravel/public/api/dataaa");
      String? bearerToken = await getToken();
      
       await http.post(
        uri,
        body: {"user": username, "data": convert.json.encode(state)},
        headers: {'Authorization': 'Bearer $bearerToken'},
      );

      
  }

  Future<void> cartdelete(String username, String productid, WidgetRef ref,
      BuildContext context, String productId, name) async {
    try {
      showLoadingDialog(context);
      final uri =
          Uri.parse("https://aimldeftech.com/laravel/public/api/cart/delete");
      String? bearerToken = await getToken();
      final response = await http.post(
        uri,
        body: {"user_id": username, "product_id": productid},
        headers: {'Authorization': 'Bearer $bearerToken'},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Navigator.of(context).pop();
        await ref
            .read(stateModelsNotifierProvider.notifier)
            .appservercall("", ref);

        await stateremove(productId);
        showSuccessMessage(context, message: 'Removed item $name from cart');
      } else {
        Navigator.of(context).pop();
        showErrorMessage(context, message: 'Failed to delete item...');
      }
    } catch (e) {
         Navigator.of(context).pop();
      showErrorMessage(context, message: 'Error deleting item');
    }
  }

  Future<void> cartinsert(
      String username,
      String productid,
      String quantity,
      String weight,
      WidgetRef ref,
      BuildContext context,
      String productId,
      name) async {
    try {
      showLoadingDialog(context);
      final uri =
          Uri.parse("https://aimldeftech.com/laravel/public/api/cart/insert");
      String? bearerToken = await getToken();
      final response = await http.post(
        uri,
        body: {
          "user_id": username,
          "product_id": productid,
          "quantity": quantity,
          "weight": weight,
        },
        headers: {'Authorization': 'Bearer $bearerToken'},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Navigator.of(context).pop();
        await stateadd(productId);
        showSuccessMessage(context, message: 'Added item $name to cart');
      } else {
        Navigator.of(context).pop();
        showErrorMessage(context, message: 'Failed to add item...');
      }
    } catch (e) {   Navigator.of(context).pop();
      showErrorMessage(context, message: 'Error inserting item');
    }
  }

  void update(List<Map<String, dynamic>> products) {
    for (final product in products) {
      final productId = product['product_id'].toString();
      final quantity = int.parse(product['quantity'].toString());

      state[productId] = quantity;
    }
    state = Map.from(state);
  }

  void increment(String productId, WidgetRef ref, user, context, name,weight) async {
    if (state.containsKey(productId)) {
      if (state[productId]! < 13) {
        state[productId] = state[productId]! + 1;
        state = Map.from(state);
      } else {
        showSuccessMessage(context, message: "you can add this item 13");
      }
    } else {
      var details = (
        username: user,
        productid: productId,
        quantity: "1",
        weight: weight,
      );

      await cartinsert(details.username, details.productid, details.quantity,
          details.weight, ref, context, productId, name);
    }
  }

  Future<void> stateadd(String productId) async {
    state[productId] = 1;
    state = Map.from(state);
  }

  void decrement(String productId, WidgetRef ref, user, context, name) async {
    if (state.containsKey(productId)) {
      if (state[productId]! > 1) {
        state[productId] = state[productId]! - 1;
        state = Map.from(state);
      } else {
        var details = (username: user, productid: productId);

        await cartdelete(
            details.username, details.productid, ref, context, productId, name);
      }
    }
  }

  Future<void> stateremove(String productId) async {
    state.remove(productId);
    state = Map.from(state);
  }

  void delete() {
    state.clear();
    state = Map.from(state);
  }

  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.zero,
          child: Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
        );
      },
      barrierColor: Colors.transparent,
    );
  }

 
}
