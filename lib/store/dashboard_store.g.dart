// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$DashboardStore on _DashboardStore, Store {
  late final _$isLoadingAtom =
      Atom(name: '_DashboardStore.isLoading', context: context);

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$totalTradeAtom =
      Atom(name: '_DashboardStore.totalTrade', context: context);

  @override
  int get totalTrade {
    _$totalTradeAtom.reportRead();
    return super.totalTrade;
  }

  @override
  set totalTrade(int value) {
    _$totalTradeAtom.reportWrite(value, super.totalTrade, () {
      super.totalTrade = value;
    });
  }

  late final _$runningTradeAtom =
      Atom(name: '_DashboardStore.runningTrade', context: context);

  @override
  int get runningTrade {
    _$runningTradeAtom.reportRead();
    return super.runningTrade;
  }

  @override
  set runningTrade(int value) {
    _$runningTradeAtom.reportWrite(value, super.runningTrade, () {
      super.runningTrade = value;
    });
  }

  late final _$completedTradeAtom =
      Atom(name: '_DashboardStore.completedTrade', context: context);

  @override
  int get completedTrade {
    _$completedTradeAtom.reportRead();
    return super.completedTrade;
  }

  @override
  set completedTrade(int value) {
    _$completedTradeAtom.reportWrite(value, super.completedTrade, () {
      super.completedTrade = value;
    });
  }

  late final _$gatewaysAtom =
      Atom(name: '_DashboardStore.gateways', context: context);

  @override
  int get gateways {
    _$gatewaysAtom.reportRead();
    return super.gateways;
  }

  @override
  set gateways(int value) {
    _$gatewaysAtom.reportWrite(value, super.gateways, () {
      super.gateways = value;
    });
  }

  late final _$totalReferralAtom =
      Atom(name: '_DashboardStore.totalReferral', context: context);

  @override
  int get totalReferral {
    _$totalReferralAtom.reportRead();
    return super.totalReferral;
  }

  @override
  set totalReferral(int value) {
    _$totalReferralAtom.reportWrite(value, super.totalReferral, () {
      super.totalReferral = value;
    });
  }

  late final _$tradeListAtom =
      Atom(name: '_DashboardStore.tradeList', context: context);

  @override
  List<Trade> get tradeList {
    _$tradeListAtom.reportRead();
    return super.tradeList;
  }

  @override
  set tradeList(List<Trade> value) {
    _$tradeListAtom.reportWrite(value, super.tradeList, () {
      super.tradeList = value;
    });
  }

  late final _$walletListAtom =
      Atom(name: '_DashboardStore.walletList', context: context);

  @override
  List<Wallet> get walletList {
    _$walletListAtom.reportRead();
    return super.walletList;
  }

  @override
  set walletList(List<Wallet> value) {
    _$walletListAtom.reportWrite(value, super.walletList, () {
      super.walletList = value;
    });
  }

  late final _$getDashboardDataAsyncAction =
      AsyncAction('_DashboardStore.getDashboardData', context: context);

  @override
  Future<void> getDashboardData() {
    return _$getDashboardDataAsyncAction.run(() => super.getDashboardData());
  }

  late final _$_DashboardStoreActionController =
      ActionController(name: '_DashboardStore', context: context);

  @override
  void setLoading(bool value) {
    final _$actionInfo = _$_DashboardStoreActionController.startAction(
        name: '_DashboardStore.setLoading');
    try {
      return super.setLoading(value);
    } finally {
      _$_DashboardStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setTotalTrade(int value) {
    final _$actionInfo = _$_DashboardStoreActionController.startAction(
        name: '_DashboardStore.setTotalTrade');
    try {
      return super.setTotalTrade(value);
    } finally {
      _$_DashboardStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setRunningTrade(int value) {
    final _$actionInfo = _$_DashboardStoreActionController.startAction(
        name: '_DashboardStore.setRunningTrade');
    try {
      return super.setRunningTrade(value);
    } finally {
      _$_DashboardStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCompletedTrade(int value) {
    final _$actionInfo = _$_DashboardStoreActionController.startAction(
        name: '_DashboardStore.setCompletedTrade');
    try {
      return super.setCompletedTrade(value);
    } finally {
      _$_DashboardStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setGateways(int value) {
    final _$actionInfo = _$_DashboardStoreActionController.startAction(
        name: '_DashboardStore.setGateways');
    try {
      return super.setGateways(value);
    } finally {
      _$_DashboardStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setTotalReferral(int value) {
    final _$actionInfo = _$_DashboardStoreActionController.startAction(
        name: '_DashboardStore.setTotalReferral');
    try {
      return super.setTotalReferral(value);
    } finally {
      _$_DashboardStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setTradeList(List<Trade> value) {
    final _$actionInfo = _$_DashboardStoreActionController.startAction(
        name: '_DashboardStore.setTradeList');
    try {
      return super.setTradeList(value);
    } finally {
      _$_DashboardStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setWalletList(List<Wallet> value) {
    final _$actionInfo = _$_DashboardStoreActionController.startAction(
        name: '_DashboardStore.setWalletList');
    try {
      return super.setWalletList(value);
    } finally {
      _$_DashboardStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
totalTrade: ${totalTrade},
runningTrade: ${runningTrade},
completedTrade: ${completedTrade},
gateways: ${gateways},
totalReferral: ${totalReferral},
tradeList: ${tradeList},
walletList: ${walletList}
    ''';
  }
}
