//
//  JobModel.swift
//  JobFinder
//
//  Created by Suliman Mishael on 21/06/2020.
//  Copyright © 2020 LTM. All rights reserved.
//

import Foundation

struct JobModel: Decodable {
    var jobTitle    : String
    var company     : String
    var companyLogo : String?
    var location    : String
    var creationDate: Date
    var detailsUrl  : String
    
    enum key: String, CodingKey {
        case jobTitleGitHub = "title"
        case companyGitHub = "company"
        case companyLogoGitHub = "company_logo"
        case locationGitHub = "location"
        case creationDateGitHub = "created_at"
        case detailsUrlGitHub = "url"
        
        case jobTitleUSAJobs = "PositionTitle"
        case companyUSAJobs = "OrganizationName"
        case locationUSAJobs = "PositionLocation"
        case creationDateUSAJobs = "PublicationStartDate"
        case detailsUrlUSAJobs = "PositionURI"
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: key.self)
        self.jobTitle = try container.decodeIfPresent(String.self, forKey: .jobTitleGitHub) ??  container.decodeIfPresent(String.self, forKey: .jobTitleUSAJobs) ?? ""
        self.company = try container.decodeIfPresent(String.self, forKey: .companyGitHub) ?? container.decodeIfPresent(String.self, forKey: .companyUSAJobs) ?? ""
        self.companyLogo = try container.decodeIfPresent(String.self, forKey: .companyLogoGitHub)
        if let loc =  try container.decodeIfPresent(String.self, forKey: .locationGitHub) {
            self.location = loc
        } else {
            let loc = try container.decodeIfPresent([LocationUSAJobs].self, forKey: .locationUSAJobs)?.map({ (model) -> String in
                return model.LocationName
            })
            self.location = (loc ?? []).joined(separator: ", ")
            
        }
        if let gitHubDateStr = try container.decodeIfPresent(String.self, forKey: .creationDateGitHub) {
            
            let formatter = DateFormatter()
            formatter.dateFormat = "E MMM dd HH:mm:ss z yyyy"
            self.creationDate = formatter.date(from: gitHubDateStr)!
            
        } else if let usaDateStr = try container.decodeIfPresent(String.self, forKey: .creationDateUSAJobs) {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            self.creationDate = formatter.date(from: usaDateStr)!
            
        } else {
            self.creationDate = Date()
        }
        self.detailsUrl = try container.decodeIfPresent(String.self, forKey: .detailsUrlGitHub) ??  container.decodeIfPresent(String.self, forKey: .detailsUrlUSAJobs) ?? ""
    }
    
    struct LocationUSAJobs: Decodable {
        var LocationName : String
        
        enum key: String, CodingKey {
            case LocationName
        }
    }
}

