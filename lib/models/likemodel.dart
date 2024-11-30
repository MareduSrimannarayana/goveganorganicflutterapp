import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:govegan_organics/chatgptlogin/a.dart';
import 'package:govegan_organics/commonUI/SnackBar.dart';
import 'package:govegan_organics/models/statemodel.dart';

import 'package:http/http.dart' as http;

class LikedItemNotifier extends StateNotifier<Set<String>> {
  LikedItemNotifier() : super(<String>{});
  update(product) {
    final productIds =
        product.map<String>((product) => product.toString()).toList();
    state = Set.from(productIds);
  }

  void like(username, productid, context, ref, name) async {
    showDialog(
      barrierColor: Colors.transparent,
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Dialog(
          insetPadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          child: Center(child: CircularProgressIndicator(color: Colors.white)),
        );
      },
    );

    try {
      final uri =
          Uri.parse("https://aimldeftech.com/laravel/public/api/likedproducts");
      String? bearerToken = await getToken();
      final response = await http.post(uri, body: {
        "user_id": "$username",
        "product_id": "$productid"
      }, headers: {
        'Authorization': 'Bearer $bearerToken',
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        add(productid);

        Navigator.of(context).pop();
        showErrorMessage(context, message: "Added $name to whishlist");
      } else {
        Navigator.of(context).pop();
        showErrorMessage(context, message: "Failed to add");
      }
    } catch (e) {
      Navigator.of(context).pop();
      showErrorMessage(context, message: "Exception occurred");
      
    }
  }

  void likeremove(username, productid, context, ref, name) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return const Dialog(
          insetPadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          child: Center(child: CircularProgressIndicator(color: Colors.white)),
        );
      },
    );

    try {
      final uri = Uri.parse(
          "https://aimldeftech.com/laravel/public/api/likedproductsremove");
      String? bearerToken = await getToken();
      final response = await http.post(uri, body: {
        "user_id": "$username",
        "product_id": "$productid"
      }, headers: {
        'Authorization': 'Bearer $bearerToken',
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        await ref
            .read(stateModelsNotifierProvider.notifier)
            .appservercall("", ref);
        Navigator.of(context).pop();
        await remove(productid);

        showErrorMessage(context, message: "Remove $name from whishlist");
      } else { Navigator.of(context).pop();
        showErrorMessage(context, message: "Failed to remove");
      }
    } catch (e) {
      Navigator.of(context).pop();
      showErrorMessage(context, message: "Exception occurred");
   
    }
  }

  void toggleLikeda(String index, WidgetRef ref, user, context, name) {
    if (state.contains(index)) {
      var details = (username: user, productid: index);
      ref
          .read(likedItemProvider.notifier)
          .likeremove(details.username, details.productid, context, ref, name);
    } else {
      var details = (username: user, productid: index);
      ref
          .read(likedItemProvider.notifier)
          .like(details.username, details.productid, context, ref, name);
    }
  }

  remove(index) {
    state = Set<String>.from(state)..remove(index);
  }

  add(index) {
    state = Set<String>.from(state)..add(index);
  }
}

final likedItemProvider =
    StateNotifierProvider<LikedItemNotifier, Set<String>>((ref) {
  return LikedItemNotifier();
});
