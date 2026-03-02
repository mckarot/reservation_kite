class User {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;
  final String role;
  final int walletBalance;
  final DateTime createdAt;
  final DateTime? lastSeen;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.createdAt, this.photoUrl,
    this.role = 'client',
    this.walletBalance = 0,
    this.lastSeen,
  });

  factory User.empty() {
    return User(
      id: '',
      name: '',
      email: '',
      createdAt: DateTime.now(),
    );
  }
}