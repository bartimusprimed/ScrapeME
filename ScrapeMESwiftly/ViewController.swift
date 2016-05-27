//
//  ViewController.swift
//  ScrapeMESwiftly
//
//  Created by Samuel Barthelemy on 5/25/16.
//  Copyright © 2016 Samuel Barthelemy. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet weak var website: NSTextField!
    @IBOutlet var sitePagesResults: NSTextView!
    @IBOutlet var emailAddressesResults: NSTextView!
    @IBOutlet weak var statusLabel: NSTextField!

    
    @IBAction func scrape(sender: NSButton) {
        let scrapedWebsite = Domain(domain: website.stringValue)
        statusLabel.stringValue = "Spidering and grabbing emails for \(website.stringValue)"
        scrapedWebsite.delay(0.5) {
            self.statusLabel.stringValue = scrapedWebsite.connectToDomain(nil)
            scrapedWebsite.linkParser(scrapedWebsite.html)
            self.sitePagesResults.string = scrapedWebsite.grabLinks()
            self.emailAddressesResults.string = scrapedWebsite.spiderPages()
        }

    }

}