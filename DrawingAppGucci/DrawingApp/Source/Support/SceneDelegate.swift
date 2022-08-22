//
//  SceneDelegate.swift
//  DrawingApp
//
//  Created by YEONGJIN JANG on 2022/07/05.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    static weak var shared: SceneDelegate?
    var window: UIWindow?
    var plane: Plane? {
        didSet {
            NotificationCenter.default.post(name: Notification.Name.plane, object: self)
        }
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        
        Self.shared = self
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        guard let planeData = UserDefaults.standard.data(forKey: "planeData") else {
            self.plane = Plane()
            return
        }
        resetUserDefaults()
        do {
            let unarchiver = try NSKeyedUnarchiver.init(forReadingFrom: planeData)
            unarchiver.requiresSecureCoding = false
            guard let plane = unarchiver.decodeObject(of: Plane.self, forKey: NSKeyedArchiveRootObjectKey) else { fatalError() }
            self.plane = plane
        }
        catch {
            fatalError("\"언\"아카이빙 실패")
        }
        
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: self.plane, requiringSecureCoding: false)
            UserDefaults.standard.set(data, forKey: "planeData")
        }
        catch {
            fatalError("아카이빙 실패")
        }
    }
    
    private func resetUserDefaults() {
        for key in UserDefaults.standard.dictionaryRepresentation().keys {
            if key.description == "planeData" {
                UserDefaults.standard.removeObject(forKey: key.description)
            }
        }
    }
}
