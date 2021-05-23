import Vapor
import Fluent

func routes(_ app: Application) throws {
    
    let businessController = BusinessController()
    let userController = UserController()
    try app.register(collection: businessController)
    try app.register(collection: userController)
    
    app.post("business") { req -> EventLoopFuture<Business> in
        let business = try req.content.decode(Business.self)
        return business.create(on: req.db).map { business }
    }
    
    app.post("user") { req -> EventLoopFuture<User> in
        let user = try req.content.decode(User.self)
        return user.create(on: req.db).map { user }
    }
    
    app.get("business") { req in
        Business.query(on: req.db).all()
    }
    
    app.get("user") { req in
        User.query(on: req.db).all()
    }
    
    app.get("business", ":businessID") { req -> EventLoopFuture<Business> in
        Business.find(req.parameters.get("businessID"), on: req.db)
            .unwrap(or: Abort(.notFound))
    }
    
    app.get("user", ":userID") { req -> EventLoopFuture<User> in
        User.find(req.parameters.get("userID"), on: req.db)
            .unwrap(or: Abort(.notFound))
    }
    
    app.put("business", ":businessID") { req -> EventLoopFuture<Business> in
        let updateBusiness = try req.content.decode(Business.self)
        return Business.find(
            req.parameters.get("businessID"),
            on: req.db)
            .unwrap(or: Abort(.notFound)).flatMap { business in
                business.name = updateBusiness.name
                business.address = updateBusiness.address
                //                business.phone = updateBusiness.phone
                return business.save(on: req.db).map {
                    business
                }
            }
    }
    
    app.put("user", ":userID") { req -> EventLoopFuture<User> in
        let updateUser = try req.content.decode(User.self)
        return User.find(
            req.parameters.get("userID"),
            on: req.db)
            .unwrap(or: Abort(.notFound)).flatMap { user in
                user.name = updateUser.name
                user.username = updateUser.username
                user.email = updateUser.email
                return user.save(on: req.db).map {
                    user
                }
            }
    }
    
    app.delete("business", ":businessID") { req -> EventLoopFuture<HTTPStatus> in
        Business.find(req.parameters.get("businessID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { business in
                business.delete(on: req.db)
                    .transform(to: .noContent)
            }
    }
    
    app.delete("user", ":userID") { req -> EventLoopFuture<HTTPStatus> in
        User.find(req.parameters.get("userID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { user in
                user.delete(on: req.db)
                    .transform(to: .noContent)
            }
    }
    
    
    app.get("business", "search") { req -> EventLoopFuture<[Business]> in
        guard let searchTerm = req.query[String.self, at: "term"] else {
            throw Abort(.badRequest)
        }
        return Business.query(on: req.db)
            .filter(\.$name == searchTerm)
            .all()
    }
    
    app.get("user", "search") { req -> EventLoopFuture<[User]> in
        guard let searchTerm = req.query[String.self, at: "term"] else {
            throw Abort(.badRequest)
        }
        return User.query(on: req.db)
            .filter(\.$name == searchTerm)
            .filter(\.$username == searchTerm)
            .filter(\.$email == searchTerm)
            .all()
    }
    
    app.get("business", "search") { req -> EventLoopFuture<[Business]> in
        guard let searchTerm = req.query[String.self, at: "term"] else {
            throw Abort(.badRequest)
        }
        return Business.query(on: req.db)
            .filter(\.$address == searchTerm)
            .all()
    }
    
    app.get("business", "first") { req -> EventLoopFuture<Business> in
        Business.query(on: req.db)
            .first()
            .unwrap(or: Abort(.notFound))
    }
    
    app.get("user", "first") { req -> EventLoopFuture<User> in
        User.query(on: req.db)
            .first()
            .unwrap(or: Abort(.notFound))
    }
    
    app.get("business", "sorted" ) { req -> EventLoopFuture<[Business]> in
        Business.query(on: req.db)
            .sort(\.$name, .ascending)
            .all()
    }
    
    app.get("user", "sorted" ) { req -> EventLoopFuture<[User]> in
        User.query(on: req.db)
            .sort(\.$name, .ascending)
            .all()
    }
}



