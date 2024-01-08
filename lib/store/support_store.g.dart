// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'support_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SupportStore on _SupportStore, Store {
  late final _$loadingSupportTicketsAtom =
      Atom(name: '_SupportStore.loadingSupportTickets', context: context);

  @override
  bool get loadingSupportTickets {
    _$loadingSupportTicketsAtom.reportRead();
    return super.loadingSupportTickets;
  }

  @override
  set loadingSupportTickets(bool value) {
    _$loadingSupportTicketsAtom.reportWrite(value, super.loadingSupportTickets,
        () {
      super.loadingSupportTickets = value;
    });
  }

  late final _$supportTicketsAtom =
      Atom(name: '_SupportStore.supportTickets', context: context);

  @override
  List<Ticket> get supportTickets {
    _$supportTicketsAtom.reportRead();
    return super.supportTickets;
  }

  @override
  set supportTickets(List<Ticket> value) {
    _$supportTicketsAtom.reportWrite(value, super.supportTickets, () {
      super.supportTickets = value;
    });
  }

  late final _$_SupportStoreActionController =
      ActionController(name: '_SupportStore', context: context);

  @override
  void setLoadingSupportTickets(bool value) {
    final _$actionInfo = _$_SupportStoreActionController.startAction(
        name: '_SupportStore.setLoadingSupportTickets');
    try {
      return super.setLoadingSupportTickets(value);
    } finally {
      _$_SupportStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSupportTickets(List<Ticket> value) {
    final _$actionInfo = _$_SupportStoreActionController.startAction(
        name: '_SupportStore.setSupportTickets');
    try {
      return super.setSupportTickets(value);
    } finally {
      _$_SupportStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
loadingSupportTickets: ${loadingSupportTickets},
supportTickets: ${supportTickets}
    ''';
  }
}
