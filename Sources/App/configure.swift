import FluentSQLite
import Vapor
import Leaf
import Authentication

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    // Register providers first
    try services.register(FluentSQLiteProvider())

    // Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    // Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    middlewares.use(SessionsMiddleware.self)
    middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)

    // Configure a SQLite database
    let sqlite = try SQLiteDatabase(storage: .memory)

    // Register the configured SQLite database to the database config.
    var databases = DatabasesConfig()
    databases.add(database: sqlite, as: .sqlite)
    services.register(databases)
    config.prefer(MemoryKeyedCache.self, for: KeyedCache.self)

    // Configure migrations
    var migrations = MigrationConfig()
    migrations.add(model: Todo.self, database: .sqlite)
    migrations.add(model: Vehicle.self, database: .sqlite)
    migrations.add(model: VehicleModel.self, database: .sqlite)
    migrations.add(model: User.self, database: .sqlite)
    migrations.add(model: Station.self, database: .sqlite)
    migrations.add(model: StationModel.self, database: .sqlite)
    migrations.add(model: ConsumerUnit.self, database: .sqlite)
    migrations.add(model: Region.self, database: .sqlite)
    services.register(migrations)
    
    try services.register(LeafProvider())
    config.prefer(LeafRenderer.self, for: ViewRenderer.self)
    
    try services.register(AuthenticationProvider())

}
