class ApiConst {
  static const String baseUrl = "https://arthurmaurice.com/api/";

  ///auth
  static const String login = "auth/login";
  static const String logout = "auth/logout";
  static const String register = "auth/register";
  static const String getUser = "getUser";
  static const String updateProfile = "user/updateInformation";

  static const String sendMobileVerification = "user/resend-verify?type=phone";
  static const String sendEmailVerification = "user/resend-verify?type=email";
  static const String verifyEmail = "user/verify-email";
  static const String verifyMobile = "user/verify-sms";
  static const String forgotPassword = "password/email";
  static const String forgotPasswordSubmit = "submit-password-otp";
  static const String updatePassword = "user/change-password";
  static const String updateProfileImage = "user/update-profile-image";

  static const String bidHistory = "user/bids";
  static const String winnigBids = "user/winning-bids";
  static const String refferals = "user/get-referrals";

  ///dashboard
  static const String dashboard = "user/dashboard";
  static const String wallets = "user/wallet";
  static const String addWallet = "user/wallet/add";
  static String buySellTrades(String type, {required int page}) =>
      "user/trades/$type?page=$page"; //buy or sell
  static String getBuySellTradeRequest(String type, String id) =>
      'user/$type/trade/request/$id'; // get buy or sell trade request
  static String getWalletTransactions(String type, {required int page}) =>
      "user/transaction/$type?page=$page"; //buy or sell
  static String getAdvertisement(
          {required int page,
          String? currencyCode = '',
          String? status = '',
          String? type = ''}) =>
      "user/advertisments?currencyCode=$currencyCode&type=$type&status=$status&page=$page"; //buy or sell
  static String enableAdvertisement(bool enable, String id) =>
      '/user/advertisments/${enable ? 'enable' : 'disable'}/$id';
  static const String createAdGetData = 'user/advertisments/create';
  static String updateAdGetData(String id) => 'user/advertisments/edit/$id';
  static const String createAd = 'user/advertisments/store';
  static String feedbacksOnAd(String id, int page) =>
      '/user/feedback/$id?page=$page';
  static String trades(
          {required int page, required String type, String? adId}) =>
      "user/trade/list/$type?page=$page${adId != null && adId.isNotEmpty ? '&adId=$adId' : ''}"; //trade list
  static String tradeDetails(String slug) =>
      "user/trade/details/$slug"; //trade list
  static String tradeChatMessages(String slug,
          {int perPage = 10, int? chatId}) =>
      'user/push-chat-show/$slug?perpage=$perPage${chatId != null ? '&chat_id=$chatId' : ''}';
  static const String pushTradeMessage = 'user/push-chat-newMessage';
  static const String liveAuctionProducts = "live-auction-products";
  static const String upcomingAuctionProducts = "upcoming-auction-products";
  static const String closedAuctionProducts = "closed-auction-products";

  ///category
  static const String categories = "categories";
  static const String categoryProducts = "category-products";

  ///auction
  static const String auction = "auction";
  static const String placeBid = "place-bid";
  static const String productBids = "product-bids";
  static const String productAllRatings = "all-ratings";
  static const String rateProduct = "rate-product";

  ///transaction
  static const String getTransactions = "user/transactions";
  static const String getDeposits = "user/deposit/history";
}
