import '../constants/constants_index.dart';
import '../database/database_index.dart';
import '../model/model_index.dart';
import '../utils/utils_index.dart';

class Apis {
  static const tag = 'Apis';

  /// get dashboard data
  static Future<(bool, Map<String, dynamic>)> getDashboardDataApi() async {
    try {
      var (bool status, Map<String, dynamic> data, String? message) =
          await ApiHandler.fetchData(ApiConst.dashboard, method: ApiMethod.GET);
      if (status && data.isNotEmpty) {
        return (true, data);
      } else {
        return (false, <String, dynamic>{});
      }
    } catch (e) {
      logger.e('register error : $e', tag: tag);
    }
    return (false, <String, dynamic>{});
  }

  /// get wallets
  static Future<(List<Crypto>, List<Wallet>)> getWalletsApi() async {
    try {
      var (bool status, Map<String, dynamic> _data, String? message) =
          await ApiHandler.fetchData(ApiConst.wallets, method: ApiMethod.GET);
      if (status && _data['data'] != null && _data['data'].isNotEmpty) {
        var data = _data['data'];
        List<Crypto> cryptoList = [];
        List<Wallet> walletList = [];
        try {
          cryptoList = ((data['cryptos'] != null && data['cryptos'] is List)
                  ? data['cryptos']
                  : [])
              .map<Crypto>((e) => Crypto.fromJson(e))
              .toList();
        } catch (e) {
          logger.e('crypto list error : ', error: e, tag: tag);
        }

        ///wallets
        try {
          walletList = ((data['wallets'] != null && data['wallets'] is List)
                  ? data['wallets']
                  : [])
              .map<Wallet>((e) => Wallet.fromJson(e))
              .toList();
        } catch (e) {
          logger.e('wallet list error : ', error: e, tag: tag);
        }
        return (cryptoList, walletList);
      } else {
        return (<Crypto>[], <Wallet>[]);
      }
    } catch (e) {
      logger.e('getWalletsApi error : $e', tag: tag);
    }
    return (<Crypto>[], <Wallet>[]);
  }

  ///add wallet
  static Future<(bool status, Map<String, dynamic> data, String? message)>
      addWalletApi({required String id}) async {
    try {
      var (bool status, Map<String, dynamic> data, String? message) =
          await ApiHandler.fetchData(ApiConst.addWallet, data: {'wallet': id});
      if (status) {
        return (true, data, null);
      } else {
        return (false, <String, dynamic>{}, message);
      }
    } catch (e) {
      logger.e('addWalletApi error : $e', tag: tag);
    }
    return (false, <String, dynamic>{}, null);
  }

  ///buy sell trades
  static Future<(bool status, Map<String, dynamic> data, String? message)>
      buySellTradesApi({
    required String type,
    int page = 1,
    String username = '',
    String cryptoId = '',
    String fiat = '',
    String paymentMethod = '',
  }) async {
    try {
      var (
        bool status,
        Map<String, dynamic> data,
        String? message
      ) = await ApiHandler.fetchData(
          '${ApiConst.buySellTrades(type, page: page)}&seller=$username&crypto=$cryptoId&fiat=$fiat&gateway=$paymentMethod',
          method: ApiMethod.GET);
      if (status && data.isNotEmpty && data['data'] != null) {
        return (true, data['data'] as Map<String, dynamic>, null);
      } else {
        return (false, <String, dynamic>{}, message);
      }
    } catch (e) {
      logger.e('buySellTradesApi error : $e', tag: tag);
    }
    return (false, <String, dynamic>{}, null);
  }

  ///getBuySellTradeRequest
  static Future<(bool status, Map<String, dynamic> data, String? message)>
      getBuySellTradeRequestApi(String type, String id) async {
    try {
      var (bool status, Map<String, dynamic> data, String? message) =
          await ApiHandler.fetchData(ApiConst.getBuySellTradeRequest(type, id),
              method: ApiMethod.GET);
      if (status && data.isNotEmpty && data['data'] != null) {
        return (true, data['data'] as Map<String, dynamic>, null);
      } else {
        return (false, <String, dynamic>{}, message);
      }
    } catch (e) {
      logger.e('getBuySellTradeRequestApi error : $e', tag: tag);
    }
    return (false, <String, dynamic>{}, null);
  }

