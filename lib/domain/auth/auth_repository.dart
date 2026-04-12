abstract class AuthRepository {
  Future<Map<String, dynamic>> signUp(Map<String, dynamic> body);
  Future<Map<String, dynamic>> login(Map<String, String> map);
  Future<Map<String, dynamic>> authUserDetails(String token);
}
