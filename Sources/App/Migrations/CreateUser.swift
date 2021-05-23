//
//  File.swift
//  
//
//  Created by Rob Maltese on 5/22/21.
//

import Foundation
import Fluent
import FluentPostgresDriver

struct CreateUser: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("user") // Name of Table
            .id()
            .field("name", .string)
            .field("username", .string)
            .field("email", .string)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("user")
            .delete()
    }
}
