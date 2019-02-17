import Vapor
import Authentication

var currentConsumerUnit:ConsumerUnit?
var currentRegion:Region?

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
    
    let consumerUnitController = ConsumerUnitController()
    let regionController = RegionController()
    
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
                    
                    let _ = try consumerUnitController.item(managedBy: user, req).do { consumerUnit in
                        if let consumerUnit = consumerUnit, let id = consumerUnit.id {
                            currentConsumerUnit = consumerUnit
                            try? req.session()["consumerUnit"] = String(id)
                        }
                    }
                    
                    let _ = try regionController.item(managedBy: user, req).do { region in
                        if let region = region, let id = region.id {
                            currentRegion = region
                            try? req.session()["region"] = String(id)
                        }
                    }
                    
                    successMessage = "Bem-vindo, \(user.name)."
                    return req.redirect(to: "dashboard")
                    
                } else {
                    errorMessage = "Erro de autenticação."
                    return req.redirect(to: "login")
                }
            }
        }
    }
    
    let userController = UserController()
    router.get("login") { req -> Future<View> in
        return try userController.list(req).flatMap { users in
            let response = LoginGetResponse(users: users, errorMessage: errorMessage, successMessage: successMessage)
            errorMessage = ""
            successMessage = ""
            return try req.view().render("login", response)
        }
    }

    loginAuth.post("users", use: userController.create)
    loginAuth.get("users", "new") { req -> Future<View> in
        return try req.view().render("users-new")
//        return try userController.list(req).flatMap { vehicles in
//            let response = LoginGetResponse(errorMessage: errorMessage, successMessage: successMessage)
//            errorMessage = ""
//            successMessage = ""
//            return try req.view().render("signup", response)
//        }
    }
    
    let vehicleModelController = VehicleModelController()
    loginAuth.get("vehicles/models", use: vehicleModelController.index)
    loginAuth.post("vehicles/models", use: vehicleModelController.create)
    loginAuth.delete("vehicles/models", VehicleModel.parameter, use: vehicleModelController.delete)
    
    let vehicleController = VehicleController()
    loginAuth.get("vehicles", use: vehicleController.index)
    loginAuth.post("vehicles", use: vehicleController.create)
    loginAuth.delete("vehicles", Vehicle.parameter, use: vehicleController.delete)
    loginAuth.get("vehicles", "new", use: vehicleModelController.list)
    
    let stationModelController = StationModelController()
    loginAuth.get("stations/models", use: stationModelController.index)
    loginAuth.post("stations/models", use: stationModelController.create)
    loginAuth.delete("stations/models", StationModel.parameter, use: stationModelController.delete)
    
    let stationController = StationController()
    loginAuth.get("stations", use: stationController.index)
    loginAuth.post("stations", use: stationController.create)
    loginAuth.get("stations", "new", use: stationModelController.list)
    
    loginAuth.get("consumerUnits", use: consumerUnitController.index)
    loginAuth.post("consumerUnits", use: consumerUnitController.create)
    loginAuth.get("consumerUnits", "new") { req -> Future<View> in
        return try regionController.allSubRegions(of: currentRegion!, req).flatMap() { regions in
            return try userController.notManagers(req).flatMap() { users in
                let response = NewConsumerUnitGetResponse(regions: regions, users: users)
                return try req.view().render("consumerunits-new", response)
            }
        }
        
    }

    // Dashboard
    loginAuth.get("dashboard") { req -> Response in
        if let _ = currentConsumerUnit {
            return req.redirect(to: "dashboard/fleet")
        }
        if let _ = currentRegion {
            return req.redirect(to: "dashboard/region")
        }
        return req.redirect(to: "login")
    }
    
    loginAuth.get("dashboard", "fleet") { req -> Future<View> in
        return try vehicleController.vehicles(of: currentConsumerUnit!, req).flatMap() { vehicles in
            let response = DashboardVehicleResponse(consumerUnit: currentConsumerUnit, vehicles: vehicles, errorMessage: errorMessage, successMessage: successMessage)
            errorMessage = ""
            successMessage = ""
            return try req.view().render("dashboard-fleet", response)
        }
    }
    
    loginAuth.get("dashboard", "stations") { req -> Future<View> in
        return try stationController.stations(of: currentConsumerUnit!, req).flatMap() { stations in
            let response = DashboardStationResponse(consumerUnit: currentConsumerUnit, stations: stations, errorMessage: errorMessage, successMessage: successMessage)
            errorMessage = ""
            successMessage = ""
            return try req.view().render("dashboard-stations", response)
        }
    }
    
    loginAuth.get("dashboard", "region") { req -> Future<View> in
        
        return try consumerUnitController.consumerUnits(of: currentRegion!, req).flatMap() { consumerUnits in
            
            let response = DashboardRegionResponse(region: currentRegion!, consumerUnits: consumerUnits, errorMessage: errorMessage, successMessage: successMessage)
            errorMessage = ""
            successMessage = ""
            return try req.view().render("dashboard-region", response)
            
        }
        
        
    }
    
    // Dashboard
    loginAuth.get("simulation") { req -> Future<View> in
        return try vehicleController.vehicles(of: currentConsumerUnit!, req).flatMap() { vehicles in
            let response = SimulationConsumerUnitGetResponse(consumerUnit: currentConsumerUnit, vehicleCount: vehicles.count)
            
            return try req.view().render("simulation", response)
        }
    }
    
    loginAuth.get("operation") { req in
        return "Operação"
    }
    
    router.get("logout") { req -> Response in
        currentConsumerUnit = nil
        currentRegion = nil
        try req.destroySession()
        return req.redirect(to: "login")
    }
}
