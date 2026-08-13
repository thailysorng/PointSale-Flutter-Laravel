class UserSession {
  static final UserSession instance = UserSession._internal();

  UserSession._internal();

  Map<String, dynamic>? user;

  void clear() {
    user = null;
  }
}