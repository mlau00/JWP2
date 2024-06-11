class UserModel {
  final String userId;
  final String userLogin;
  // final String userPassword;
  final String userSessionId;

  const UserModel(
      {required this.userId,
      required this.userLogin,
      // required this.userPassword,
      required this.userSessionId});

  factory UserModel.fronJson(Map<String, dynamic> json) {
    String userId = json['user_id'];
    String userLogin = json['user_login'];
    String userSessionId = json['user_session_id'];
    return UserModel(
        userId: userId, userLogin: userLogin, userSessionId: userSessionId);
  }
}
