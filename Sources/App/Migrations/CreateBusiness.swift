//
//  File.swift
//  
//
//  Created by Rob Maltese on 5/17/21.
//

import Foundation
import Fluent
import FluentPostgresDriver

struct CreateBusiness: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("business") // Name of the Table
            .id()
            .field("name", .string)
            .field("address", .string)
            .field("phone", .string)
            .create()
    }
    
    // Undo what we did above.
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("business")
            .delete()
    }
}


