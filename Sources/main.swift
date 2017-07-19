import PerfectLib
import PerfectHTTP
import PerfectHTTPServer
import COpenSSL
import MySQL


let server = HTTPServer()

let testHost = "127.0.0.1"
let testUser = "root" // your user
let testPassword = "12345" // your password
let testDB = "NT_Server"

server.serverPort = 8080

var routes = Routes()

func fetchData(_ userName: String , _ passWord: String) -> JSONConvertible? {
    
    var account = [String : Any]()
    
    let mysql = MySQL()
    
    let connected = mysql.connect(host: testHost, user: testUser, password: testPassword, db: testDB)
    
    guard connected else {
        print("Error , Not Connected")
        return nil
    }
    
    defer {
        mysql.close()
    }
    
    let querySuccess = mysql.query(statement: "SELECT * FROM Accounts where userName = '\(userName)' AND passWord = \(passWord)")
    
    guard querySuccess else { print("Not Success Query") ; return nil }
    
    account = ["DONE" : userName]
    
    return account
}

func saveMsg(_ Msg: (String , String) ) -> Bool {
    let mysql = MySQL()
    
    let connected = mysql.connect(host: testHost, user: testUser, password: testPassword, db: testDB)
    
    guard connected else { return false }
    
    defer {
        mysql.close()
    }
    
    let querySuccess = mysql.query(statement: "INSERT INTO Accounts (userName , passWord) Values ( '\(Msg.0)' , '\(Msg.1)' );")
    
    
    guard querySuccess else { return false }
    
    
    return true
}


routes.add(method: .get, uri: "/Login") { (request: HTTPRequest, response: HTTPResponse) in
    
    guard let userName = request.param(name: "userName") , let passWord = request.param(name: "passWord") else {
     
        response.status = .expectationFailed
        
        return
    }
    
    let json = fetchData(userName, passWord)
    
    response.setHeader(.contentType, value: "text/json")
    do {
        if json == nil {
            response.status = .expectationFailed
        } else {
            try response.setBody(json: json)
                .completed()
        }
        
    } catch {
        // ERROR
    }
}

routes.add(method: .get, uri: "/add") { (request: HTTPRequest, response: HTTPResponse) in

    guard let userName = request.param(name: "userName") , let passWord = request.param(name: "passWord") else {
        
        response.status = .expectationFailed
        
        return
    }
    
    let isSaved: Bool = saveMsg((userName , passWord))
    
    guard isSaved else { response.status = .expectationFailed ; return }

    do {
        response.setHeader(.contentType, value: "test/json")
        try response.setBody(json: ["userName" : userName , "passWord" : passWord])
        .completed()
        
    } catch {
        // ERROR
        response.status = .preconditionFailed
    }
    
}

server.addRoutes(routes)


do {
    
    try server.start()
    
} catch PerfectError.networkError(let err , let msg) {
    
    print(err)
    print(msg)
    
}
