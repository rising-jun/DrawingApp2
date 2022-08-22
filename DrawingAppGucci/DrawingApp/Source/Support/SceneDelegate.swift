//
//  SceneDelegate.swift
//  DrawingApp
//
//  Created by YEONGJIN JANG on 2022/07/05.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        
        guard let canvasVC = window?.rootViewController as? CanvasViewController else { return }
        canvasVC.plane = makePlaneByUnarchiver()
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        guard let canvasVC = window?.rootViewController as? CanvasViewController else { return }
        canvasVC.plane = makePlaneByUnarchiver()
        
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        archivingPlane()
        guard let image = takeSnapshot() else { return }
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
    
    private func makePlaneByUnarchiver() -> Plane {
        guard let planeData = UserDefaults.standard.data(forKey: "planeData") else {
            return Plane()
        }
        
        do {
            let unarchiver = try NSKeyedUnarchiver.init(forReadingFrom: planeData)
            unarchiver.requiresSecureCoding = false
            guard let plane = unarchiver.decodeObject(of: Plane.self, forKey: NSKeyedArchiveRootObjectKey) else { fatalError() }
            return plane
        }
        catch {
            fatalError("\"언\"아카이빙 실패")
        }
    }
    

    private func archivingPlane() {
        guard let plane = (self.window?.rootViewController as? CanvasViewController)?.plane else { return }
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: plane, requiringSecureCoding: false)
            UserDefaults.standard.set(data, forKey: "planeData")
        }
        catch {
            fatalError("아카이빙 실패")
        }
    }
    
    
    private func takeSnapshot() -> UIImage? {
        var image :UIImage?
        guard let currentLayer = self.window?.layer else { return nil }
        let currentScale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(currentLayer.frame.size, false, currentScale);
        guard let currentContext = UIGraphicsGetCurrentContext() else { return nil }
        currentLayer.render(in: currentContext)
        
        image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let img = image else { return nil }
        return img
    }
    
    
}
