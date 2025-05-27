import Vapor
import Fluent

struct ProductController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let products = routes.grouped("products")

        products.get(use: indexHTML)
        products.post(use: createHTML)
        products.get(":productID", "edit", use: editForm)
        products.post(":productID", "edit", use: editHTML)
        products.post(":productID", "delete", use: deleteHTML)
    }

    // List all
    func indexHTML(req: Request) throws -> EventLoopFuture<View> {
        return Product.query(on: req.db).all().flatMap { products in
            let context = ["products": products]
            return req.view.render("products", context)
        }
    }

    // Create new
    func createHTML(req: Request) throws -> EventLoopFuture<Response> {
        struct Input: Content {
            let name: String
            let price: Double
        }

        let input = try req.content.decode(Input.self)
        let product = Product(name: input.name, price: input.price)
        return product.save(on: req.db).map {
            req.redirect(to: "/products")
        }
    }

    // Edit form
    func editForm(req: Request) throws -> EventLoopFuture<View> {
        guard let id = req.parameters.get("productID", as: UUID.self) else {
            throw Abort(.badRequest)
        }

        return Product.find(id, on: req.db).unwrap(or: Abort(.notFound)).flatMap { product in
            let context = ["product": product]
            return req.view.render("editProduct", context)
        }
    }

    // Submit edit
    func editHTML(req: Request) throws -> EventLoopFuture<Response> {
        struct Input: Content {
            let name: String
            let price: Double
        }

        let input = try req.content.decode(Input.self)
        guard let id = req.parameters.get("productID", as: UUID.self) else {
            throw Abort(.badRequest)
        }

        return Product.find(id, on: req.db).unwrap(or: Abort(.notFound)).flatMap { product in
            product.name = input.name
            product.price = input.price
            return product.save(on: req.db).map {
                req.redirect(to: "/products")
            }
        }
    }

    // Delete
    func deleteHTML(req: Request) throws -> EventLoopFuture<Response> {
        guard let id = req.parameters.get("productID", as: UUID.self) else {
            throw Abort(.badRequest)
        }

        return Product.find(id, on: req.db).unwrap(or: Abort(.notFound)).flatMap { product in
            return product.delete(on: req.db).map {
                req.redirect(to: "/products")
            }
        }
    }
}
