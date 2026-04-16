import 'package:mister_twister/constant/app_urls.dart';
import 'package:mister_twister/core/api_service/api_service.dart';
import 'package:mister_twister/domain/auth/auth_repository.dart';

class AuthImp implements AuthRepository {
  final ApiService _apiService = ApiService();

  @override
  Future<Map<String, dynamic>> signUp(Map<String, dynamic> body) async {
    final response = await _apiService.postDataRegular(AppUrls.signUp, body);
    return response;
  }

  @override
  Future<Map<String, dynamic>> login(Map<String, String> map) async {
    final response = await _apiService.postDataRegular(AppUrls.login, map);
    return response;
  }

  @override
  Future<Map<String, dynamic>> authUserDetails(String token) async {
    final response = await _apiService.getDataJwt(
      AppUrls.authDetails,
      authToken: token,
    );
    return response;
  }
}
