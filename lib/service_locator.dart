import 'package:get_it/get_it.dart';
import 'package:mister_twister/data/auth/auth_imp.dart';
import 'package:mister_twister/data/common/product_repo_imp.dart';
import 'package:mister_twister/data/driver/order_repo_imp.dart';
import 'package:mister_twister/data/user/cart_imp.dart';
import 'package:mister_twister/domain/auth/auth_repository.dart';
import 'package:mister_twister/domain/driver/order_repository.dart';
import 'package:mister_twister/domain/common/product_repository.dart';
import 'package:mister_twister/domain/user/cart_repository.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerLazySingleton<AuthRepository>(() => AuthImp());
  getIt.registerLazySingleton<ProductRepository>(() => ProductRepoImp());
  getIt.registerLazySingleton<CartRepository>(() => CartImp());
  getIt.registerLazySingleton<OrderRepository>(() => OrderRepoImp());
  // Repository

  // // Providers / Controllers
  // getIt.registerFactory<LoginProvider>(() => LoginProvider());
  // getIt.registerFactory<SignupProvider>(
  //   () => SignupProvider(getIt<AuthRepository>()),
  // );
  // getIt.registerFactory<ChangePasswordProvider>(() => ChangePasswordProvider());
  // getIt.registerFactory<MenuListProvider>(() => MenuListProvider());
  // getIt.registerFactory<DriverMenuProvider>(() => DriverMenuProvider());
  // getIt.registerFactory<DriverSettingsProvider>(() => DriverSettingsProvider());
}


