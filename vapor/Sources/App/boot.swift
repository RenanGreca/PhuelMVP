import Vapor

/// Called after your application has initialized.
public func boot(_ app: Application) throws {
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
    
    let prius = Vehicle(licensePlate: "AAA-0000", make: "Toyota", model: "Prius", charge: 50)
    let _ = try prius.create(on: conn).wait()
    
    defer { conn.close() }
}

func addData<T>(ofType: T.Type, fromJSON: String) {
    
}
