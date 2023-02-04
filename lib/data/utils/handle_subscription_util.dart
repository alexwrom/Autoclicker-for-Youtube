


import 'dart:async';

import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:youtube_clicker/di/locator.dart';

import '../services/in_app_purchase_service.dart';

class HandleSubscriptionUtil {
  final  inAppPurchaseService = locator.get<InAppPurchaseService>();
  final Function()? onPending;
  final Function(PurchaseDetails purchaseDetails)? onPurchased;
  final Function()? onError;
  final Function()? onRestored;
  final Function()? onCanceled;

  StreamSubscription<List<PurchaseDetails>>? _streamSubscription;
  HandleSubscriptionUtil({
    this.onPending,
    this.onPurchased,
    this.onError,
    this.onRestored,
    this.onCanceled,
  });

  Future<void> init() async {
    _streamSubscription = inAppPurchaseService.storeSubscription.listen(
          (List<PurchaseDetails> events) {
        Future.forEach(
          events,
              (PurchaseDetails purchaseDetails) async {
            if (purchaseDetails.pendingCompletePurchase) {
              await inAppPurchaseService.completePurchase(purchaseDetails);
            }
            switch (purchaseDetails.status) {
              case PurchaseStatus.pending:
                onPending?.call();
                break;
              case PurchaseStatus.purchased:
                onPurchased?.call(purchaseDetails);
                break;
              case PurchaseStatus.error:
                onError?.call();
                break;
              case PurchaseStatus.restored:
                onRestored?.call();
                break;
              case PurchaseStatus.canceled:
                onCanceled?.call();
                break;
            }
          },
        );
      },
    );
  }

  void close() {
    _streamSubscription?.cancel();
  }
}