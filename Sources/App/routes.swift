import Vapor
import Authentication

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    
    // Use user model to create an authentication middleware
    let session = User.authSessionsMiddleware()
//    let password = User.basicAuthMiddleware(using: BCryptDigest())

    // create a route group wrapped by this middleware
    let auth = router.grouped(session)

    // create new route in this route group
    auth.get("") { req -> Response in
        if let _ = try? req.requireAuthenticated(User.self) {
            return req.redirect(to: "dashboard")
        } else {
            return req.redirect(to: "login")
        }
        
    }
    
    auth.post("login") { req -> Future<Response> in
        return try req.content.decode(LoginRequest.self).flatMap { loginRequest in
            
            return User.query(on: req).all().map { users in
                if let user = try users
                    .filter( {
                        // Find the user with the right email address and validate the password.
                        try $0.email == loginRequest.email &&
                            BCrypt.verify(loginRequest.password, created: users.first!.passwordHash)
                    }).first {
                    // If the information is valid, authenticate the user and redirect to the dashboard.
                    try req.authenticate(user)
                    return req.redirect(to: "dashboard")
                } else {
                    return req.redirect(to: "login")
                }
            }
        }
    }
    
    
    // Create a route closure wrapped by this middleware
    auth.get("hello") { req -> String in
        let user = try req.requireAuthenticated(User.self)
        return "Hello, \(user.name)."
    }
    
    router.get("login") { req in
        return try req.view().render("login")
    }

    
    // Example of configuring a controller
    let vehicleController = VehicleController()
    router.get("vehicles", use: vehicleController.index)
    router.post("vehicles", use: vehicleController.create)
    router.delete("vehicles", Vehicle.parameter, use: vehicleController.delete)

    // Dashboard
    router.get("dashboard", use: vehicleController.list)
    
    let vehicleModelController = VehicleModelController()
    router.get("vehicles/models", use: vehicleModelController.index)
    router.post("vehicles/models", use: vehicleModelController.create)
    router.delete("vehicles/models", Vehicle.parameter, use: vehicleModelController.delete)
    
    router.get("vehicles", "new", use: vehicleModelController.list)
    
    router.get("simulacao") { req in
        return try req.view().render("simulation")
    }
    
    router.get("operacao") { req in
        return "Operação"
    }
}
