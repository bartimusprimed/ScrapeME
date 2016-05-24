//
//  domain.swift
//  ScrapeME
//
//  Created by Samuel Barthelemy on 5/23/16.
//  Copyright © 2016 Samuel Barthelemy. All rights reserved.
//


import Foundation
import Fuzi
class Domain {
    
    var sitePages = [String]()
    var domain: String
    init(domain: String) {
        self.domain = domain
    }
    
    func connectToDomain(page: String?) -> String? {
        if page != nil {
            if let site = NSURL(string:"http://"+self.domain+"/"+page!) {
                print("Querying: \(site)")
                do { let html = try String(contentsOfURL: site, encoding: NSUTF8StringEncoding)
                    return html
                } catch _{
                    print("Could not query \(site)") }
            }
        } else {
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
        return("Something Bad happened")
    }
    
    func grabSitePages(html: String) {
        let result = self.searchForString(html, searchString: "href")
        for page in result {
            print(page)
            print("\n\n")
        }
    }
    
    func searchForString(pulledHtml: String, searchString: String) -> [String?] {
        var allPagesHTML = [String?]()
        do {
            let doc = try HTMLDocument(string: pulledHtml, encoding: NSUTF8StringEncoding)
            for link in doc.css("a, link") {
                if link["href"]!.containsString(".css") {
                    print("Skipping page \(link["href"])")
                } else {
                    print(link["href"])
                    allPagesHTML.append(connectToDomain(link["href"]))
                }
            }
        } catch let error {
            print(error)
        }
        return allPagesHTML
    }
    
}