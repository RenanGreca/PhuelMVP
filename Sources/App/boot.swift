import Vapor
import FluentSQLite

var globalApp: Application! = nil

func fillDBfromJSON<T: SQLiteModel>(type: T.Type, jsonPath: String) {
    let directory = DirectoryConfig.detect()
    let jsonDir = "Resources/JSONs"
    
    if  let data = try? Data(contentsOf: URL(fileURLWithPath: directory.workDir)
        .appendingPathComponent(jsonDir, isDirectory: true)
        .appendingPathComponent(jsonPath, isDirectory: false)) {
        
        let decoder = JSONDecoder()
        
        let decoded = try! decoder.decode([T].self, from: data)
        
        for vehicleModel in decoded {
            let conn = try! globalApp.newConnection(to: .sqlite).wait()
            
            let _ = try? vehicleModel.create(on: conn).wait()
            
            defer { conn.close() }
        }
        
    }
}

/// Called after your application has initialized.
public func boot(_ app: Application) throws {
    globalApp = app
    
    
    let directory = DirectoryConfig.detect()
    let jsonDir = "Resources/JSONs"
    
    // Add basic vehicle models
    fillDBfromJSON(type: VehicleModel.self, jsonPath: "VehicleModels.json")
    
    
    // Add basic station models
    fillDBfromJSON(type: StationModel.self, jsonPath: "StationModels.json")
    
    let conn = try app.newConnection(to: .sqlite).wait()
    
    let stationModels = try! conn.select().all().from(StationModel.self).all(decoding: StationModel.self).wait()
    let stationModel = stationModels.filter({$0.make == "Efacec" && $0.model == "QC40"}).first!
    
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
    
    let sp = Region(name: "São Paulo", code: "SP", superRegion: brasil, manager: pedro)
    let _ = try sp.create(on: conn).wait()
    pedro.region = sp.name
    let _ = try pedro.update(on: conn).wait()

    let saopaulo = Region(name: "São Paulo", code: "GRU", superRegion: sp, manager: paulo)
    let _ = try saopaulo.create(on: conn).wait()
    paulo.region = "\(saopaulo.name), \(saopaulo.superRegion!.code)"
    let _ = try paulo.update(on: conn).wait()
    
    let barueri = Region(name: "Barueri", code: "BAR", superRegion: sp, manager: felipe)
    let _ = try barueri.create(on: conn).wait()
    felipe.region = "\(barueri.name), \(barueri.superRegion!.code)"
    let _ = try felipe.update(on: conn).wait()
    
    // Create pre-baked consumer units
    let ucMooca = ConsumerUnit(name: "CDD Mooca", region: saopaulo, manager: thiago, batteryCapacity: 0, energyPeak: 320, generationPeak: 12, demand: 600)
    let _ = try ucMooca.create(on: conn).wait()
    thiago.consumerUnit = ucMooca.name
    let _ = try thiago.update(on: conn).wait()
    
    let ucBarueri = ConsumerUnit(name: "CDD Barueri", region: barueri, manager: amanda, batteryCapacity: 0, energyPeak: 150, generationPeak: 5, demand: 300)
    let _ = try ucBarueri.create(on: conn).wait()
    amanda.consumerUnit = ucBarueri.name
    let _ = try amanda.update(on: conn).wait()
    
    // Create some initial vehicles
    var models = try! conn.select().all().from(VehicleModel.self).all(decoding: VehicleModel.self).wait()
    var model = models.filter({$0.make == "Volkswagen" && $0.model == "e-Delivery 6x2"}).first!
    
    var car = Vehicle(licensePlate: "AAA-0000", modelId: model.id!, make: model.make, model: model.model, battery: model.battery[0], consumerUnit: ucMooca)
    let _ = try car.create(on: conn).wait()
    
    models = try! conn.select().all().from(VehicleModel.self).all(decoding: VehicleModel.self).wait()
    model = models.filter({$0.make == "Tesla" && $0.model == "Model S"}).first!
    
    car = Vehicle(licensePlate: "AAA-0001", modelId: model.id!, make: model.make, model: model.model, battery: model.battery[0], consumerUnit: ucMooca)
    let _ = try car.create(on: conn).wait()
    
    models = try! conn.select().all().from(VehicleModel.self).all(decoding: VehicleModel.self).wait()
    model = models.filter({$0.make == "Motiva" && $0.model == "Tres MT15 Ambev"}).first!
    
    car = Vehicle(licensePlate: "AAA-0002", modelId: model.id!, make: model.make, model: model.model, battery: model.battery[0], consumerUnit: ucMooca)
    let _ = try car.create(on: conn).wait()
    
    models = try! conn.select().all().from(VehicleModel.self).all(decoding: VehicleModel.self).wait()
    model = models.filter({$0.make == "Motiva" && $0.model == "URBI Ambev"}).first!
    
    car = Vehicle(licensePlate: "AAA-0003", modelId: model.id!, make: model.make, model: model.model, battery: model.battery[0], consumerUnit: ucMooca)
    let _ = try car.create(on: conn).wait()
    
    
    
    
    // Create some initial stations
    let station = Station(model: "\(stationModel.make) \(stationModel.model)", current: "DC", power: stationModel.power, specifications: stationModel.extras, consumerUnit: ucMooca)
    let _ = try station.create(on: conn).wait()
    
    defer { conn.close() }
}

func addData<T>(ofType: T.Type, fromJSON: String) {
    
}
