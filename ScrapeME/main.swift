//
//  main.swift
//  ScrapeME
//
//  Created by Samuel Barthelemy on 5/23/16.
//  Copyright © 2016 Samuel Barthelemy. All rights reserved.
//
import Foundation

let website = Domain(domain: Process.arguments[1])
print(website.domain)
website.connectToDomain(nil)
