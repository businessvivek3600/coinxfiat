import 'package:coinxfiat/model/model_index.dart';
import 'package:flutter/material.dart';

import '../utils/utils_index.dart';

class BuySellTrade {
  int? id;
  int? userId;
  String? type;
  int? cryptoId;
  int? fiatId;
  List<int>? gatewayIds;
  double? cryptoRate;
  double? fiatRate;
  String? priceType;
  double? price;
  double? rate;
  int? paymentWindowId;
  double? minimumLimit;
  double? maximumLimit;
  String? paymentDetails;
  String? termsOfTrade;
  int? status;
  int? completedTrade;
  double? totalMin;
  String? createdAt;
  String? updatedAt;
  int? likeCount;
  int? dislikeCount;
  double? currencyRate;
  List<Gateways> gateways = const <Gateways>[];
  Crypto? fiatCurrency;
  Crypto? cryptoCurrency;
  Sender? user;
  PaymentWindow? paymentWindow;
  List<AdFeedback> feedbacks = const <AdFeedback>[];

  BuySellTrade({
    this.id,
    this.userId,
    this.type,
    this.cryptoId,
    this.fiatId,
    this.gatewayIds,
    this.cryptoRate,
    this.fiatRate,
    this.priceType,
    this.price,
    this.rate,
    this.paymentWindowId,
    this.minimumLimit,
    this.maximumLimit,
    this.paymentDetails,
    this.termsOfTrade,
    this.status,
    this.completedTrade,
    this.totalMin,
    this.createdAt,
    this.updatedAt,
    this.currencyRate,
    this.gateways = const <Gateways>[],
    this.fiatCurrency,
    this.cryptoCurrency,
    this.user,
    this.paymentWindow,
    this.likeCount = 0,
    this.dislikeCount = 0,
    this.feedbacks = const <AdFeedback>[],
  });

  BuySellTrade.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    type = json['type'];
    cryptoId = json['crypto_id'];
    fiatId = json['fiat_id'];
    gatewayIds = json['gateway_id'] != null
        ? (json['gateway_id']! as List).fold<List<int>>(
            <int>[],
            (previousValue, element) {
              if (element is int) {
                return previousValue..add(element);
              } else {
                int? id = int.tryParse(element);
                if (id != null) {
                  return previousValue..add(id);
                } else {
                  return previousValue;
                }
              }
            },
          )
        : null;
    cryptoRate = double.tryParse(json['crypto_rate'].toString());
    fiatRate = double.tryParse(json['fiat_rate'].toString());
    priceType = json['price_type'];
    price = double.tryParse(json['price'].toString()) ?? 0.0;
    rate = double.tryParse(json['rate'].toString()) ?? 0.0;
    paymentWindowId = json['payment_window_id'];
    minimumLimit = double.tryParse(json['minimum_limit'].toString()) ?? 0.0;
    maximumLimit = double.tryParse(json['maximum_limit'].toString()) ?? 0.0;
    paymentDetails = json['payment_details'];
    termsOfTrade = json['terms_of_trade'];
    status = json['status'];
    completedTrade = json['completed_trade'];
    totalMin = double.tryParse(json['total_min'].toString()) ?? 0.0;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    likeCount = int.tryParse(json['like_count'].toString()) ?? 0;
    dislikeCount = int.tryParse(json['dislike_count'].toString()) ?? 0;
    currencyRate = double.tryParse(json['currency_rate'].toString());
    if (json['gateways'] != null) {
      gateways = <Gateways>[];
      json['gateways'].forEach((v) {
        gateways.add(Gateways.fromJson(v));
      });
    }
    fiatCurrency = tryCatch(() => Crypto.fromJson(json['fiat_currency']));
    cryptoCurrency = tryCatch(() => Crypto.fromJson(json['crypto_currency']));
    if (json['user'] != null) {
      user = tryCatch(() => Sender.fromJson(json['user']));
    }
    if (json['payment_window'] != null) {
      paymentWindow =
          tryCatch(() => PaymentWindow.fromJson(json['payment_window']));
    }
    if (json['feedbacks'] != null) {
      feedbacks = tryCatch<List<AdFeedback>>(() => (json['feedbacks'] as List)
              .map<AdFeedback>((e) => AdFeedback.fromJson(e))
              .toList()) ??
          <AdFeedback>[];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['type'] = type;
    data['crypto_id'] = cryptoId;
    data['fiat_id'] = fiatId;
    data['gateway_id'] = gatewayIds;
    data['crypto_rate'] = cryptoRate;
    data['fiat_rate'] = fiatRate;
    data['price_type'] = priceType;
    data['price'] = price;
    data['rate'] = rate;
    data['payment_window_id'] = paymentWindowId;
    data['minimum_limit'] = minimumLimit;
    data['maximum_limit'] = maximumLimit;
    data['payment_details'] = paymentDetails;
    data['terms_of_trade'] = termsOfTrade;
    data['status'] = status;
    data['completed_trade'] = completedTrade;
    data['total_min'] = totalMin;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['currency_rate'] = currencyRate;
    data['gateways'] = gateways.map((v) => v.toJson()).toList();
    if (fiatCurrency != null) {
      data['fiat_currency'] = fiatCurrency!.toJson();
    }
    if (cryptoCurrency != null) {
      data['crypto_currency'] = cryptoCurrency!.toJson();
    }
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (paymentWindow != null) {
      data['payment_window'] = paymentWindow!.toJson();
    }
    return data;
  }
}
