import 'package:coinxfiat/model/model_index.dart';

import '../utils/utils_index.dart';

class Trade {
  int? id;
  int? advertiseId;
  int? senderId;
  int? ownerId;
  String? tradeNumber;
  String? type;
  int? currencyId;
  int? receiverCurrencyId;
  List<String>? paymentMethod;
  int? paymentWindow;
  String? timeRemaining;
  double? rate;
  double? payAmount;
  double? receiveAmount;
  String? hashSlug;
  int? status;
  int? paymentMethodId;
  int? paymentInfoId;
  String? paidAt;
  String? cancelAt;
  String? disputeAt;
  String? completeAt;
  String? cancelBy;
  int? disputeBy;
  String? paymentDetails;
  String? termsOfTrade;
  int? processingMinutes;
  num? adminCharge;
  String? createdAt;
  String? updatedAt;
  List<Gateways>? gateways;
  Sender? sender;
  Currency? currency;
  Sender? owner;
  Currency? receiverCurrency;
  Advertisement? advertise;

  Trade(
      {this.id,
      this.advertiseId,
      this.senderId,
      this.ownerId,
      this.tradeNumber,
      this.type,
      this.currencyId,
      this.receiverCurrencyId,
      this.paymentMethod,
      this.paymentWindow,
      this.timeRemaining,
      this.rate,
      this.payAmount,
      this.receiveAmount,
      this.hashSlug,
      this.status,
      this.paymentMethodId,
      this.paymentInfoId,
      this.paidAt,
      this.cancelAt,
      this.disputeAt,
      this.completeAt,
      this.cancelBy,
      this.disputeBy,
      this.paymentDetails,
      this.termsOfTrade,
      this.processingMinutes,
      this.adminCharge,
      this.createdAt,
      this.updatedAt,
      this.gateways,
      this.sender,
      this.currency,
      this.owner,
      this.receiverCurrency,
      this.advertise});

  Trade.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    advertiseId = json['advertise_id'];
    senderId = json['sender_id'];
    ownerId = json['owner_id'];
    tradeNumber = json['trade_number'];
    type = json['type'];
    currencyId = json['currency_id'];
    receiverCurrencyId = json['receiver_currency_id'];
    paymentMethod = json['payment_method'].cast<String>();
    paymentWindow = json['payment_window'];
    timeRemaining = json['time_remaining'];
    rate = double.tryParse(json['rate'].toString()) ?? 0.0;
    payAmount = double.tryParse(json['pay_amount'].toString()) ?? 0.0;
    receiveAmount = double.tryParse(json['receive_amount'].toString()) ?? 0.0;
    hashSlug = json['hash_slug'];
    status = json['status'];
    paymentMethodId = json['payment_method_id'];
    paymentInfoId = json['payment_info_id'];
    paidAt = json['paid_at'];
    cancelAt = json['cancel_at'];
    disputeAt = json['dispute_at'];
    completeAt = json['complete_at'];
    cancelBy = json['cancel_by'];
    disputeBy = json['dispute_by'];
    paymentDetails = json['payment_details'];
    termsOfTrade = json['terms_of_trade'];
    processingMinutes = json['processing_minutes'];
    adminCharge = json['admin_charge'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['gateways'] != null) {
      gateways = <Gateways>[];
      json['gateways'].forEach((v) {
        gateways!.add(Gateways.fromJson(v));
      });
    }
    sender = json['sender'] != null ? Sender.fromJson(json['sender']) : null;
    currency =
        json['currency'] != null ? Currency.fromJson(json['currency']) : null;
    owner = json['owner'] != null ? Sender.fromJson(json['owner']) : null;
    receiverCurrency = json['receiver_currency'] != null
        ? Currency.fromJson(json['receiver_currency'])
        : null;
    advertise = json['advertise'] != null
        ? Advertisement.fromJson(json['advertise'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['advertise_id'] = advertiseId;
    data['sender_id'] = senderId;
    data['owner_id'] = ownerId;
    data['trade_number'] = tradeNumber;
    data['type'] = type;
    data['currency_id'] = currencyId;
    data['receiver_currency_id'] = receiverCurrencyId;
    data['payment_method'] = paymentMethod;
    data['payment_window'] = paymentWindow;
    data['time_remaining'] = timeRemaining;
    data['rate'] = rate;
    data['pay_amount'] = payAmount;
    data['receive_amount'] = receiveAmount;
    data['hash_slug'] = hashSlug;
    data['status'] = status;
    data['payment_method_id'] = paymentMethodId;
    data['payment_info_id'] = paymentInfoId;
    data['paid_at'] = paidAt;
    data['cancel_at'] = cancelAt;
    data['dispute_at'] = disputeAt;
    data['complete_at'] = completeAt;
    data['cancel_by'] = cancelBy;
    data['dispute_by'] = disputeBy;
    data['payment_details'] = paymentDetails;
    data['terms_of_trade'] = termsOfTrade;
    data['processing_minutes'] = processingMinutes;
    data['admin_charge'] = adminCharge;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (gateways != null) {
      data['gateways'] = gateways!.map((v) => v.toJson()).toList();
    }
    if (sender != null) {
      data['sender'] = sender!.toJson();
    }
    if (currency != null) {
      data['currency'] = currency!.toJson();
    }
    if (owner != null) {
      data['owner'] = owner!.toJson();
    }
    if (receiverCurrency != null) {
      data['receiver_currency'] = receiverCurrency!.toJson();
    }
    if (advertise != null) {
      data['advertise'] = advertise!.toJson();
    }
    return data;
  }
}

class Gateways {
  int? id;
  String? name;
  String? color;
  int? status;
  String? imageUrl;
  InputForm? inputForm;
  String? createdAt;
  String? updatedAt;

