class UserScore {
  String username;
  int score;

  UserScore({required this.username, required this.score});

  Map toJson() => {
    'username': username,
    'score': score.toString(),
  };

  factory UserScore.fromJson(dynamic json) {
    return UserScore(username: json['username'], score: int.parse(json['score']));
  }

  @override
  String toString() {
    
    return '$username:$score';
  }
}