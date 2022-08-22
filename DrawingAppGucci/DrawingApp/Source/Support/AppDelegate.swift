//
//  AppDelegate.swift
//  DrawingApp
//
//  Created by YEONGJIN JANG on 2022/07/05.
//
    
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        return true
    }

    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        guard let plane = (mainStoryboard.instantiateViewController(withIdentifier: "Canvas") as? CanvasViewController)?.plane else { return }
        
        
        archivingPlane(with: plane)
    }
    
    private func archivingPlane(with plane: Plane) {
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: plane, requiringSecureCoding: false)
            UserDefaults.standard.set(data, forKey: "planeData")
        }
        catch {
            fatalError("아카이빙 실패")
        }
    }
}

