import 'package:mobx/mobx.dart';

import '../model/model_index.dart';
import '../services/service_index.dart';
import '../utils/utils_index.dart';

part 'support_store.g.dart';

final supportStore = SupportStore();
class SupportStore = _SupportStore with _$SupportStore;

abstract class _SupportStore with Store {
  @observable
  bool loadingSupportTickets = true;

  @observable
  List<Ticket> supportTickets = [];

  @action
  void setLoadingSupportTickets(bool value) => loadingSupportTickets = value;

  @action
  void setSupportTickets(List<Ticket> value) => supportTickets = value;

  Future<void> getTickets() async {
    loadingSupportTickets = true;
    await Apis.getTicketsApi(1).then((value) {
      if (value.$1) {
        supportTickets = tryCatch(() =>
                ((value.$2['tickets']?['data'] ?? []) as List)
                    .map<Ticket>((e) => Ticket.fromJson(e))
                    .toList()) ??
            [];
      }
      pl('tickets: ${supportTickets.length}');
    });
    loadingSupportTickets = false;
  }
}
