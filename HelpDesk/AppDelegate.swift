//
//  AppDelegate.swift
//  HelpDesk
//
//  Created by Michael Madans on 3/10/16.
//  Copyright © 2016 TeamHelpDesk. All rights reserved.
//

import UIKit
import Parse
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var users : [PFUser]?
    var userQuery : PFQuery?

    let googleMapsApiKey = "AIzaSyA43avkpx9nU9sHlfm2w8NTknoAByv2Em0"

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil))  // types are UIUserNotificationType members
        
        GMSServices.provideAPIKey(googleMapsApiKey)
        
        Parse.initializeWithConfiguration(
            ParseClientConfiguration(block: { (configuration:ParseMutableClientConfiguration) -> Void in
                //configuration.applicationId = "HelpDesk"
                configuration.applicationId = "HelpDeskDemo"
                
                //configuration.clientKey = "asdkasjdkasbjfd"
                configuration.clientKey = "aefgneskbgksedgrdbgdkrhjtg"
                
                //configuration.server = "https://afternoon-shore-56186.herokuapp.com/parse"
                configuration.server = "https://help-desk-demo.herokuapp.com/parse"
            
            })
        )
        
        
        if PFUser.currentUser() != nil {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("homeNav") as! UITabBarController
            window?.rootViewController = vc
            _ = HelpDeskUser.sharedInstance
            
        }
        
        NSNotificationCenter.defaultCenter().addObserverForName("UserDidLogout", object: nil, queue: NSOperationQueue.mainQueue()) { (NSNotification) -> Void in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateInitialViewController()
            self.window?.rootViewController = vc
            
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: nil, name: "RefreshedData", object: nil)
        NSNotificationCenter.defaultCenter().postNotificationName("RefreshedData", object: nil)
        /*
        NSNotificationCenter.defaultCenter().addObserverForName("logout", object: nil, queue: NSOperationQueue.mainQueue()){ (NSNotification) -> Void in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateInitialViewController()
            self.window?.rootViewController = vc
        }*/
        
        
        return true
    }
    
//    func onTimer() {
//        userQuery = PFUser.query()
//        var ids = [String]()
//        for person in HelpDeskUser.sharedInstance.people! {
//            ids.append(person.objectId!)
//        }
//        userQuery?.whereKey("_id", containedIn: ids)
//        userQuery!.limit = 20
//        userQuery!.findObjectsInBackgroundWithBlock { (users: [PFObject]?, error: NSError?) -> Void in
//            if error == nil {
//                self.users = users! as? [PFUser]
//            } else {
//                // handle error
//                print(error?.localizedDescription)
//            }
//        }
//    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    

    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        //UIAlertView(title: notification.alertTitle, message: notification.alertBody, delegate: nil, cancelButtonTitle: "OK").show()

    }
}

