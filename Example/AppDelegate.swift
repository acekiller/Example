//
//  AppDelegate.swift
//  Example
//
//  Created by Mars Scala on 2020/11/12.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var timer: Timer!
    func application(_ application: UIApplication, didFinishLaunchingWithOptions
                        launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.timer = Timer(timeout: 5, repeat: true, completion: { [unowned self] in
            self.checkEndPoint()
        }, queue: DispatchQueue.init(label: "com.example.timer"))
        self.timer.start()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting
                        connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running,
        // this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func checkEndPoint() {
        print("checkEndPoint")
        defaultNetwork.get("/") { $0 } success: { [unowned self] (value, _) in
            self.receivedEndPointData(value: value)
        } failed: { (_, _) in
            //
        }
    }

    func receivedEndPointData(value: Data) {
        _ = try? dataStore?.insert(KeyValue.encode(key: Date().description, value: value), into: KeyValue.table)
        updateEndPointData(data: value)
    }

}
