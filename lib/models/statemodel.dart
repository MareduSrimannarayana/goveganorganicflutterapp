import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:govegan_organics/SharedPreference/sharedprefernce.dart';
import 'package:govegan_organics/chatgptlogin/a.dart';
import 'package:govegan_organics/models/cartmodelmap.dart';
import 'package:govegan_organics/models/likemodel.dart';
import 'package:govegan_organics/views/sri.dart';

import 'package:http/http.dart' as http;

class StateModelsNotifier extends StateNotifier<Map<String, dynamic>> {
  StateModelsNotifier()
      : super({
          "Cart_ids": {},
          "Like_ids": {},
          "products_by_subcategory": {},
          "cartItems": {},
          "likedProducts": {},
          "subcategories": {},
          "OrderDetails": {},
          "Orders": {},
          "products": {}
        });

  appservercall(orderid, ref) async {
     await ref.read(cartProvider.notifier).cartlifecycleupdate(ref);
    try {
      await SharedUserPreferences.init();
      final String user = SharedUserPreferences.getMobile().toString();

      final uri = Uri.parse(
          "https://aimldeftech.com/laravel/public/api/singlestatemodel?page=1&per_page=10");
      String? bearerToken = await getToken();

      final response = await http.post(
        uri,
        headers: {
          'Authorization': 'Bearer $bearerToken',
        },
        body: {"user_id": user, "orderid": orderid},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

      
        if (data.isNotEmpty) {
          Map<String, dynamic> newState = {};

          if (state["Cart_ids"] != data['Cart_ids']) {
            newState["Cart_ids"] = data['Cart_ids'];
            newState["cartItems"] = data['cartItems'];
            List<Map<String, dynamic>> products =
                List<Map<String, dynamic>>.from(data['Cart_ids']);

            ref.read(cartProvider.notifier).update(products);
          }
          if (state["Like_ids"] != data['Like_ids']) {
            newState["Like_ids"] = data['Like_ids'];
            newState["likedProducts"] = data['likedProducts'];
            final likeProducts = data['Like_ids'];

            ref.read(likedItemProvider.notifier).update(likeProducts);
          }
          if (state["products_by_subcategory"] !=
              data['products_by_subcategory']) {
            newState["products_by_subcategory"] =
                data['products_by_subcategory'];
            newState["subcategories"] = data['subcategories'];
          }
          if (state["OrderDetails"] != data['OrderDetails']) {
            newState["OrderDetails"] = data['OrderDetails'];
            newState["Orders"] = data['Orders'];
          }
          if (state["products"] != data['products']) {
            newState["products"] = data['products'];
          }
          state = newState;
          ref.read(loadingprovider1.notifier).update((state) => false);
        }
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {}
  }
}

final stateModelsNotifierProvider =
    StateNotifierProvider<StateModelsNotifier, Map<String, dynamic>>(
        (ref) => StateModelsNotifier());
