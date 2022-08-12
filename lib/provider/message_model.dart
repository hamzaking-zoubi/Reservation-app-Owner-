
class Message {
  final id;
  final id_send;
  final id_recipient;
  final time;
   var isRead ;
  final message;

  Message(
      {required this.id,
      required this.id_send,
      required this.id_recipient,
      required this.time,
        required this.isRead,
      required this.message,




      });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
      time: json['created_at'].toString(),
      id: json['id'].toString(),
      message: json['message'].toString(),
      id_send: json['id_send'].toString(),
      id_recipient: json['id_recipient'].toString(),
      isRead: json['read_at'] == 0 ? false : true);
}


