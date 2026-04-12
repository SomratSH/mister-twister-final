import 'package:get_it/get_it.dart';
import 'package:mister_twister/presentation/screens/authentication/controllers/change_password_controller.dart';
import 'package:mister_twister/presentation/screens/authentication/controllers/login_controller.dart';
import 'package:mister_twister/presentation/screens/authentication/controllers/signup_controller.dart';
import 'package:mister_twister/presentation/screens/private/common/map/controllers/map_controller.dart';
import 'package:mister_twister/presentation/screens/private/common/product/product_provider.dart';
import 'package:mister_twister/presentation/screens/private/common/web_scoket/driver_socket_provider.dart';
import 'package:mister_twister/presentation/screens/private/common/web_scoket/global_web_scoket.dart';
import 'package:mister_twister/presentation/screens/private/drivers/orders/controllers/orders_controller.dart';
import 'package:mister_twister/presentation/screens/private/drivers/settings/controllers/settings_controller.dart';
import 'package:mister_twister/presentation/screens/private/users/menu/controllers/cart_controller.dart';
import 'package:mister_twister/presentation/screens/private/users/settings/setting_customer_controller.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

final getIt = GetIt.instance;

class AppProvider {
  static List<SingleChildWidget> get provider => [
    ChangeNotifierProvider(create: (_) => GlobalSocketProvider()),
    ChangeNotifierProvider(create: (_) => DriverSocketProvider()..init()),

    ChangeNotifierProvider(create: (_) => LoginProvider(getIt())),
    ChangeNotifierProvider(create: (context) => SignupProvider(getIt())),
    ChangeNotifierProvider(
      create: (_) => ProductProvider(getIt())
        ..getCategories()
        ..getProduct(),
    ),
    ChangeNotifierProvider(
      create: (_) => CartController(getIt())..getCartItemList(),
    ),
    ChangeNotifierProvider(create: (_) => ChangePasswordProvider()),

    ChangeNotifierProvider(create: (_) => DriverSettingsProvider()),
    ChangeNotifierProvider(create: (_) => SettingCustomerController()),
    ChangeNotifierProvider(create: (_) => MapVController()),

    ChangeNotifierProvider(
      create: (_) => OrdersController(getIt())..getOrder()..getOnGoingOrder(),
    ),
  ];
}
