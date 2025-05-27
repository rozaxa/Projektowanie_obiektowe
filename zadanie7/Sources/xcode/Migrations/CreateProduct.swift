import Fluent

struct CreateProduct: Migration {
    func prepare(on database: any Database) -> EventLoopFuture<Void> {
        database.schema("products")
            .id()
            .field("name", .string, .required)
            .field("price", .double, .required)
            .create()
    }

    func revert(on database: any Database) -> EventLoopFuture<Void>
    {
        database.schema("products").delete()
    }
}
