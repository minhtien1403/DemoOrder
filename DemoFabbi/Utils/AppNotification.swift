//
//  AppNotification.swift
//  DemoFabbi
//
//  Created by tientm on 05/02/2024.
//

import Foundation

enum AppNotification {
    
    case medalDidChange
    case restaurenDidChange
    
    var name: Notification.Name {
        Notification.Name("App.\(String(describing: self))")
    }
}

class NotificationCenterServices {
    
    private init() {}
    
    private let notificationCenter: NotificationCenter = .default
    
    static let shared = NotificationCenterServices()
    
    func addObserver(_ observer: Any, selector: Selector, name: NSNotification.Name?, object: Any?) {
        notificationCenter.addObserver(observer, selector: selector, name: name, object: object)
    }
    
    func post(name: NSNotification.Name, object: Any?, userInfo: [AnyHashable: Any]?) {
        notificationCenter.post(name: name, object: object, userInfo: userInfo)
    }
    
    func post(name: NSNotification.Name, object: Any?) {
        notificationCenter.post(name: name, object: object)
    }
    
    func removeObserver(_ observer: Any) {
        notificationCenter.removeObserver(observer)
    }
}
