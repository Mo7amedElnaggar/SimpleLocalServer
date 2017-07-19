# SimpleLocalServer
This is Simple Local Server using Swift as Server Side Language

Deal With a DataBase called ``` NT_Server ``` and Table ``` Accounts ```

you can make 2 Options : 
  * Select exist userName , passWord
  * Add New userName , passWord

## Dependencies
  * Server : HTTPServer
  * DataBase Connector : MySQL
  
## Sample of Code 
```Swift
import PerfectLib
import PerfectHTTP
import PerfectHTTPServer

let server = HTTPServer()
server.serverPort = 8080

var routes = Routes()
// ADD YOUR own routes ....
server.addRoutes(routes)

do {
    
    try server.start()
    
} catch PerfectError.networkError(let err , let msg) {
    
    print(err)
    print(msg)
    
}



```

## Resourses
  * [Prefect.org Documentation](http://perfect.org/docs/)
  * [Perfect Assistant](http://perfect.org/en/perfect-assistant.html)
  * [Swift Server Side](https://github.com/PerfectlySoft/Perfect) 
  * [Prefect MySQL](https://github.com/PerfectlySoft/Perfect-MySQL)
