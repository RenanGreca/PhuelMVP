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
    
    // Create some initial vehicles
    let tesla1 = Vehicle(licensePlate: "AAA-0000", modelId: model.id!, make: model.make, model: model.model, battery: model.battery[0])
    let _ = try tesla1.create(on: conn).wait()
    
    let tesla2 = Vehicle(licensePlate: "AAA-0001", modelId: model.id!, make: model.make, model: model.model, battery: model.battery[1])
    let _ = try tesla2.create(on: conn).wait()
    
    // Create some initial stations
    let station = Station(model: "QC20", current: "DC", power: 50, specifications: "500V")
    let _ = try station.create(on: conn).wait()
    
    // Create pre-baked users
    let renan = User(name: "Renan", email: "renan@phuel.com.br", password: "1234")
    let _ = try renan.create(on: conn).wait()
    
    let pedro = User(name: "Pedro", email: "pedro@phuel.com.br", password: "1234")
    let _ = try pedro.create(on: conn).wait()
    
    let paulo = User(name: "Paulo", email: "paulo@phuel.com.br", password: "1234")
    let _ = try paulo.create(on: conn).wait()
    
    let thiago = User(name: "Thiago", email: "thiago@phuel.com.br", password: "1234")
    let _ = try thiago.create(on: conn).wait()
    
    // Create pre-baked regions
    let brasil = Region(name: "Brasil", code: "BRA", manager: renan)
    let _ = try brasil.create(on: conn).wait()
    
    let parana = Region(name: "Paraná", code: "PR", superRegion: brasil, manager: pedro)
    let _ = try parana.create(on: conn).wait()
    
    let curitiba = Region(name: "Curitiba", code: "CWB", superRegion: parana, manager: paulo)
    let _ = try curitiba.create(on: conn).wait()
    
    // Create pre-baked consumer units
    let ucBatel = ConsumerUnit(name: "CDD Batel", vehicles: [tesla1], stations: [station], region: curitiba, manager: thiago, batteryCapacity: 300, energyPeak: 15)
    let _ = try ucBatel.create(on: conn).wait()
    
    defer { conn.close() }
}

func addData<T>(ofType: T.Type, fromJSON: String) {
    
}
