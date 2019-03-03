// MIT license. Copyright (c) 2018 Ashish Bhandari. All rights reserved.


import Foundation

struct UserEntity: Codable {
    
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
    var latitude: String?
    var longitude: String?
    
    enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lng"
    }
}

struct Company: Codable {
    var name: String?
    var catchPhrase: String?
    var bs: String?
}
