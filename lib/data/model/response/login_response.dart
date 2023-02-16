class LoginResponse {
  String? sessionId;
  String? consumerUuid;

  LoginResponse({this.sessionId, this.consumerUuid});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    sessionId = json['session_id'];
    consumerUuid = json['consumer_uuid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['session_id'] = this.sessionId;
    data['consumer_uuid'] = this.consumerUuid;
    return data;
  }
}