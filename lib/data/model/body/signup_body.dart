class SignUpBody {
  String? username;
  String? password;
  String? email;
  Profile? profile;

  SignUpBody({this.username, this.password, this.email, this.profile});

  SignUpBody.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    password = json['password'];
    email = json['email'];
    profile =
    json['profile'] != null ? new Profile.fromJson(json['profile']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['password'] = this.password;
    data['email'] = this.email;
    if (this.profile != null) {
      data['profile'] = this.profile!.toJson();
    }
    return data;
  }
}

class Profile {
  String? firstName;
  String? lastName;

  Profile({this.firstName, this.lastName});

  Profile.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    return data;
  }
}