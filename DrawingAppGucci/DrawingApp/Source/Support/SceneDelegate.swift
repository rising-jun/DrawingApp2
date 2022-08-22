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
    var plane = Plane() {
        didSet {
            NotificationCenter.default.post(name: Notification.Name.plane, object: self)
        }
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        
        Self.shared = self
    }
}
