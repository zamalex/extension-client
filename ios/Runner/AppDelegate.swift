import UIKit
import Flutter
import GoogleMaps
import Firebase

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
      FirebaseApp.configure()

    // TODO: Add your Google Maps API key
    GMSServices.provideAPIKey("AIzaSyCoSxKxD2ZLwAzehpZ5bWac8KQ7kkR7qqY")

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
