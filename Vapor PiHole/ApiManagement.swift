//
//  ApiCall.swift
//  Vapor PiHole
//
//  Created by Brendan Mosby on 5/27/20.
//  Copyright © 2020 Brendan Mosby. All rights reserved.
//

import Foundation
import SwiftUI
import Alamofire
import SwiftyJSON

class ApiManagement {
        
    func CheckForValidIP(ip: String, apiKey: String, completionHandler: @escaping (Bool) -> Void) {
        let url = "http://\(ip)/admin/api.php?summary"
        
        if LoadUserDefaults() {
            completionHandler(true)
        }
        else {
            AF.request(url).validate().responseJSON { response in
                if let status = response.response?.statusCode {
                    if (status) == 200 {
                        self.SaveUserDefaults(ip: ip, apiKey: apiKey)
                        completionHandler(true)
                    }
                    else {
                        print("Error with response status: \(status)")
                        completionHandler(false)
                    }
                }
            }
        }
    }
    
    func SaveUserDefaults(ip: String, apiKey: String) {
        let defaults = UserDefaults.standard
        defaults.set(ip, forKey: "ipAddress")
        defaults.set(apiKey, forKey: "apiKey")
        print("Saved pihole info")
    }
    
    func LoadUserDefaults() -> Bool {
        var savedSettingsValidated = false
        let defaults = UserDefaults.standard
        let ipAddress = defaults.string(forKey: "ipAddress")
        let apiKey = defaults.string(forKey: "apiKey")
        if (ipAddress != "" && apiKey != "") {
            print("Saved info found!")
            savedSettingsValidated = true
        }
        return savedSettingsValidated
    }
    
    func GiveInfo() -> (String, String) {
        let defaults = UserDefaults.standard
        let ipAddress = defaults.string(forKey: "ipAddress")
        let apiKey = defaults.string(forKey: "apiKey")
        if (ipAddress != "" && apiKey != "") {
            return (ipAddress!, apiKey!)
        }
        else {
            return ("NULL", "NULL")
        }
    }
    
    func DisablePiHole(seconds: Int, completionHandler: @escaping (Bool) -> Void) {
        let defaults = UserDefaults.standard
        let ipAddress = defaults.string(forKey: "ipAddress")
        let apiKey = defaults.string(forKey: "apiKey")
        
        let url = "http://\(ipAddress ?? "pi.hole")/admin/api.php?disable=(\(seconds))&auth=\(apiKey ?? "")"
        
        AF.request(url).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let disableJSON = JSON(value)
                
                if let disableStatus = disableJSON["status"].string {
                    if (disableStatus == "disabled") {
                        completionHandler(true)
                    }
                    else {
                        completionHandler(false)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func GetTotalQueries(completionHandler: @escaping (String) -> Void) {
        
        let ipAddress = GiveInfo().0
        let apiKey = GiveInfo().1
        
        if (ipAddress == "NULL" || apiKey == "NULL") {
            completionHandler("Failed")
        }
        
        let url = "http://\(ipAddress)/admin/api.php?summary&auth=\(apiKey)"
        
        AF.request(url).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let summaryJSON = JSON(value)
                
                if let totalQueries = summaryJSON["dns_queries_today"].string {
                    completionHandler(totalQueries)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func GetQueriesBlocked(completionHandler: @escaping (String) -> Void) {
        
        let ipAddress = GiveInfo().0
        let apiKey = GiveInfo().1
        
        if (ipAddress == "NULL" || apiKey == "NULL") {
            completionHandler("Failed")
        }
        
        let url = "http://\(ipAddress)/admin/api.php?summary&auth=\(apiKey)"
        
        AF.request(url).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let summaryJSON = JSON(value)
                
                if let queriesBlocked = summaryJSON["ads_blocked_today"].string {
                    completionHandler(queriesBlocked)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func GetPercentBlocked(completionHandler: @escaping (String) -> Void) {
        
        let ipAddress = GiveInfo().0
        let apiKey = GiveInfo().1
        
        if (ipAddress == "NULL" || apiKey == "NULL") {
            completionHandler("Failed")
        }
        
        let url = "http://\(ipAddress)/admin/api.php?summary&auth=\(apiKey)"
        
        AF.request(url).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let summaryJSON = JSON(value)
                
                if let percentBlocked = summaryJSON["ads_percentage_today"].string {
                    completionHandler(percentBlocked)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func GetDomainsOnBlockList(completionHandler: @escaping (String) -> Void) {
        
        let ipAddress = GiveInfo().0
        let apiKey = GiveInfo().1
        
        if (ipAddress == "NULL" || apiKey == "NULL") {
            completionHandler("Failed")
        }
        
        let url = "http://\(ipAddress)/admin/api.php?summary&auth=\(apiKey)"
        
        AF.request(url).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let summaryJSON = JSON(value)
                
                if let domains = summaryJSON["domains_being_blocked"].string {
                    completionHandler(domains)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
