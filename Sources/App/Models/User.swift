//
//  File.swift
//  
//
//  Created by Rob Maltese on 5/22/21.
//

import Foundation
import Vapor
import Fluent

final class User: Model, Content {
    
    static let schema = "user"
    
    init() {}
    
    @ID
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    @Field(key: "username")
    var username: String
    @Field(key: "email")
    var email: String
    
    init(id: UUID? = nil, name: String, username: String, email: String) {
        self.name = name
        self.username = username
        self.email = email
    }
}