  Gateways(
      {this.id,
      this.name,
      this.color,
      this.status,
      this.imageUrl,
      this.inputForm,
      this.createdAt,
      this.updatedAt});

  Gateways.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    color = json['color'];
    status = json['status'];
    imageUrl = json['image_url'];
    inputForm = json['input_form'] != null
        ? InputForm.fromJson(json['input_form'])
        : null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['color'] = color;
    data['status'] = status;
    data['image_url'] = imageUrl;
    if (inputForm != null) {
      data['input_form'] = inputForm!.toJson();
    }
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class InputForm {
  AccountNumber? accountNumber;
  AccountNumber? iFSCCode;
  AccountNumber? accountHolderName;

  InputForm({this.accountNumber, this.iFSCCode, this.accountHolderName});

  InputForm.fromJson(Map<String, dynamic> json) {
    accountNumber = json['AccountNumber'] != null
        ? AccountNumber.fromJson(json['AccountNumber'])
        : null;
    iFSCCode = json['IFSCCode'] != null
        ? AccountNumber.fromJson(json['IFSCCode'])
        : null;
    accountHolderName = json['AccountHolderName'] != null
        ? AccountNumber.fromJson(json['AccountHolderName'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (accountNumber != null) {
      data['AccountNumber'] = accountNumber!.toJson();
    }
    if (iFSCCode != null) {
      data['IFSCCode'] = iFSCCode!.toJson();
    }
    if (accountHolderName != null) {
      data['AccountHolderName'] = accountHolderName!.toJson();
    }
    return data;
  }
}

class AccountNumber {
  String? name;
  String? label;
  String? type;
  String? validation;

  AccountNumber({this.name, this.label, this.type, this.validation});

  AccountNumber.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    label = json['label'];
    type = json['type'];
    validation = json['validation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['label'] = label;
    data['type'] = type;
    data['validation'] = validation;
    return data;
  }
}

class Sender {
  int? id;
  String? firstname;
  String? lastname;
  String? username;
  int? referralId;
  int? languageId;
  String? email;
  String? countryCode;
  String? phoneCode;
  String? phone;
  double? balance;
  String? image;
  String? coverImage;
  String? address;
  String? usertype;
  String? provider;
  String? providerId;
  int? status;
  int? identityVerify;
  int? addressVerify;
  int? twoFa;
  int? twoFaVerify;
  int? twoFaCode;
  int? emailVerification;
  int? smsVerification;
  int? verifyCode;
  String? sentAt;
  String? lastLogin;
  String? emailVerifiedAt;
  String? createdAt;
  String? updatedAt;
  int? completedTrade;
  int? totalMin;
  int? tradeLimit;
  bool? lastSeen;
  String? fcmToken;
  List<String>? notifyActiveTemplate;
  int? expressUser;
  String? fullname;
  String? mobile;
  String? imgPath;
  int? totalTrade;

  Sender(
      {this.id,
      this.firstname,
      this.lastname,
      this.username,
      this.referralId,
      this.languageId,
      this.email,
      this.countryCode,
      this.phoneCode,
      this.phone,
      this.balance,
      this.image,
      this.coverImage,
      this.address,
      this.usertype,
      this.provider,
      this.providerId,
      this.status,
      this.identityVerify,
      this.addressVerify,
      this.twoFa,
      this.twoFaVerify,
      this.twoFaCode,
      this.emailVerification,
      this.smsVerification,
      this.verifyCode,
      this.sentAt,
      this.lastLogin,
      this.emailVerifiedAt,
      this.createdAt,
      this.updatedAt,
      this.completedTrade,
      this.totalMin,
      this.tradeLimit,
      this.lastSeen,
      this.fcmToken,
      this.notifyActiveTemplate,
      this.expressUser,
      this.fullname,
      this.mobile,
      this.imgPath,
      this.totalTrade});

  Sender.fromJson(Map<String, dynamic> json) {
    p(' sender from json ${json['id']}');
    id = json['id'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    username = json['username'];
    referralId = json['referral_id'];
    languageId = json['language_id'];
    email = json['email'];
    countryCode = json['country_code'];
    phoneCode = json['phone_code'];
    phone = json['phone'];
    balance = double.tryParse(json['balance'].toString()) ?? 0.0;
    image = json['image'];
    coverImage = json['cover_image'];
    address = json['address'];
    usertype = json['usertype'];
    provider = json['provider'];
    providerId = json['provider_id'];
    status = json['status'];
    identityVerify = json['identity_verify'];
    addressVerify = json['address_verify'];
    twoFa = json['two_fa'];
    twoFaVerify = json['two_fa_verify'];
    twoFaCode = json['two_fa_code'];
    emailVerification = json['email_verification'];
    smsVerification = json['sms_verification'];
    verifyCode = json['verify_code'];

    sentAt = json['sent_at'];
    lastLogin = json['last_login'];
    emailVerifiedAt = json['email_verified_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    completedTrade = json['completed_trade'];
    totalMin = json['total_min'];
    tradeLimit = json['trade_limit'];
    lastSeen = json['last_seen'];
    fcmToken = json['fcm_token'];
    notifyActiveTemplate =
        (json['notify_active_template'] ?? []).cast<String>();
    expressUser = json['express_user'];
    fullname = json['fullname'];
    mobile = json['mobile'];
    imgPath = json['imgPath'];
    totalTrade = json['total_trade'];
    p('<<< sender from json $id');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    data['username'] = username;
    data['referral_id'] = referralId;
    data['language_id'] = languageId;
    data['email'] = email;
    data['country_code'] = countryCode;
    data['phone_code'] = phoneCode;
    data['phone'] = phone;
    data['balance'] = balance;
    data['image'] = image;
    data['cover_image'] = coverImage;
    data['address'] = address;
    data['usertype'] = usertype;
    data['provider'] = provider;
    data['provider_id'] = providerId;
    data['status'] = status;
    data['identity_verify'] = identityVerify;
    data['address_verify'] = addressVerify;
    data['two_fa'] = twoFa;
    data['two_fa_verify'] = twoFaVerify;
    data['two_fa_code'] = twoFaCode;
    data['email_verification'] = emailVerification;
    data['sms_verification'] = smsVerification;
    data['verify_code'] = verifyCode;
    data['sent_at'] = sentAt;
    data['last_login'] = lastLogin;
    data['email_verified_at'] = emailVerifiedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['completed_trade'] = completedTrade;
    data['total_min'] = totalMin;
    data['trade_limit'] = tradeLimit;
    data['last_seen'] = lastSeen;
    data['fcm_token'] = fcmToken;
    data['notify_active_template'] = notifyActiveTemplate;
    data['express_user'] = expressUser;
    data['fullname'] = fullname;
    data['mobile'] = mobile;
    data['imgPath'] = imgPath;
    data['total_trade'] = totalTrade;
    return data;
  }

  String get fullName => '${firstname ?? ''} ${lastname ?? ''}';
}

class Currency {
  int? id;
  String? name;
  String? code;
  String? symbol;
  double? rate;
  double? depositCharge;
  int? depositType;
  double? withdrawCharge;
  int? withdrawType;
  String? image;
  int? flag;
  String? walletAddress;
  int? status;
  double? minExpress;
  double? expressRateToUsd;
  double? maxExpress;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  Currency(
      {this.id,
      this.name,
      this.code,
      this.symbol,
      this.rate,
      this.depositCharge,
      this.depositType,
      this.withdrawCharge,
      this.withdrawType,
      this.image,
      this.flag,
      this.walletAddress,
      this.status,
      this.minExpress,
      this.expressRateToUsd,
      this.maxExpress,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  Currency.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    symbol = json['symbol'];
    rate = double.tryParse(json['rate'].toString()) ?? 0.0;
    depositCharge = double.tryParse(json['deposit_charge'].toString()) ?? 0.0;
    depositType = json['deposit_type'];
    withdrawCharge = double.tryParse(json['withdraw_charge'].toString()) ?? 0.0;
    withdrawType = json['withdraw_type'];
    image = json['image'];
    flag = json['flag'];
    walletAddress = json['wallet_address'];
    status = json['status'];
    minExpress = double.tryParse(json['min_express'].toString()) ?? 0.0;
    expressRateToUsd =
        double.tryParse(json['express_rate_to_usd'].toString()) ?? 0.0;
    maxExpress = double.tryParse(json['max_express'].toString()) ?? 0.0;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
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
    data['image'] = image;
    data['flag'] = flag;
    data['wallet_address'] = walletAddress;
    data['status'] = status;
    data['min_express'] = minExpress;
    data['express_rate_to_usd'] = expressRateToUsd;
    data['max_express'] = maxExpress;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    return data;
  }
}

// class Advertise {
//   int? id;
//   int? userId;
//   String? type;
//   int? cryptoId;
//   int? fiatId;
//   List<String>? gatewayId;
//   String? cryptoRate;
//   String? fiatRate;
//   String? priceType;
//   int? price;
//   int? rate;
//   int? paymentWindowId;
//   int? minimumLimit;
//   int? maximumLimit;
//   String? paymentDetails;
//   String? termsOfTrade;
//   int? status;
//   int? completedTrade;
//   int? totalMin;
//   String? createdAt;
//   String? updatedAt;
//   String? currencyRate;
//   List<Gateways>? gateways;
//   Currency? fiatCurrency;
//   Currency? cryptoCurrency;

//   Advertise(
//       {this.id,
//       this.userId,
//       this.type,
//       this.cryptoId,
//       this.fiatId,
//       this.gatewayId,
//       this.cryptoRate,
//       this.fiatRate,
//       this.priceType,
//       this.price,
//       this.rate,
//       this.paymentWindowId,
//       this.minimumLimit,
//       this.maximumLimit,
//       this.paymentDetails,
//       this.termsOfTrade,
//       this.status,
//       this.completedTrade,
//       this.totalMin,
//       this.createdAt,
//       this.updatedAt,
//       this.currencyRate,
//       this.gateways,
//       this.fiatCurrency,
//       this.cryptoCurrency});

//   Advertise.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     userId = json['user_id'];
//     type = json['type'];
//     cryptoId = json['crypto_id'];
//     fiatId = json['fiat_id'];
//     gatewayId = json['gateway_id'].cast<String>();
//     cryptoRate = json['crypto_rate'];
//     fiatRate = json['fiat_rate'];
//     priceType = json['price_type'];
//     price = json['price'];
//     rate = json['rate'];
//     paymentWindowId = json['payment_window_id'];
//     minimumLimit = json['minimum_limit'];
//     maximumLimit = json['maximum_limit'];
//     paymentDetails = json['payment_details'];
//     termsOfTrade = json['terms_of_trade'];
//     status = json['status'];
//     completedTrade = json['completed_trade'];
//     totalMin = json['total_min'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     currencyRate = json['currency_rate'];
//     if (json['gateways'] != null) {
//       gateways = <Gateways>[];
//       json['gateways'].forEach((v) {
//         gateways!.add(Gateways.fromJson(v));
//       });
//     }
//     fiatCurrency = json['fiat_currency'] != null
//         ? Currency.fromJson(json['fiat_currency'])
//         : null;
//     cryptoCurrency = json['crypto_currency'] != null
//         ? Currency.fromJson(json['crypto_currency'])
//         : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['user_id'] = userId;
//     data['type'] = type;
//     data['crypto_id'] = cryptoId;
//     data['fiat_id'] = fiatId;
//     data['gateway_id'] = gatewayId;
//     data['crypto_rate'] = cryptoRate;
//     data['fiat_rate'] = fiatRate;
//     data['price_type'] = priceType;
//     data['price'] = price;
//     data['rate'] = rate;
//     data['payment_window_id'] = paymentWindowId;
//     data['minimum_limit'] = minimumLimit;
//     data['maximum_limit'] = maximumLimit;
//     data['payment_details'] = paymentDetails;
//     data['terms_of_trade'] = termsOfTrade;
//     data['status'] = status;
//     data['completed_trade'] = completedTrade;
//     data['total_min'] = totalMin;
//     data['created_at'] = createdAt;
//     data['updated_at'] = updatedAt;
//     data['currency_rate'] = currencyRate;
//     if (gateways != null) {
//       data['gateways'] = gateways!.map((v) => v.toJson()).toList();
//     }
//     if (fiatCurrency != null) {
//       data['fiat_currency'] = fiatCurrency!.toJson();
//     }
//     if (cryptoCurrency != null) {
//       data['crypto_currency'] = cryptoCurrency!.toJson();
//     }
//     return data;
//   }
// }
