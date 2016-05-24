//
//  domain.swift
//  ScrapeME
//
//  Created by Samuel Barthelemy on 5/23/16.
//  Copyright © 2016 Samuel Barthelemy. All rights reserved.
//

import Foundation

class Domain {
    
    var sitePages = [String]()
    var domain: String
    
    init(domain: String) {
        self.domain = domain
    }
    
    func connectToDomain() {
    
        if let site = NSURL(string:"http://"+self.domain) {
            print("Querying: \(site)")
            do { let html = try String(contentsOfURL: site, encoding: NSUTF8StringEncoding)
                self.grabSitePages(html)
            } catch _{
                print("Could not query \(site)") }
            } else {
            print("Not a valid site")
        }
    }
    
    func grabSitePages(html: String) {
        let result = html.containsString("href")
        print(result)
    }
    
}