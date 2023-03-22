class User {
  String username;
  String password;

  User({required this.username, required this.password});

  Map toJson() => {
    'username': username,
    'password': password,
  };

  factory User.fromJson(dynamic json) {
    return User(username: json['username'], password: json['password']);
  }

  @override
  String toString() {
    
    return '$username:$password';
  }
}