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
        //check if a page was supplied. If it was then we know the domain should be good to go
        if page != nil {
            if let site = NSURL(string:"http://"+self.domain+"/"+page!) {
                print("Querying: \(site)")
                do { let html = try String(contentsOfURL: site, encoding: NSUTF8StringEncoding)
                    return html
                } catch _{
                    print("Could not query \(site)") }
            }
        } else {
                //no page was supplied, must be a new instantiation of the domain
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
        //Might rename this as this is were the magic starts to happen
        let result = self.searchForString(html, searchString: "href")
        //Result for grabbing all the pages and then printing out the array that contains all the html
        for page in result {
            print(page)
            print("\n\n")
        }
    }
    
    func searchForString(pulledHtml: String, searchString: String) -> [String?] {
        //Thanks fuzi you made me not have to write an html parser...though i might later since swift makes it a pain
        //to import the framework, and it breaks the program if the config is incorrect.
        //I will need to add a way to recursively call this function on all child pages without ending up in an endless loop.
        var allPagesHTML = [String?]()
        do {
            let doc = try HTMLDocument(string: pulledHtml, encoding: NSUTF8StringEncoding)
            //we are checking for all links to child pages off the main site, the current issue with this is that it
            //does not account for links that might be duplicates.
            for link in doc.css("a, link") {
                //we dont want .css docs as of right now. Might make a command line option that allows you to get these
                if link["href"]!.containsString(".css") { //i dont like force unwrapping but swift is being a pain.
                    print("Skipping page \(link["href"])")
                } else {
                    print(link["href"])
                    //lets throw all our page's html in an array for later
                    allPagesHTML.append(connectToDomain(link["href"]))
                }
            }
        } catch let error {
            print(error)
        }
        return allPagesHTML
    }
    
}