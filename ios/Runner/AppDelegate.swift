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
    GMSServices.provideAPIKey("AIzaSyAYW-IVxLxSP59bwwr7-76sfJNG7SxY4eQ")

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
