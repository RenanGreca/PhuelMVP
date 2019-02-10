import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    
    // Example of configuring a controller
    let vehicleController = VehicleController()
    router.get("vehicles", use: vehicleController.index)
    router.post("vehicles", use: vehicleController.create)
    router.delete("vehicles", Vehicle.parameter, use: vehicleController.delete)

    // Dashboard
    router.get("", use: vehicleController.list)
    
    let vehicleModelController = VehicleModelController()
    router.get("vehicles/models", use: vehicleModelController.index)
    router.post("vehicles/models", use: vehicleModelController.create)
    router.delete("vehicles/models", Vehicle.parameter, use: vehicleModelController.delete)
    
    router.get("vehicles", "new", use: vehicleModelController.list)
//    router.get("vehicles", "new", Int.parameter, use: vehicleModelController.list)
    
    router.get("simulacao") { req in
        return try req.view().render("simulation", [
            "name": "there"//req.parameters.next(String.self)
        ])
    }
    
    router.get("operacao") { req in
        return "Operação"
    }
}
