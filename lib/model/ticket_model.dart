class Ticket {
  int? id;
  int? userId;
  String? name;
  String? email;
  String? ticket;
  String? subject;
  int? status;
  String? lastReply;
  String? createdAt;
  String? updatedAt;

  Ticket(
      {this.id,
      this.userId,
      this.name,
      this.email,
      this.ticket,
      this.subject,
      this.status,
      this.lastReply,
      this.createdAt,
      this.updatedAt});

  Ticket.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    name = json['name'];
    email = json['email'];
    ticket = json['ticket'];
    subject = json['subject'];
    status = json['status'];
    lastReply = json['last_reply'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['name'] = name;
    data['email'] = email;
    data['ticket'] = ticket;
    data['subject'] = subject;
    data['status'] = status;
    data['last_reply'] = lastReply;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class TicketMessage {
  int? id;
  int? ticketId;
  int? adminId;
  String? message;
  String? createdAt;
  String? updatedAt;

  TicketMessage(
      {this.id,
      this.ticketId,
      this.adminId,
      this.message,
      this.createdAt,
      this.updatedAt});

  TicketMessage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ticketId = json['ticket_id'];
    adminId = json['admin_id'];
    message = json['message'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['ticket_id'] = ticketId;
    data['admin_id'] = adminId;
    data['message'] = message;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
