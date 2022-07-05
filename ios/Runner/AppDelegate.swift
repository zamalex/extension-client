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
//      FirebaseApp.configure()
      if FirebaseApp.app() == nil {
          FirebaseApp.configure()
          }
    // TODO: Add your Google Maps API key
    GMSServices.provideAPIKey("AIzaSyAq0Cg4zS64Xmz9jtI-OJC1tKFIwiHieWg")

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