  /// getWalletTransactions
  static Future<(bool status, Map<String, dynamic> data, String? message)>
      getWalletTransactionsApi({required String type, int page = 1}) async {
    try {
      var (bool status, Map<String, dynamic> _data, String? message) =
          await ApiHandler.fetchData(
              ApiConst.getWalletTransactions(type, page: page),
              method: ApiMethod.GET);
      if (status && _data.isNotEmpty && _data['data'] != null) {
        return (true, (_data['data'] ?? {}) as Map<String, dynamic>, null);
      } else {
        return (false, <String, dynamic>{}, message);
      }
    } catch (e) {
      logger.e('getWalletTransactionsApi error : $e', tag: tag);
    }
    return (false, <String, dynamic>{}, null);
  }

  ///get advertisements
  static Future<(bool status, Map<String, dynamic> data, String? message)>
      getAdvertisementsApi(
          {String? type,
          int page = 1,
          String? currencyCode,
          String? status}) async {
    try {
      var (bool _status, Map<String, dynamic> data, String? message) =
          await ApiHandler.fetchData(
              ApiConst.getAdvertisement(
                  page: page,
                  currencyCode: currencyCode ?? '',
                  status: status ?? '',
                  type: type ?? ''),
              method: ApiMethod.GET);
      if (_status && data.isNotEmpty && data['data'] != null) {
        return (true, data['data'] as Map<String, dynamic>, null);
      } else {
        return (false, <String, dynamic>{}, message);
      }
    } catch (e) {
      logger.e('getAdvertisementsApi error : $e', tag: tag);
    }
    return (false, <String, dynamic>{}, null);
  }

  ///get advertisements
  static Future<(bool status, Map<String, dynamic> data, String? message)>
      getTradesApi(
          {String? type,
          int page = 1,
          String? currencyCode,
          String? status,
          String? adId}) async {
    try {
      var (bool _status, Map<String, dynamic> data, String? message) =
          await ApiHandler.fetchData(
              ApiConst.trades(page: page, type: type ?? 'all', adId: adId),
              method: ApiMethod.GET);
      if (_status && data.isNotEmpty && data['data'] != null) {
        return (true, data['data'] as Map<String, dynamic>, null);
      } else {
        return (false, <String, dynamic>{}, message);
      }
    } catch (e) {
      logger.e('getTradesApi error : $e', tag: tag);
    }
    return (false, <String, dynamic>{}, null);
  }

  ///get trade details
  static Future<(bool status, Map<String, dynamic> data, String? message)>
      getTradeDetailsApi(String slug) async {
    try {
      var (bool _status, Map<String, dynamic> data, String? message) =
          await ApiHandler.fetchData(ApiConst.tradeDetails(slug),
              method: ApiMethod.GET);
      if (_status && data.isNotEmpty && data['data'] != null) {
        return (true, data['data'] as Map<String, dynamic>, null);
      } else {
        return (false, <String, dynamic>{}, message);
      }
    } catch (e) {
      logger.e('getTradeDetailsApi error : $e', tag: tag);
    }
    return (false, <String, dynamic>{}, null);
  }

  /// get trade chat messages
  static Future<(bool status, Map<String, dynamic> data, String? message)>
      getTradeChatMessagesApi(String slug,
          {int perPage = 10, required dynamic chatId}) async {
    try {
      var (
        bool _status,
        Map<String, dynamic> data,
        String? message
      ) = await ApiHandler.fetchData(
          ApiConst.tradeChatMessages(slug, perPage: perPage, chatId: chatId),
          method: ApiMethod.GET);
      if (_status && data.isNotEmpty && data['data'] != null) {
        return (true, data['data'] as Map<String, dynamic>, null);
      } else {
        return (false, <String, dynamic>{}, message);
      }
    } catch (e) {
      logger.e('getTradeChatMessagesApi error : $e', tag: tag);
    }
    return (false, <String, dynamic>{}, null);
  }

