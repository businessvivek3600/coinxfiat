import 'package:nb_utils/nb_utils.dart';

class WalletTransaction {
  int? id;
  int? userId;
  double? amount;
  double? charge;
  double? finalBalance;
  String? trxType;
  String? remarks;
  String? trxId;
  String? code;
  String? transactionDate;
  String? blockHeight;
  String? blockHash;
  String? fromAddress;
  String? toAddress;
  String? reference;
  String? createdAt;
  String? updatedAt;

  WalletTransaction(
      {this.id,
      this.userId,
      this.amount,
      this.charge,
      this.finalBalance,
      this.trxType,
      this.remarks,
      this.trxId,
      this.code,
      this.transactionDate,
      this.blockHeight,
      this.blockHash,
      this.fromAddress,
      this.toAddress,
      this.reference,
      this.createdAt,
      this.updatedAt});

  WalletTransaction.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    amount = double.tryParse(json['amount'].toString()).validate();
    charge = double.tryParse(json['charge'].toString()).validate();
    finalBalance = double.tryParse(json['final_balance'].toString()).validate();
    trxType = json['trx_type'];
    remarks = json['remarks'];
    trxId = json['trx_id'];
    code = json['code'];
    transactionDate = json['transaction_date'];
    blockHeight = json['block_height'];
    blockHash = json['block_hash'];
    fromAddress = json['from_address'];
    toAddress = json['to_address'];
    reference = json['reference'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['amount'] = amount;
    data['charge'] = charge;
    data['final_balance'] = finalBalance;
    data['trx_type'] = trxType;
    data['remarks'] = remarks;
    data['trx_id'] = trxId;
    data['code'] = code;
    data['transaction_date'] = transactionDate;
    data['block_height'] = blockHeight;
    data['block_hash'] = blockHash;
    data['from_address'] = fromAddress;
    data['to_address'] = toAddress;
    data['reference'] = reference;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
