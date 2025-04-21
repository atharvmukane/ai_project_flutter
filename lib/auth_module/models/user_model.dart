class User {
  final String id;
  String fullName;
  String email;
  final String role;
  final String avatar;
  final String accessToken;
  String fcmToken;
  final bool isActive;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
    required this.avatar,
    required this.isActive,
    required this.accessToken,
    this.fcmToken = '',
  });

  static User jsonToUser(
    Map user, {
    required String accessToken,
  }) {
    return User(
      id: user['_id'],
      fullName: user['fullName'],
      email: user['email'],
      role: user['role'],
      avatar: user['avatar'] ?? '',
      accessToken: accessToken,
      isActive: user['isActive'] ?? true,
    );
  }
}
