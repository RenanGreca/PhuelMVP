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
    
    // Create pre-baked users
    let renan = User(name: "Renan", email: "renan@phuel.com.br", password: "1234")
    let _ = try renan.create(on: conn).wait()
    
    let pedro = User(name: "Pedro", email: "pedro@phuel.com.br", password: "1234")
    let _ = try pedro.create(on: conn).wait()
    
    let paulo = User(name: "Paulo", email: "paulo@phuel.com.br", password: "1234")
    let _ = try paulo.create(on: conn).wait()
    
    let thiago = User(name: "Thiago", email: "thiago@phuel.com.br", password: "1234")
    let _ = try thiago.create(on: conn).wait()
    
    let felipe = User(name: "Felipe", email: "felipe@phuel.com.br", password: "1234")
    let _ = try felipe.create(on: conn).wait()
    
    let amanda = User(name: "Amanda", email: "amanda@phuel.com.br", password: "1234")
    let _ = try amanda.create(on: conn).wait()
    
    let ricardo = User(name: "Ricardo", email: "amanda@phuel.com.br", password: "1234")
    let _ = try ricardo.create(on: conn).wait()
    
    // Create pre-baked regions
    let brasil = Region(name: "Brasil", code: "BRA", manager: renan)
    let _ = try brasil.create(on: conn).wait()
    renan.region = brasil.name
    let _ = try renan.update(on: conn).wait()
    
    let parana = Region(name: "Paraná", code: "PR", superRegion: brasil, manager: pedro)
    let _ = try parana.create(on: conn).wait()
    pedro.region = parana.name
    let _ = try pedro.update(on: conn).wait()

    let curitiba = Region(name: "Curitiba", code: "CWB", superRegion: parana, manager: paulo)
    let _ = try curitiba.create(on: conn).wait()
    paulo.region = curitiba.name
    let _ = try paulo.update(on: conn).wait()
    
    let londrina = Region(name: "Londrina", code: "LDR", superRegion: parana, manager: felipe)
    let _ = try londrina.create(on: conn).wait()
    felipe.region = londrina.name
    let _ = try felipe.update(on: conn).wait()
    
    // Create pre-baked consumer units
    let ucBatel = ConsumerUnit(name: "CDD Batel", region: curitiba, manager: thiago, batteryCapacity: 300, energyPeak: 15, generationPeak: 35)
    let _ = try ucBatel.create(on: conn).wait()
    thiago.consumerUnit = ucBatel.name
    let _ = try thiago.update(on: conn).wait()
    
    let ucLondrina = ConsumerUnit(name: "CDD Londrina", region: londrina, manager: amanda, batteryCapacity: 300, energyPeak: 15, generationPeak: 35)
    let _ = try ucLondrina.create(on: conn).wait()
    amanda.consumerUnit = ucLondrina.name
    let _ = try amanda.update(on: conn).wait()
    
    // Create some initial vehicles
    let tesla1 = Vehicle(licensePlate: "AAA-0000", modelId: model.id!, make: model.make, model: model.model, battery: model.battery[0], consumerUnit: ucBatel)
    let _ = try tesla1.create(on: conn).wait()
    
    let tesla2 = Vehicle(licensePlate: "AAA-0001", modelId: model.id!, make: model.make, model: model.model, battery: model.battery[1], consumerUnit: ucBatel)
    let _ = try tesla2.create(on: conn).wait()
    
    // Create some initial stations
    let station = Station(model: "QC20", current: "DC", power: 50, specifications: "500V", consumerUnit: ucBatel)
    let _ = try station.create(on: conn).wait()
    
    defer { conn.close() }
}

func addData<T>(ofType: T.Type, fromJSON: String) {
    
}
