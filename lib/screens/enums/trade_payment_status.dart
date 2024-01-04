import 'package:flutter/material.dart';

import '../../utils/utils_index.dart';

enum TradePaymentStatus { pending, paid, cancelled, def, disputed, completed }

extension TradePaymentStatusExt on TradePaymentStatus {
  String get name {
    switch (this) {
      case TradePaymentStatus.pending:
        return 'Pending';
      case TradePaymentStatus.paid:
        return 'Buyer Paid';
      case TradePaymentStatus.cancelled:
        return 'Cancelled';
      case TradePaymentStatus.disputed:
        return 'Disputed';
      case TradePaymentStatus.completed:
        return 'Completed';
      default:
        return 'Unknown';
    }
  }

  Color get color {
    switch (this) {
      case TradePaymentStatus.pending:
        return holdColor;
      case TradePaymentStatus.paid:
        return runningColor;
      case TradePaymentStatus.cancelled:
        return cancelledColor;
      case TradePaymentStatus.disputed:
        return inProgressColor;
      case TradePaymentStatus.completed:
        return completedColor;
      default:
        return Colors.grey;
    }
  }

  int get index {
    switch (this) {
      case TradePaymentStatus.pending:
        return 0;
      case TradePaymentStatus.paid:
        return 1;
      case TradePaymentStatus.cancelled:
        return 3;
      case TradePaymentStatus.completed:
        return 4;
      case TradePaymentStatus.disputed:
        return 5;
      default:
        return 2;
    }
  }

  static TradePaymentStatus fromInt(int index) {
    switch (index) {
      case 0:
        return TradePaymentStatus.pending;
      case 1:
        return TradePaymentStatus.paid;
      case 3:
        return TradePaymentStatus.cancelled;
      case 4:
        return TradePaymentStatus.completed;
      case 5:
        return TradePaymentStatus.disputed;
      default:
        return TradePaymentStatus.def;
    }
  }
}
