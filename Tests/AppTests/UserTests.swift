//
//  File.swift
//  
//
//  Created by Rob Maltese on 5/23/21.
//

import Foundation


@testable import App
import XCTVapor

final class UserTests: XCTestCase {
    func testUsersCanBeRetrievedFromAPI() throws {
        let expectedName = "Alice"
        let expectedUsername = "alice"
        let expectedEmail = "alice@test.email"
        
        let app = Application(.testing)
        defer {
            app.shutdown()
        }
        try configure(app)
        
        let user = User(
            name: expectedName,
            username: expectedUsername,
            email: expectedEmail)
        
        try user.save(on: app.db)
            .wait()
        try User(
            name: "Luke",
            username: "lukeuser",
            email: "luke@test.email")
            .save(on: app.db)
            .wait()
        
        try app.test(.GET, "/user", afterResponse: { response in
            XCTAssertEqual(response.status, .ok)
            let user = try response.content.decode([User].self)
            XCTAssertEqual(user.count, 2)
            XCTAssertEqual(user[0].name, expectedName)
            XCTAssertEqual(user[0].username, expectedUsername)
            XCTAssertEqual(user[0].email, expectedEmail)            
        })
    }
}
