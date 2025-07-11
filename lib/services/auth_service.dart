import '../models/user.dart';

class AuthService {
  static const List<User> _mockUsers = [
    User(username: 'emlys', password: 'password123'),
    User(username: 'admin', password: 'admin123'),
  ];

  Future<bool> login(String username, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Check if user exists in mock data
    return _mockUsers.any(
      (user) => user.username == username && user.password == password,
    );
  }

  Future<void> logout() async {
    // Implement logout logic
    await Future.delayed(const Duration(milliseconds: 500));
  }
}