import 'dart:developer';

import 'package:get/get_connect/http/src/request/request.dart';
import 'package:go_router/go_router.dart';
import 'package:mister_twister/core/routes/app_route_path.dart';
import 'package:mister_twister/domain/entities/order_model.dart';
import 'package:mister_twister/presentation/screens/authentication/views/change_password_screen.dart';
import 'package:mister_twister/presentation/screens/authentication/views/forgot_password_screen.dart';
import 'package:mister_twister/presentation/screens/authentication/views/login_screen.dart';
import 'package:mister_twister/presentation/screens/authentication/views/signup_screen.dart';
import 'package:mister_twister/presentation/screens/private/common/map/views/map_screen.dart';
import 'package:mister_twister/presentation/screens/private/common/settings/views/privacy_policy_screen.dart';
import 'package:mister_twister/presentation/screens/private/common/settings/views/terms_and_conditions_screen.dart';
import 'package:mister_twister/presentation/screens/private/common/splash/views/splash_screen.dart';
import 'package:mister_twister/presentation/screens/private/common/user_role/views/user_role_screen.dart';
import 'package:mister_twister/presentation/screens/private/drivers/home/views/driver_home_screen.dart';
import 'package:mister_twister/presentation/screens/private/drivers/landing_page/landing_page.dart';
import 'package:mister_twister/presentation/screens/private/drivers/menu/views/add_edit_menu_screen.dart';
import 'package:mister_twister/presentation/screens/private/drivers/menu/views/menu_list_screen.dart';
import 'package:mister_twister/presentation/screens/private/drivers/menu/views/view_menu_screen.dart';
import 'package:mister_twister/presentation/screens/private/drivers/orders/views/order_details.dart';
import 'package:mister_twister/presentation/screens/private/drivers/orders/views/orders_screen.dart';
import 'package:mister_twister/presentation/screens/private/drivers/settings/views/driver_profile_edit.dart';
import 'package:mister_twister/presentation/screens/private/drivers/settings/views/settings_screen.dart';
import 'package:mister_twister/presentation/screens/private/users/home/views/home_screen.dart';
import 'package:mister_twister/presentation/screens/private/users/home/views/order_details.dart';
import 'package:mister_twister/presentation/screens/private/users/home/views/order_tracking_screen.dart';
import 'package:mister_twister/presentation/screens/private/users/landing_page/landing_page.dart';
import 'package:mister_twister/presentation/screens/private/users/menu/views/cart_screen.dart';
import 'package:mister_twister/presentation/screens/private/users/menu/views/checkout_screen.dart';
import 'package:mister_twister/presentation/screens/private/users/menu/views/make_payment.dart';
import 'package:mister_twister/presentation/screens/private/users/menu/views/menu_list_screen.dart';
import 'package:mister_twister/presentation/screens/private/users/menu/views/searching_for_order_confirm.dart';
import 'package:mister_twister/presentation/screens/private/users/menu/views/select_address_on_map_screen.dart';
import 'package:mister_twister/presentation/screens/private/users/settings/settings_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppRouter {
  static Future<GoRouter> createRouter() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');
    final userType = prefs.getString('userType');

    final inital = (token != null && token.isNotEmpty)
        ? (userType == 'customer' ? RoutePath.home : RoutePath.homeDriver)
        : RoutePath.splash;
    return GoRouter(
      initialLocation: inital,
      debugLogDiagnostics: true,
      routes: [
        GoRoute(
          path: RoutePath.splash,
          name: 'splash',
          builder: (context, state) => const SplashScreen(),
        ),

        //authentication
        GoRoute(
          path: RoutePath.login,
          name: 'login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: RoutePath.signUp,
          name: 'signUp',
          builder: (context, state) => const SignupScreen(),
        ),
        GoRoute(
          path: RoutePath.forgotPassword,
          name: 'forgotPassword',
          builder: (context, state) => const ForgotPasswordScreen(),
        ),

        GoRoute(
          path: RoutePath.changePassword,
          name: 'chagnedPassword',
          builder: (context, state) => const ChangePasswordScreen(),
        ),

        //select role
        GoRoute(
          path: RoutePath.selectRole,
          name: 'selectRole',
          builder: (context, state) => const UserRoleScreen(),
        ),

        GoRoute(
          path: RoutePath.orderTracking,
          name: 'orderTracking',
          builder: (context, state) {
            final id = state.extra as String;
            return OrderTrackingScreen(orderId: id);
          },
        ),

        //driver landing page
        ShellRoute(
          builder: (context, state, child) => LandingPageDriver(child: child),
          routes: [
            GoRoute(
              path: RoutePath.homeDriver,
              builder: (context, state) => const DriverHomeScreen(),
            ),
            GoRoute(
              path: RoutePath.mapDriver,
              builder: (context, state) => const MapScreen(),
            ),
            GoRoute(
              path: RoutePath.requestDriver,
              builder: (context, state) => const OrdersScreen(),
            ),
            GoRoute(
              path: RoutePath.menuDriver,
              builder: (context, state) => const MenuListScreen(),
            ),
            GoRoute(
              path: RoutePath.settingDriver,
              builder: (context, state) => const DriverSettingsScreen(),
            ),
          ],
        ),

        // GoRoute(
        //   path: RoutePath.viewMenuDriver,
        //   name: 'viewMenuDriver',
        //   builder: (context, state) {
        //     final menuId = state.extra as String; // or your model
        //     return ViewMenuScreenDriver(id: menuId);
        //   },
        // ),
        GoRoute(
          path: RoutePath.editMenuDriver,
          name: 'editMenuDriver',
          builder: (context, state) {
            return AddEditMenuScreen();
          },
        ),
         GoRoute(
          path: RoutePath.editDriverProfile,
          name: 'editDriverProfile',
          builder: (context, state) {
            return ProfileUpdateScreen();
          },
        ),

        GoRoute(
          path: RoutePath.termsCondition,
          name: 'termsCondition',
          builder: (context, state) {
            return TermsAndConditionsScreen();
          },
        ),

         GoRoute(
          path: RoutePath.privacyPolicy,
          name: 'privacyPolicy',
          builder: (context, state) {
            return PrivacyPolicyScreen();
          },
        ),
        GoRoute(
          path: RoutePath.addMenu,
          builder: (context, state) => const AddEditMenuScreen(),
        ),
        //user portion
        ShellRoute(
          builder: (context, state, child) => LandingPageUser(child: child),
          routes: [
            GoRoute(
              path: RoutePath.home,
              builder: (context, state) => const HomeScreen(),
            ),
            GoRoute(
              path: RoutePath.map,
              builder: (context, state) => MapScreen(),
            ),
            GoRoute(
              path: RoutePath.menu,
              builder: (context, state) => const MenuListScreenUser(),
            ),
            GoRoute(
              path: RoutePath.setting,
              builder: (context, state) => const SettingsScreen(),
            ),
          ],
        ),
        GoRoute(
          path: RoutePath.cart,
          builder: (context, state) => const CartScreen(),
        ),
        GoRoute(
          path: RoutePath.checkout,
          builder: (context, state) => const CheckoutScreen(),
        ),
        GoRoute(
          path: RoutePath.selectAddress,
          builder: (context, state) => const SelectAddressOnMapScreen(),
        ),
        GoRoute(
          path: RoutePath.orderDetails,
          builder: (context, state) => const OrderDetailsDemoScreen(),
        ),
        GoRoute(
          path: RoutePath.payment,
          builder: (context, state) => const MakePayment(),
        ),
        GoRoute(
          path: RoutePath.previousOrders,
          builder: (context, state) => const PreviousOrdersScreen(),
        ),
        GoRoute(
          path: RoutePath.searchConfirmOrder,
          builder: (context, state) {
            return SearchingForOrderConfirm();
          },
        ),
      ],
    );
  }
}
