//
//  File.swift
//  
//
//  Created by Rob Maltese on 5/22/21.
//

import Foundation
import Vapor
import Fluent

struct BusinessController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
       
        func createHandler(_ req: Request) throws -> EventLoopFuture<Business> {
            let business = try req.content.decode(Business.self)
            return business.save(on: req.db)
                .map { business }
        }
        
        func getAllHandler(_ req: Request) -> EventLoopFuture<[Business]> {
            Business.query(on: req.db)
                .all()
        }
        
        func updateHandler(_ req: Request) throws -> EventLoopFuture<Business> {
            let updateBusiness = try req.content.decode(Business.self)
            return Business.find(
                req.parameters.get("businessID"),
                on: req.db)
                .unwrap(or: Abort(.notFound)).flatMap { business in
                    business.name = updateBusiness.name
                    business.address = updateBusiness.address
                    business.phone = updateBusiness.phone
                    return business.save(on: req.db).map {
                        business
                    }
                }
        }
        
        func deleteHandler(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
            Business.find(req.parameters.get("businessID"), on: req.db)
                .unwrap(or: Abort(.notFound))
                .flatMap { business in
                    business.delete(on: req.db)
                        .transform(to: .noContent)
                }
        }
        
        func searchHandler(_ req: Request) throws -> EventLoopFuture<[Business]> {
            guard let searchName = req.query[String.self, at: "term"] else {
                throw Abort(.badRequest)
            }
            guard let searchAddress = req.query[String.self, at: "term"] else {
                throw Abort(.badRequest)
            }
            return Business.query(on: req.db)
                .filter(\.$name == searchName)
                .filter(\.$address == searchAddress)
                .all()
        }
        
        func firstHandler(_ req: Request) throws -> EventLoopFuture<Business> {
            Business.query(on: req.db)
                .first()
                .unwrap(or: Abort(.notFound))
        }
        
        func sortHandler(_ req: Request) throws -> EventLoopFuture<[Business]> {
            Business.query(on: req.db)
                .sort(\.$name, .ascending)
                .all()
        }
    }
}

