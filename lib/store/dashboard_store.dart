import 'dart:developer';

import 'package:mobx/mobx.dart';
import '../model/model_index.dart';
import '../services/service_index.dart';
import '../utils/utils_index.dart';

part 'dashboard_store.g.dart';

final dashboardStore = DashboardStore();

class DashboardStore = _DashboardStore with _$DashboardStore;

abstract class _DashboardStore with Store {
  @observable
  bool isLoading = true;

  @observable
  int totalTrade = 0;

  @observable
  int runningTrade = 0;

  @observable
  int completedTrade = 0;

  @observable
  int gateways = 0;

  @observable
  int totalReferral = 0;

  @observable
  List<Trade> tradeList = [];

  @observable
  List<Wallet> walletList = [];

  @action
  void setLoading(bool value) {
    isLoading = value;
  }

  @action
  void setTotalTrade(int value) {
    totalTrade = value;
  }

  @action
  void setRunningTrade(int value) {
    runningTrade = value;
  }

  @action
  void setCompletedTrade(int value) {
    completedTrade = value;
  }

  @action
  void setGateways(int value) {
    gateways = value;
  }

  @action
  void setTotalReferral(int value) {
    totalReferral = value;
  }

  @action
  void setTradeList(List<Trade> value) {
    tradeList = value;
    log('tradeList : $tradeList');
  }

  @action
  void setWalletList(List<Wallet> value) {
    walletList = value;
    log('walletList : $walletList');
  }

  @action
  Future<void> getDashboardData() async {
    try {
      setLoading(true);
      await Apis.getDashboardDataApi().then((value) {
        Map<String, dynamic> data = value.$2['data'];
        if (value.$1 && data.isNotEmpty) {
          setTotalReferral(data['referral_count'] ?? 0);
          setTotalTrade(data['trades']['totalTrade'] ?? 0);
          setRunningTrade(data['trades']['runningTrade'] ?? 0);
          setCompletedTrade(data['trades']['completeTrade'] ?? 0);
          setGateways(data['gateways'] ?? 0);
          try {
            setTradeList(
                ((data['recentTrades'] != null && data['recentTrades'] is List)
                        ? data['recentTrades']
                        : [])
                    .map<Trade>((e) => Trade.fromJson(e))
                    .toList());
          } catch (e) {
            logger.e('trade list error : ',
                error: e, tag: 'dashboard_store.dart');
          }

          ///wallets
          try {
            setWalletList(((data['wallets'] != null && data['wallets'] is List)
                    ? data['wallets']
                    : [])
                .map<Wallet>((e) => Wallet.fromJson(e))
                .toList());
          } catch (e) {
            logger.e('wallet list error : ', error: e, tag: 'dashboard_store');
          }
        }
      }).catchError((e) {
        logger.e(e);
      });
    } catch (e) {
      logger.e(e);
    }
    setLoading(false);
  }
}
