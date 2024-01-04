import 'package:nb_utils/nb_utils.dart';

class Wallet {
  int? id;
  int? userId;
  int? cryptoCurrencyId;
  String? walletAddress;
  double? balance;
  String? createdAt;
  String? updatedAt;
  Crypto? crypto;

  Wallet(
      {this.id,
      this.userId,
      this.cryptoCurrencyId,
      this.walletAddress,
      this.balance,
      this.createdAt,
      this.updatedAt,
      this.crypto});

  Wallet.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    cryptoCurrencyId = json['crypto_currency_id'];
    walletAddress = json['wallet_address'];
    balance = double.tryParse(json['balance'].toString()).validate();
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    crypto = json['crypto'] != null ? Crypto.fromJson(json['crypto']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['crypto_currency_id'] = cryptoCurrencyId;
    data['wallet_address'] = walletAddress;
    data['balance'] = balance;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (crypto != null) {
      data['crypto'] = crypto!.toJson();
    }
    return data;
  }

  String formatWalletAddress(String? address) {
    if (address == null) {
      return 'N/A'; // or any other placeholder for null values
    }

    if (address.length < 6) {
      return 'Invalid Address';
    }

    final String start = address.substring(0, 6);
    final String end = address.substring(address.length - 4);
    return '$start...$end';
  }
}

class Crypto {
  int? id;
  String? name;
  String? code;
  String? symbol;
  double? rate;
  double? depositCharge;
  int? depositType;
  double? withdrawCharge;
  int? withdrawType;
  int? flag;
  int? status;
  int? minExpress;
  double? expressRateToUsd;
  int? maxExpress;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? imageUrl;

  Crypto(
      {this.id,
      this.name,
      this.code,
      this.symbol,
      this.rate,
      this.depositCharge,
      this.depositType,
      this.withdrawCharge,
      this.withdrawType,
      this.flag,
      this.status,
      this.minExpress,
      this.expressRateToUsd,
      this.maxExpress,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.imageUrl});

  Crypto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    symbol = json['symbol'];
    rate = double.tryParse(json['rate'].toString()).validate();
    depositCharge =
        double.tryParse(json['deposit_charge'].toString()).validate();
    depositType = json['deposit_type'];
    withdrawCharge =
        double.tryParse(json['withdraw_charge'].toString()).validate();
    withdrawType = json['withdraw_type'];
    flag = json['flag'];
    status = json['status'];
    minExpress = json['min_express'];
    expressRateToUsd =
        double.tryParse(json['express_rate_to_usd'].toString()).validate();
    maxExpress = json['max_express'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['code'] = code;
    data['symbol'] = symbol;
    data['rate'] = rate;
    data['deposit_charge'] = depositCharge;
    data['deposit_type'] = depositType;
    data['withdraw_charge'] = withdrawCharge;
    data['withdraw_type'] = withdrawType;
    data['flag'] = flag;
    data['status'] = status;
    data['min_express'] = minExpress;
    data['express_rate_to_usd'] = expressRateToUsd;
    data['max_express'] = maxExpress;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    data['image_url'] = imageUrl;
    return data;
  }
}
