//
//  File.swift
//  
//
//  Created by Rob Maltese on 5/22/21.
//

import Foundation
import Vapor
import Fluent

struct UserController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        
        func createUser(_ req: Request) throws -> EventLoopFuture<User> {
            let user = try req.content.decode(User.self)
            return user.save(on: req.db)
                .map { user }
        }
        
        func getAllHandler(_ req: Request) -> EventLoopFuture<[User]> {
            User.query(on: req.db)
                .all()
        }
        
        func updateHandler(_ req: Request) throws -> EventLoopFuture<User> {
            let updateUser = try req.content.decode(User.self)
            return User.find(req.parameters.get("userID"), on: req.db)
                .unwrap(or: Abort(.notFound))
                .flatMap { user in
                    user.name = updateUser.name
                    user.username = updateUser.username
                    user.email = updateUser.email
                    return user.save(on: req.db)
                        .map { user }
                }
        }
        
        func deleteHandler(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
            User.find(req.parameters.get("userID"), on: req.db)
                .unwrap(or: Abort(.notFound))
                .flatMap { user in
                    user.delete(on: req.db)
                        .transform(to: .noContent)
                }
        }
        
        func searchHandler(_ req: Request) throws -> EventLoopFuture<[User]> {
            guard let searchUsername = req.query[String.self, at: "term"] else {
                throw Abort(.badRequest)
            }
            return User.query(on: req.db)
                .filter(\.$username == searchUsername)
                .all()
        }
        
        func firstHandler(_ req: Request) throws -> EventLoopFuture<User> {
            User.query(on: req.db)
                .first()
                .unwrap(or: Abort(.notFound))
        }
        
        func sortHandler(_ req: Request) throws -> EventLoopFuture<[User]> {
            User.query(on: req.db)
                .sort(\.$name, .ascending)
                .all()
        }
        
    }
}
