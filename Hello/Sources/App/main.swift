import Vapor
import HTTP

let drop = Droplet()

drop.get("hello") { request in
    return try JSON(node: [
        "version": "1.0"
        ])
}

drop.get("episodes") { request in
    let episodes: [Node] = [
        ["id": "id1", "title": "Episode 1"],
        ["id": "id2", "title": "Episode 2"],
    ]
    return try JSON(node: episodes)
}

drop.get("books") {  request in
	let books: [Node] = [
		["id": 1, "title": "Foo", "author": "Mr. Foo", "isbn": "1234"],
		["id": 2, "title": "Bar", "author": "Mr. Bar", "isbn": "4321"],
	]
	return try JSON(node: books)
}

drop.get("books", Int.self) { request, bookId in

    if bookId == 1 {

	return try JSON(node:["id": 1, "title": "Foo", "author": "Mr. Foo", "isbn": "1234"])
    }

    throw Abort.notFound
}

drop.post("books") { request in

	print("json = \(request.json)")

	guard let title = request.json?["title"]?.string,
		let author = request.json?["author"]?.string,
		let isbn = request.json?["isbn"]?.string
	else {

        throw Abort.badRequest
    }

    // in here it would save the book to the db...

    return try JSON(node:["id": 1, "title": title, "author": author, "isbn": isbn])
}

drop.put("books", Int.self) { request, bookId in

	if bookId != 1 {

		throw Abort.notFound
    }

    print("json = \(request.json)")

	let title = request.json?["title"]?.string ?? "old title"
	let author = request.json?["author"]?.string ?? "old author"
	let isbn = request.json?["isbn"]?.string ?? "old_isbn"

    // in here it would save the book to the db...

    return try JSON(node:["id": 1, "title": title, "author": author, "isbn": isbn])
}

drop.delete("books", Int.self) { request, bookId in

	if bookId != 1 {

		throw Abort.notFound
    }

    print("json = \(request.json)")

	let title = request.json?["title"]?.string ?? "old title"
	let author = request.json?["author"]?.string ?? "old author"
	let isbn = request.json?["isbn"]?.string ?? "old_isbn"

    // in here it would save the book to the db...

    return Response(status: .ok, body: "deleted")
}



drop.run()
