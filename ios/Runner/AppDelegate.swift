import UIKit
import Flutter
import GoogleMaps // 1. Added this missing import
import flutter_local_notifications

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    // 2. Register your Google Maps API Key
    // Replace the empty string with your actual key from the Google Cloud Console
    GMSServices.provideAPIKey("AIzaSyCX1bkX2BMHv8QF_mvKaLiFYr4ZiKwV9j8")

    // ✅ Required for flutter_local_notifications (actions support)
    FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
      GeneratedPluginRegistrant.register(with: registry)
    }

    // ✅ Register all Flutter plugins
    GeneratedPluginRegistrant.register(with: self)

    // ✅ Ensure notifications show up while app is in foreground
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
