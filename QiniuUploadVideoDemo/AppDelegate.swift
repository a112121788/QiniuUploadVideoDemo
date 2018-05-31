//
//  AppDelegate.swift
//  QiniuUploadVideoDemo
//
//  Created by 高帅朋 on 2018/6/1.
//  Copyright © 2018年 高帅朋. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        self.window =  UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.gray
        
        let navController = UINavigationController(rootViewController: ViewController())
        self.window?.rootViewController = navController
        self.window!.makeKeyAndVisible()
        
        return true
    }

}

