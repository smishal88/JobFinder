//
//  ActivityIndicatorManager.swift
//  JobFinder
//
//  Created by Suliman Mishael on 21/06/2020.
//  Copyright © 2020 LTM. All rights reserved.
//

import UIKit

class ActivityIndicatorManager: NSObject {

    static let shared = ActivityIndicatorManager()
    private let view = Bundle.main.loadNibNamed("ActivityIndicatorView", owner: self, options: nil)![0] as! UIView
    private var isPresented = false
    func present() {
        if Thread.isMainThread {
            if isPresented {
                self.view.removeFromSuperview()
            }
            view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
            UIApplication.shared.keyWindow?.addSubview(view)
            isPresented = true
        } else {
            DispatchQueue.main.async { [weak self] in
                guard let `self` = self else {return}
                if self.isPresented {
                    self.view.removeFromSuperview()
                }
                self.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
                UIApplication.shared.keyWindow?.addSubview(self.view)
                self.isPresented = true
            }
        }
    }
    func dismiss() {
        if Thread.isMainThread {
            if isPresented {
                view.removeFromSuperview()
                isPresented = false
            }
        } else {
            DispatchQueue.main.async { [weak self] in
                guard let `self` = self else {return}
                if self.isPresented {
                    self.view.removeFromSuperview()
                    self.isPresented = false
                }
            }
        }
        
    }
}
