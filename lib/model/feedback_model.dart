import 'model_index.dart';

class AdFeedback {
  int? id;
  int? advertisementId;
  int? creatorId;
  int? reviewerId;
  String? feedback;
  String? position;
  String? createdAt;
  String? updatedAt;
  String? dateFormatted;
  Sender? reviewer;

  AdFeedback(
      {this.id,
      this.advertisementId,
      this.creatorId,
      this.reviewerId,
      this.feedback,
      this.position,
      this.createdAt,
      this.updatedAt,
      this.dateFormatted,
      this.reviewer});

  AdFeedback.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    advertisementId = json['advertisement_id'];
    creatorId = json['creator_id'];
    reviewerId = json['reviewer_id'];
    feedback = json['feedback'];
    position = json['position'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    dateFormatted = json['date_formatted'];
    reviewer =
        json['reviewer'] != null ? Sender.fromJson(json['reviewer']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['advertisement_id'] = advertisementId;
    data['creator_id'] = creatorId;
    data['reviewer_id'] = reviewerId;
    data['feedback'] = feedback;
    data['position'] = position;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['date_formatted'] = dateFormatted;
    if (reviewer != null) {
      data['reviewer'] = reviewer!.toJson();
    }
    return data;
  }
}

class Reviewer {
  int? id;
  String? firstname;
  String? lastname;
  String? username;
  Null? referralId;
  int? languageId;
  String? email;
  Null? countryCode;
  String? phoneCode;
  String? phone;
  String? balance;
  Null? image;
  Null? coverImage;
  String? address;
  String? usertype;
  Null? provider;
  Null? providerId;
  int? status;
  int? identityVerify;
  int? addressVerify;
  int? twoFa;
  int? twoFaVerify;
  Null? twoFaCode;
  int? emailVerification;
  int? smsVerification;
  Null? verifyCode;
  Null? sentAt;
  String? lastLogin;
  Null? emailVerifiedAt;
  String? createdAt;
  String? updatedAt;
  int? completedTrade;
  int? totalMin;
  Null? tradeLimit;
  bool? lastSeen;
  Null? fcmToken;
  List<String>? notifyActiveTemplate;
  int? expressUser;
  String? fullname;
  String? mobile;
  String? imgPath;
  int? totalTrade;

  Reviewer(
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

  Reviewer.fromJson(Map<String, dynamic> json) {
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
    balance = json['balance'];
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
    notifyActiveTemplate = json['notify_active_template'].cast<String>();
    expressUser = json['express_user'];
    fullname = json['fullname'];
    mobile = json['mobile'];
    imgPath = json['imgPath'];
    totalTrade = json['total_trade'];
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
}
