
import 'package:flutter/widgets.dart';

import 'package:govegan_organics/models/cartmodelmap.dart';

class MyAppLifecycleObserver extends WidgetsBindingObserver {
  MyAppLifecycleObserver(this.ref, this.context);
  final ref;
  final BuildContext context;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.hidden ||
        state == AppLifecycleState.detached) {
     
      ref.read(cartProvider.notifier).submitCartData(ref, context);
    } else if (state == AppLifecycleState.resumed) {
      print('App resumed: $state');
    }
  }
}