  /// push trade message
  static Future<(bool status, Map<String, dynamic> data, String? message)>
      pushTradeMessageApi(dynamic info) async {
    try {
      var (bool _status, Map<String, dynamic> data, String? message) =
          await ApiHandler.fetchData(ApiConst.pushTradeMessage,
              method: ApiMethod.POST, data: info);
      if (_status && data.isNotEmpty) {
        return (true, data['data'] as Map<String, dynamic>, null);
      } else {
        return (false, <String, dynamic>{}, message);
      }
    } catch (e) {
      logger.e('pushTradeMessageApi error : $e', tag: tag);
    }
    return (false, <String, dynamic>{}, null);
  }

  /// enableAdvertisementApi
  static Future<(bool status, Map<String, dynamic> data, String? message)>
      enableAdvertisementApi(bool enable, String id) async {
    try {
      var (bool status, Map<String, dynamic> data, String? message) =
          await ApiHandler.fetchData(ApiConst.enableAdvertisement(enable, id),
              method: ApiMethod.POST);
      if (status && data.isNotEmpty) {
        return (true, data, message);
      } else {
        return (false, <String, dynamic>{}, message);
      }
    } catch (e) {
      logger.e('enableAdvertisementApi error : $e', tag: tag);
    }
    return (false, <String, dynamic>{}, null);
  }

  ///get createAdGetData
  static Future<(bool status, Map<String, dynamic> data, String? message)>
      createAdGetDataApi() async {
    try {
      var (bool status, Map<String, dynamic> data, String? message) =
          await ApiHandler.fetchData(ApiConst.createAdGetData,
              method: ApiMethod.GET);
      if (status && data.isNotEmpty) {
        return (true, (data['data'] ?? {}) as Map<String, dynamic>, message);
      } else {
        return (false, <String, dynamic>{}, message);
      }
    } catch (e) {
      logger.e('createAdGetDataApi error : $e', tag: tag);
    }
    return (false, <String, dynamic>{}, null);
  }

  ///get updateAdGetData
  static Future<(bool status, Map<String, dynamic> data, String? message)>
      updateAdGetDataApi(String id) async {
    try {
      var (bool status, Map<String, dynamic> data, String? message) =
          await ApiHandler.fetchData(ApiConst.updateAdGetData(id),
              method: ApiMethod.GET);
      if (status && data.isNotEmpty) {
        return (true, (data['data'] ?? {}) as Map<String, dynamic>, message);
      } else {
        return (false, <String, dynamic>{}, message);
      }
    } catch (e) {
      logger.e('updateAdGetDataApi error : $e', tag: tag);
    }
    return (false, <String, dynamic>{}, null);
  }

  /// create ad
  static Future<(bool status, Map<String, dynamic> data, String? message)>
      createAdApi(Map<String, dynamic> info) async {
    try {
      var (bool status, Map<String, dynamic> data, String? message) =
          await ApiHandler.fetchData(ApiConst.createAd,
              method: ApiMethod.POST, data: info);
      if (status && data.isNotEmpty) {
        return (true, data, message);
      } else {
        return (false, <String, dynamic>{}, message);
      }
    } catch (e) {
      logger.e('createAdApi error : $e', tag: tag);
    }
    return (false, <String, dynamic>{}, null);
  }

  /// feadbacks
  static Future<(bool status, Map<String, dynamic> data, String? message)>
      getFeedbacksApi(int page, String id) async {
    try {
      var (bool status, Map<String, dynamic> data, String? message) =
          await ApiHandler.fetchData(ApiConst.feedbacksOnAd(id, page),
              method: ApiMethod.GET);
      if (status && data.isNotEmpty) {
        return (true, data, message);
      } else {
        return (false, <String, dynamic>{}, message);
      }
    } catch (e) {
      logger.e('feadbacksApi error : $e', tag: tag);
    }
    return (false, <String, dynamic>{}, null);
  }

  ///update profile
  static Future<(bool status, Map<String, dynamic> data, String? message)>
      updateProfileApi(Map<String, dynamic> info) async {
    try {
      var (bool status, Map<String, dynamic> data, String? message) =
          await ApiHandler.fetchData(ApiConst.updateProfile,
              method: ApiMethod.POST, data: info);
      if (status && data.isNotEmpty) {
        return (true, data, message);
      } else {
        return (false, <String, dynamic>{}, message);
      }
    } catch (e) {
      logger.e('updateProfileApi error : $e', tag: tag);
    }
    return (false, <String, dynamic>{}, null);
  }
}
