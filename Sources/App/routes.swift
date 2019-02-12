import Vapor
import Authentication

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    
    // Use user model to create an authentication middleware
    let session = User.authSessionsMiddleware()
    let login = RedirectMiddleware(A: User.self, path: "/login")

    // create a route group wrapped by this middleware
    let auth = router.grouped(session)
    let loginAuth = auth.grouped(login)
    
    var errorMessage = ""
    var successMessage = ""

    // redirect root to dashboard if user is logged in
    loginAuth.get("") { req -> Response in
        return req.redirect(to: "dashboard")
    }
    
    // process login request
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
                    successMessage = "Bem-vindo, \(user.name)."
                    return req.redirect(to: "dashboard")
                } else {
                    errorMessage = "Erro de autenticação."
                    return req.redirect(to: "login")
                }
            }
        }
    }
    
    
    router.get("login") { req -> Future<View> in
        let response = LoginGetResponse(errorMessage: errorMessage, successMessage: successMessage)
        errorMessage = ""
        successMessage = ""
        return try req.view().render("login", response)
    }
    
    router.get("users", "new") { req -> Future<View> in
        let response = LoginGetResponse(errorMessage: errorMessage, successMessage: successMessage)
        errorMessage = ""
        successMessage = ""
        return try req.view().render("signup", response)
    }
    
    let vehicleController = VehicleController()
    loginAuth.get("vehicles", use: vehicleController.index)
    loginAuth.post("vehicles", use: vehicleController.create)
    loginAuth.delete("vehicles", Vehicle.parameter, use: vehicleController.delete)
    
    let stationController = StationController()
    loginAuth.post("stations", use: stationController.create)
    
    loginAuth.get("stations", "new") { req -> Future<View> in
        return try req.view().render("stations-new")
    }

    // Dashboard
    loginAuth.get("dashboard") { req -> Response in
        return req.redirect(to: "dashboard/fleet")
    }
    
    loginAuth.get("dashboard", "fleet") { req -> Future<View> in
        return try vehicleController.list(req).flatMap { vehicles in
            let response = DashboardVehicleResponse(vehicles: vehicles, errorMessage: errorMessage, successMessage: successMessage)
            errorMessage = ""
            successMessage = ""
            return try req.view().render("dashboard-fleet", response)
        }
    }
    
    loginAuth.get("dashboard", "stations") { req -> Future<View> in
        return try stationController.list(req).flatMap { stations in
            let response = DashboardStationResponse(stations: stations, errorMessage: errorMessage, successMessage: successMessage)
            errorMessage = ""
            successMessage = ""
            return try req.view().render("dashboard-stations", response)
        }
    }
    
    let vehicleModelController = VehicleModelController()
    loginAuth.get("vehicles/models", use: vehicleModelController.index)
    loginAuth.post("vehicles/models", use: vehicleModelController.create)
    loginAuth.delete("vehicles/models", Vehicle.parameter, use: vehicleModelController.delete)
    
    loginAuth.get("vehicles", "new", use: vehicleModelController.list)
    
    loginAuth.get("simulation") { req in
        return try req.view().render("simulation")
    }
    
    loginAuth.get("operation") { req in
        return "Operação"
    }
    
    router.get("logout") { req -> Response in
        try req.destroySession()
        return req.redirect(to: "login")
    }
}
