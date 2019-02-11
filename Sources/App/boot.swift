import Vapor

var globalApp: Application! = nil

/// Called after your application has initialized.
public func boot(_ app: Application) throws {
    globalApp = app
    
    
    let directory = DirectoryConfig.detect()
    let jsonDir = "Resources/JSONs"
    
    // Add basic vehicle models
    if  let data = try? Data(contentsOf: URL(fileURLWithPath: directory.workDir)
         .appendingPathComponent(jsonDir, isDirectory: true)
         .appendingPathComponent("VehicleModels.json", isDirectory: false)) {
        
        let decoder = JSONDecoder()

        let decoded = try decoder.decode([VehicleModel].self, from: data)
        
        for vehicleModel in decoded {
            let conn = try app.newConnection(to: .sqlite).wait()
            
            let _ = try vehicleModel.create(on: conn).wait()
            
            defer { conn.close() }
        }
        
    }
    
    let conn = try app.newConnection(to: .sqlite).wait()
    
    let models = try! conn.select().all().from(VehicleModel.self).all(decoding: VehicleModel.self).wait()
    let model = models.filter({$0.make == "Tesla" && $0.model == "Model S"}).first!
        
    let prius = Vehicle(licensePlate: "AAA-0000", modelId: model.id!, make: model.make, model: model.model, battery: model.battery[0])
    let _ = try prius.create(on: conn).wait()
    
    let user = User(name: "Renan", email: "renan@phuel.com.br", password: "1234")
    let _ = try user.create(on: conn).wait()
    
    defer { conn.close() }
}

func addData<T>(ofType: T.Type, fromJSON: String) {
    
}
