import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    
    // Example of configuring a controller
    let vehicleController = VehicleController()
    router.get("vehicles", use: vehicleController.index)
    router.post("vehicles", use: vehicleController.create)
    router.delete("vehicles", Todo.parameter, use: vehicleController.delete)

    // Dashboard
    router.get("", use: vehicleController.list)

    
    router.get("cadastros") { req in
        return "Cadastros"
    }
    
    router.get("simulacao") { req in
        return try req.view().render("simulation", [
            "name": "there"//req.parameters.next(String.self)
        ])
    }
    
    router.get("operacao") { req in
        return "Operação"
    }
}
