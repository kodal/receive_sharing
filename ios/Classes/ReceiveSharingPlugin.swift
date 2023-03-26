import Flutter
import UIKit

public class ReceiveSharingPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
    
    
    static let kEventChannel = "receive_sharing/events";
    
    private var customSchemePrefix = "ShareMedia";
    
    private var eventSink: FlutterEventSink? = nil;
    
    private var last: [String: String?]? = nil;
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "receive_sharing", binaryMessenger: registrar.messenger())
        let instance = ReceiveSharingPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        print("register")
        
        let eventChannel = FlutterEventChannel(name: kEventChannel, binaryMessenger: registrar.messenger())
        eventChannel.setStreamHandler(instance)
        registrar.addApplicationDelegate(instance)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        result("iOS " + UIDevice.current.systemVersion)
    }
    
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        eventSink = events
        print("onListen")
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        return nil
    }
    
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [AnyHashable : Any] = [:]) -> Bool {
        if let url = launchOptions[UIApplication.LaunchOptionsKey.url] as? URL {
            return handleUrl(url: url)
        } else if let activityDictionary = launchOptions[UIApplication.LaunchOptionsKey.userActivityDictionary] as? [AnyHashable: Any] {
            // Handle multiple URLs shared in
            for key in activityDictionary.keys {
                if let userActivity = activityDictionary[key] as? NSUserActivity {
                    if let url = userActivity.webpageURL {
                        return handleUrl(url: url)
                    }
                }
            }
        }
        return true
    }
    
    // This is the function called on resuming the app from a shared link.
    // It handles requests to open a resource by a specified URL. Returning true means that it was handled successfully, false means the attempt to open the resource failed.
    // If the URL includes the module's ShareMedia prefix, then we process the URL and return true if we know how to handle that kind of URL or false if we are not able to.
    // If the URL does not include the module's prefix, then we return false to indicate our module's attempt to open the resource failed and others should be allowed to.
    // Reference: https://developer.apple.com/documentation/uikit/uiapplicationdelegate/1623112-application
    public func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return handleUrl(url: url)
    }
    
    // This function is called by other modules like Firebase DeepLinks.
    // It tells the delegate that data for continuing an activity is available. Returning true means that our module handled the activity and that others do not have to. Returning false tells
    // iOS that our app did not handle the activity.
    // If the URL includes the module's ShareMedia prefix, then we process the URL and return true if we know how to handle that kind of URL or false if we are not able to.
    // If the URL does not include the module's prefix, then we must return false to indicate that this module did not handle the prefix and that other modules should try to.
    // Reference: https://developer.apple.com/documentation/uikit/uiapplicationdelegate/1623072-application
    public func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]) -> Void) -> Bool {
        return handleUrl(url: userActivity.webpageURL)
    }
    
    private func handleUrl(url: URL?) -> Bool {
        print("url: " + (url?.absoluteString ?? ""))
        guard let url = url else { return false }
        let scheme = url.scheme
        // By Adding bundle id to prefix, we'll ensure that the correct application will be openned
        // - found the issue while developing multiple applications using this library, after "application(_:open:options:)" is called, the first app using this librabry (first app by bundle id alphabetically) is opened
        let hasMatchScheme = scheme == customSchemePrefix || scheme == "\(self.customSchemePrefix)-\(Bundle.main.bundleIdentifier!)"
        if !hasMatchScheme { return false }
        let appGroupId = (Bundle.main.object(forInfoDictionaryKey: "AppGroupId") as? String) ?? "group.\(Bundle.main.bundleIdentifier!)"
        let userDefaults = UserDefaults(suiteName: appGroupId)
        var text: String? = nil
        text = url.absoluteString
        guard let key = url.host?.components(separatedBy: "=").last else { return false }
        let object = userDefaults?.object(forKey: key)
        let sharedArray =  object as? [String]
        text = sharedArray?.joined(separator: "")
        guard let text = text else {return false }
        let data = [
            "text": text,
            "type": "text",
        ];
        if eventSink == nil {
            last = data
        } else {
            last = nil
            eventSink?(data)
        }
        print(data)
        return true
    }
}
