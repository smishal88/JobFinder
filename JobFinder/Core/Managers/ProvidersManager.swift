//
//  ProvidersManager.swift
//  JobFinder
//
//  Created by Suliman Mishael on 22/06/2020.
//  Copyright © 2020 LTM. All rights reserved.
//

import UIKit

/// ProvidersManager contains a shared object to stored synced providers from Firebase Remote Config
class ProvidersManager: NSObject {

    static let shared = ProvidersManager()
    
    private override init() {
        super.init()
    }
    
    var providers: [ProviderModel] = []
}
