class User {
  const User(this.uid, this.email, this.userType);

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      json['uid'] as String,
      json['email'] as String,
      json['userType'] as String,
    );
  }

  final String uid;
  final String email;
  final String userType;
}
