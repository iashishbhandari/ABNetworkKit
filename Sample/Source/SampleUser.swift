//
//  SampleUser.swift
//  Sample
//
//  Created by Ashish Bhandari on 08/10/18.
//  Copyright © 2018 iashishbhandari. All rights reserved.
//

import Foundation

struct SampleUser: Codable {
    
    var id: Int?
    var name: String?
    var username: String?
    var email: String?
    var address: Address?
    var phone: String?
    var website: String?
    var company: Company?
}

struct Address: Codable {
    var street: String?
    var suite: String?
    var city: String?
    var zipcode: String?
    var geo: Geo?
}

struct Geo: Codable {
    var lat: String?
    var lng: String?
}

struct Company: Codable {
    var name: String?
    var catchPhrase: String?
    var bs: String?
}
