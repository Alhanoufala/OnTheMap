//
//  OTMClient.swift
//  OnTheMap
//
//  Created by Alhanouf Alawwad on 04/12/1442 AH.
//

import Foundation

class OTMClient {
    
    class func skipUdacityResponse(data: Data,skip: Bool) -> Data  {
        if skip{
            let range = 5..<data.count
            let newData = data.subdata(in: range)
            return newData
        }
        else{
            return data
        }
    }
    struct Auth{
        static var uniqueKey = ""
        static var objectId = ""
        static var firstName = ""
        static var lastName = ""
        
    }
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1/"
        case login
        case signup
        case getUserData(String)
        case getStudentlocations
        case AddStudentlocation
        case updateStudentlocation(String)
        case logout
        
        
        
        var stringValue:String{
            switch self {
            case .login:
                return  Endpoints.base + "session"
            case .signup:
                return "https://auth.udacity.com/sign-up"
                
            case .getUserData(let userId):
                return Endpoints.base + "users/\(userId)"
                
            case .getStudentlocations:
                return  Endpoints.base + "StudentLocation?order=-updatedAt&limit=100"
                
            case .AddStudentlocation:
                return  Endpoints.base + "StudentLocation"
                
            case .updateStudentlocation(let objectId):
                return  Endpoints.base + "StudentLocation/\(objectId)"
                
            case .logout:
                return  Endpoints.base + "session"
                
                
                
            }
            
        }
        
        var url :URL{
            return URL(string: self.stringValue)!
        }
        
        
    }
    class func login(username:String,password:String,completion:@escaping (Bool,Error?)-> Void){
        
        let body = LoginRequest(udacity: LoginItems(username: username, password:password))
        
        taskForPOSTRequest(url: Endpoints.login.url, body: body, responseType: LoginResponse.self, skip: true) { response, error in
            if let response = response{
                Auth.uniqueKey =  response.account.key
                Auth.objectId = response.session.id
                getUserData{ success, error in
                    completion(success, error)
                }
                
            }
            else{
                completion(false,error)
            }
            
        }
    }
    class func getUserData(completion: @escaping (Bool, Error?) -> Void){
        taskForGETRequest(url: Endpoints.getUserData(Auth.objectId).url, responseType: UserResponse.self, skip: true) { response, error in
            if let response = response {
                Auth.firstName = response.firstName
                Auth.lastName = response.lastName
                completion(true,nil)
                
                
            }
            else{
                completion(false,error)
            }
        }
        
    }
    class func getStudentlocations(completion:@escaping ([StudentLocationItemResponse] ,Error?)-> Void){
        taskForGETRequest(url: Endpoints.getStudentlocations.url, responseType: StudentLocationResponse.self, skip: false) { data , error in
            if let data = data {
                completion(data.results , nil)
            }
            else{
                completion([] , error)
            }
            
        }
        
    }
    class  func addStudentlocation(location:StudentLocationRequest ,completion:@escaping (Bool,Error?)-> Void){
        taskForPOSTRequest(url: Endpoints.AddStudentlocation.url, body: location, responseType: AddStudentLocationResponse.self, skip: false) { response, error in
            if response != nil{
                completion(true,nil)
            }
            else{
                completion(false,error)
            }
            
        }
        
        
        
        
    }
    class func updateStudentlocation(location:StudentLocationRequest,objectId:String, completion:@escaping (Bool,Error?)-> Void){
        taskForPUTRequest(url: Endpoints.updateStudentlocation(objectId).url, body: location, responseType: UpdateStudentLocationResponse.self) { response, error in
            if response != nil{
                completion(true,nil)
            }
            else{
                completion(false,error)
            }
            
        }
    }
    class func logout(completion:@escaping (Bool,Error?)-> Void){
        taskForDELETERequest(url: Endpoints.logout.url, responseType: LogoutResponse.self, skip: true) { response, error in
            if response != nil {
                Auth.uniqueKey = ""
                Auth.objectId = ""
                completion(true,nil)
                
            }
            else{
                completion(false,error)
            }
            
        }
        
    }
    
    class func taskForGETRequest<ResponseType:Codable>(url: URL,responseType:ResponseType.Type,skip:Bool,completion : @escaping (ResponseType?,Error?)-> Void ) {
        let task = URLSession.shared.dataTask(with: url){data,response,error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil , error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                
                let newData = skipUdacityResponse(data: data, skip: skip)
                let response = try decoder.decode(ResponseType.self, from: newData)
                DispatchQueue.main.async {
                    completion(response , nil)
                }
            }
            catch{
                do{
                    
                    let newData = skipUdacityResponse(data: data, skip: skip)
                    let errorResponse = try decoder.decode(ErrorResponse.self, from: newData) as Error
                    completion(nil , errorResponse)
                    
                }
                catch{
                    DispatchQueue.main.async {
                        completion(nil , error)
                    }
                }
            }
            
        }
        task.resume()
        
    }
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, body: RequestType, responseType: ResponseType.Type, skip: Bool, completion: @escaping (ResponseType?, Error?) -> Void) {
        var  request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = try! JSONEncoder().encode(body)
        
        let task = URLSession.shared.dataTask(with:  request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let newData = skipUdacityResponse(data: data, skip: skip)
                let response = try decoder.decode(ResponseType.self, from: newData)
                DispatchQueue.main.async {
                    completion(response, nil)
                }
            } catch {
                do {
                    let newData = skipUdacityResponse(data: data, skip: skip)
                    let errorResponse = try decoder.decode(ErrorResponse.self, from: newData)
                    DispatchQueue.main.async {
                        completion(nil, errorResponse as Error)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
    }
    class func taskForPUTRequest<RequestType:Encodable,ResponseType:Codable>(url:URL ,body:RequestType ,responseType:ResponseType.Type,completion : @escaping(ResponseType?,Error?)-> Void){
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(body)
        
        let task = URLSession.shared.dataTask(with: request){data,response,error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil , error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                
                let response = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(response , nil)
                }
            }
            catch{
                do{
                    let errorResponse = try decoder.decode(ErrorResponse.self, from: data) as Error
                    completion(nil , errorResponse)
                    
                }
                catch{
                    DispatchQueue.main.async {
                        completion(nil , error)
                    }
                }
            }
            
        }
        task.resume()
        
    }
    class func taskForDELETERequest<ResponseType:Codable>(url:URL,responseType:ResponseType.Type,skip:Bool,completion : @escaping(ResponseType?,Error?)-> Void){
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        let task = URLSession.shared.dataTask(with: request){data,response,error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil , error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let newData = skipUdacityResponse(data: data, skip: skip)
                let response = try decoder.decode(ResponseType.self, from: newData)
                DispatchQueue.main.async {
                    completion(response , nil)
                }
            }
            catch{
                do{
                    let newData = skipUdacityResponse(data: data, skip: skip)
                    let errorResponse = try decoder.decode(ErrorResponse.self, from: newData) as Error
                    completion(nil , errorResponse)
                    
                }
                catch{
                    DispatchQueue.main.async {
                        completion(nil , error)
                    }
                }
            }
            
        }
        task.resume()
        
    }
    
    
}

