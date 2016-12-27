import Vapor

let drop = Droplet()

drop.get("hello") { request in
    return try JSON(node: [
        "version": "1.0"
        ])
}

drop.get("books") {  request in

	let books: [Node] = [
		["id": 1, "title": "Foo", "author": "Mr. Foo", "isbn": "1234"],
		["id": 2, "title": "Bar", "author": "Mr. Bar", "isbn": "4321"],
	]

	// let books: [ [String:Any] ] = [

	// ]

	return try JSON(node: books)
}

drop.run()
