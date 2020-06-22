//
//  APIOperator.swift
//  JobFinder
//
//  Created by Suliman Mishael on 21/06/2020.
//  Copyright © 2020 LTM. All rights reserved.
//

import UIKit
import Alamofire

//MARK: - The main operator for Job Finder
class APIOperator: NSObject {

    /// Shared instance
    static let shared = APIOperator()
    
    private override init() {
        super.init()
    }
    
    private var gitHubRequest: DataRequest?
    private var usaRequest: DataRequest?
    
    /// This is the main function to fetch job from any provider with any search criteria
    /// - parameter provider: The selected provider and if nill it will search in all providers
    /// - parameter position: To filter the data by provided Job Position
    /// - parameter location: To filter the data by provided Job Location or Address
    func getJobs(provider: ProviderModel?, position: String?, location: String?, completion:((_ results: [JobModel])->Void)?) {
        
        if let model = provider {
            self.getJobs(provider: model, position: position, location: location, completion: completion)
        } else {
            let group = DispatchGroup()
            var results: [JobModel] = []
            var completedCount = 0
            
            for provider in ProvidersManager.shared.providers {
                group.enter()
                self.getJobs(provider: provider, position: position, location: location, completion: { (jobs) in
                    results = results + jobs
                    completedCount += 1
                    group.leave()
                })
            }
            
            group.notify(queue: .main) {
                if completedCount == ProvidersManager.shared.providers.count {
                    results = results.sorted { (model1, model2) -> Bool in
                        return model1.creationDate > model2.creationDate
                    }
                    completion?(results)
                }
            }
        }
    }
    
    private func getJobs(provider: ProviderModel, position:String?, location: String?, completion: ((_ results: [JobModel])->Void)?) {
        
        guard let url = URL(string: provider.dataUrl) else {
            completion?([])
            return
        }
        
        var params: [String: Any]? = [:]
        if let position = position {
            params?[provider.positionParam] = position.replacingOccurrences(of: " ", with: "+")
        }
        if let location = location {
            params?[provider.locationParam] = location.replacingOccurrences(of: " ", with: "+")
        }
        
        var headers : HTTPHeaders?
        
        if let auth = provider.auth {
            headers = [
                auth.key: auth.value
            ]
        }
        let request = AF.request(url, method: .get, parameters: params, encoding:  URLEncoding.default , headers: headers, interceptor: .none, requestModifier: { $0.timeoutInterval = 60 })
        
        request.responseJSON(completionHandler: { (response) in
            switch response.result {
            case let .success(data):
                var response = data
                if let keyStrategy = provider.keyStrategy {
                    let keys = keyStrategy.split(separator: ">").map { (sub) -> String in
                        return String(sub)
                    }
                    if let res = response as? [String: Any] {
                        
                        var lastChild: Any?
                        
                        for key in keys {
                            lastChild = lastChild == nil ? res[key] : (lastChild as? [String:Any])?[key]
                        }
                        
                        guard let items = lastChild as? [[String: Any]] else {
                            completion?([])
                            return
                        }
                        response = items
                        
                    } else {
                        completion?([])
                    }
                }
                
                if let preMapping = provider.preMapping {
                    guard let items = response as? [[String: Any]] else {
                        completion?([])
                        return
                    }
                    
                    let matches = items.map { (dic) -> [String: Any] in
                        return (dic[preMapping] as? [String: Any]) ?? [:]
                    }
                    response = matches
                }
                
                guard let items = response as? [[String: Any]], let data = try? JSONSerialization.data(withJSONObject: items, options: .init(rawValue: 0)) else {
                    completion?([])
                    return
                }
                
                let decoder = JSONDecoder()
                let models = try? decoder.decode([JobModel].self, from: data)
                completion?(models ?? [])
                
                break
            case .failure(_):
                completion?([])
                break
            }
        })
    }
}
