import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {

    // Main page is the dashboard
    router.get { req in
        return try req.view().render("dashboard")
    }
    
    router.get("graphs") { req in
        return try req.view().render("graphs", [
            "name": "there"//req.parameters.next(String.self)
        ])
    }
    
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

    // Example of configuring a controller
    let todoController = TodoController()
    router.get("todos", use: todoController.index)
    router.post("todos", use: todoController.create)
    router.delete("todos", Todo.parameter, use: todoController.delete)
    
    let vehicleController = VehicleController()
    router.get("vehicles", use: vehicleController.index)
    router.post("vehicles", use: vehicleController.create)
    router.delete("vehicles", Todo.parameter, use: vehicleController.delete)
}
