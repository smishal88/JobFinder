//
//  ProviderModel.swift
//  JobFinder
//
//  Created by Suliman Mishael on 22/06/2020.
//  Copyright © 2020 LTM. All rights reserved.
//

import Foundation

struct ProviderModel: Decodable {
    var id              : Int
    var name            : String
    var dataUrl         : String
    var positionParam   : String
    var locationParam   : String
    var keyStrategy     : String?
    var preMapping      : String?
    var dateFormate     : String
    var auth            : AuthModel?
    var keys            : [JobModelKeys]
    
    enum keys: String, CodingKey {
        case id
        case name
        case dataUrl
        case positionParam
        case locationParam
        case keyStrategy
        case preMapping
        case dateFormate
        case auth
        case keys
    }
}

struct JobModelKeys: Decodable {
    var appKey  : String
    var jsonKey : String
    
    enum keys: String, CodingKey {
        case appKey
        case jsonKey
    }
}

struct AuthModel: Decodable {
    var key   : String
    var value : String
    
    enum keys: String, CodingKey {
        case key
        case value
    }
}
