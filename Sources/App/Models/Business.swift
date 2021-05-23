//
//  File.swift
//  
//
//  Created by Rob Maltese on 5/17/21.
//

import Foundation
import Vapor
import Fluent
import FluentPostgresDriver

final class Business: Model, Content {
    
    static let schema = "business"
    
    init() {}
    
    // What to store?
    @ID(key: .id)
    var id: UUID?
    @Field(key: "name")
    var name: String
    @Field(key: "address")
    var address: String
    @Field(key: "phone")
    var phone: String
    init(id: UUID? = nil, name: String, address: String, phone: String) {
        self.id = id
        self.name = name
        self.address = address
        self.phone = phone
    }
}
