import 'route_index.dart';

class Paths {
  ///Splash
  static const String splash = '/${Routes.splash}';

  ///Auth
  static const String login = '/${Routes.login}';
  static const String register = '/${Routes.register}';
  static const String forgotPassword = '/${Routes.forgotPassword}';

  ///Dashboard
  static const String dashboard = '/${Routes.dashboard}';

  ///sub-path
  ///Wallet
  static const String walletDetails =
      '${Paths.dashboard}/${Routes.walletDetails}';
  static String buySell(String type, String? requestId) =>
      '${Paths.dashboard}/$type/trade/request${requestId != null ? '/$requestId' : ''}';

  ///payout history
  static const String payoutHistory =
      '${Paths.dashboard}/${Routes.payoutHistory}';
  static const String transactionHistory =
      '${Paths.dashboard}/${Routes.transactionHistory}';

  ///advertisement
  static String feedback(String? id) =>
      '${Paths.dashboard}/${Routes.feedback}${id != null ? '/$id' : ''}';
  static String createOrEditAd(String type, String? id) =>
      '${Paths.dashboard}/advertisments/$type${id != null ? '/$id' : ''}';

  ///trade
  static String tradeDetails(String? id) =>
      '${Paths.dashboard}/trade/details${id != null ? '/$id' : ''}';
  static String tradeList(String? type, String? addId) =>
      '${Paths.dashboard}/trade/list/${type ?? 'all'}?adId=${addId ?? ''}';

  ///profile
  static const String profile = '${Paths.dashboard}/${Routes.profile}';
  static const String editProfile =
      '${Paths.dashboard}/${Routes.profile}/${Routes.editProfile}';

  ///company
  static const String aboutUs = '/${Routes.aboutUs}';

  ///support
  static const String support = '/${Routes.dashboard}/${Routes.support}';
  static const String chat =
      '/${Routes.dashboard}/${Routes.support}/${Routes.chat}';
}
