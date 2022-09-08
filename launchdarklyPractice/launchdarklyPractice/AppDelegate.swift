//
//  AppDelegate.swift
//  launchdarklyPractice
//
//  Created by Chan Jung on 9/2/22.
//

import Foundation
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        LDService.shared.startLDClient()

        return true
      }
}
