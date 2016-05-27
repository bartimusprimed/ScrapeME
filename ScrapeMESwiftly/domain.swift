//
//  domain.swift
//  ScrapeMESwiftly
//
//  Created by Samuel Barthelemy on 5/25/16.
//  Copyright © 2016 Samuel Barthelemy. All rights reserved.
//

import Foundation

class Domain {
    var domain: String
    var html: String
    var noNewLineElements: [String]
    var subPages: [String]
    init(domain: String) {
        self.domain = domain
        self.html = ""
        self.noNewLineElements = [String]()
        self.subPages = [String]()
    }
    
    func connectToDomain(page: String?) -> String {
        var site: NSURL!
        var status = "Running...."
        if let page = page {
            if page.containsString("http") {
                site = NSURL(string:page)
            } else if !page.containsString("http") && page.containsString("/") {
                site = NSURL(string:self.domain+page)
            } else {
                site = NSURL(string:self.domain+"/"+page)
            }
        } else {
            site = NSURL(string:self.domain)
        }
        status = "Querying: \(site)"
        if site != nil {
            do {
                html = try String(contentsOfURL: site, encoding: NSUTF8StringEncoding)
            } catch _{
                status = "Could not query \(site) have you tried https?"
            }
        } else {
            status = "Invalid Website"
        }
        return status
    }
    
    func linkParser(html: String) {
        var elementStarted = false
        var elements = [String]()
        var elementString = ""
        
        for char in html.characters {
            
            if char == "<" && elementStarted == true {
                elementStarted = false
                elements.append(elementString)
                elementString = ""
            }
            
            elementString += String(char)
            
            if char == "<" && elementStarted == false {
                elementStarted = true
            }
            
        }
        
        for element in elements {
            let noWhiteSpace = element.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
             noNewLineElements.append(noWhiteSpace.stringByReplacingOccurrencesOfString("\n", withString: "", options: NSStringCompareOptions.LiteralSearch, range:nil))
        }
    }
    
    func grabLinks() -> String {
        var grabbedElements = ""
        var linkArray = [String]()
        for element in Array(Set(noNewLineElements)) {
            if element.containsString("href") {
                if let found = element.rangeOfString("(?<=\")[^\"]+", options: .RegularExpressionSearch) {
                    if element.substringWithRange(found).containsString("/") || element.substringWithRange(found).containsString(".html"){
                        subPages.append(element.substringWithRange(found))
                    }
                    linkArray.append((element.substringWithRange(found)))
                }
            }
        }
    subPages = Array(Set(subPages))
    linkArray = Array(Set(linkArray))
        for link in linkArray {
            grabbedElements += (link+"\n")
        }
        return grabbedElements
    }
    
    func grabEmail() -> [String] {
        var grabbedElements = [String]()
        for element in Array(Set(noNewLineElements)) {
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
            if let found = element.rangeOfString(emailRegEx, options:.RegularExpressionSearch) {
                grabbedElements.append(element.substringWithRange(found))
            }
        }
        return grabbedElements
    }
    
    func spiderPages() -> String {
        
        var emailAddresses = ""
        var emails = [String]()
        for page in subPages {
            _ = connectToDomain(page)
            linkParser(html)
            emails = grabEmail()
        }
        emails = Array(Set(emails))
        for email in emails {
            emailAddresses += email+"\n"
        }
        return emailAddresses
    }
    
    
    func delay(delay: Double, closure: ()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(),
            closure
        )
    }
    
}
