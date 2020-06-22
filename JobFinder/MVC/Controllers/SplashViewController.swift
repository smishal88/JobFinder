//
//  SplashViewController.swift
//  JobFinder
//
//  Created by Suliman Mishael on 22/06/2020.
//  Copyright © 2020 LTM. All rights reserved.
//

import UIKit
import Firebase

class SplashViewController: UIViewController {

    private var remoteConfig: RemoteConfig!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        
        fetchRemoteConfig()
        // Do any additional setup after loading the view.
    }
    
    private func fetchRemoteConfig() {
        remoteConfig.fetchAndActivate { [weak self] status, error in
            guard let `self` = self else {return}
            if (status == .successFetchedFromRemote || status == .successUsingPreFetchedData) {
                let providers = self.remoteConfig["providers"].dataValue
                let decoder = JSONDecoder()
                if let models = try? decoder.decode([ProviderModel].self, from: providers) {
                    ProvidersManager.shared.providers = models
                    self.openMainScreen()
                } else {
                    self.presentError(message: "Decoding error\n\nPlease check the firebase json structure")
                }
            } else {
                self.presentError(message: "Could not fetch data, please try again")
            }
        }
    }
    
    private func presentError(message: String) {
        let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { [weak self] (_) in
            alert.dismiss(animated: true, completion: nil)
            self?.fetchRemoteConfig()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func openMainScreen() {
        if let nav = self.storyboard?.instantiateViewController(withIdentifier: "mainNav") as? UINavigationController {
            nav.modalPresentationStyle = .fullScreen
            nav.modalTransitionStyle = .crossDissolve
            self.present(nav, animated: true, completion: nil)
        }
    }

}
