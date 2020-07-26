//
//  OTMClient.swift
//  On The Map
//
//  Created by Christopher Crookes on 2020-07-23.
//  Copyright © 2020 Christopher Crookes. All rights reserved.
//

import Foundation

class OTMClient {
    
    struct Auth {
        static var sessionId = ""
        static var userId = ""
    }
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case getStudentLocations(Int)
        case login
        case postStudentLocation
        case logout
        
        var stringValue: String {
            switch self {
            case .getStudentLocations(let limit):
                return Endpoints.base + "/StudentLocation?order=-updatedAt&limit=\(limit)"
            case .login:
                return Endpoints.base + "/session"
            case .postStudentLocation:
                return Endpoints.base + "/StudentLocation"
            case .logout:
                return Endpoints.base + "/session"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionDataTask {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                print(error)
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
        
        return task
    }
    
    class func getStudentList(numStudents limit: Int, completion: @escaping ([StudentInformation], Error?) -> Void) {
        _ = taskForGETRequest(url: Endpoints.getStudentLocations(limit).url, responseType: StudentResults.self) { response, error in
            if let response = response {
                completion(response.results, nil)
            } else {
                completion([], error)
            }
        }
    }
    
    class func login(username: String, password: String, completion: @escaping (Bool, Error?, String?) -> Void) {
        let body = LoginRequest(udacity: LoginRequest.LoginCredentials(username: username, password: password))
        
        var request = URLRequest(url: Endpoints.login.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(body)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(false, error, nil)
                }
                return
            }
            let newData = data.subdata(in: 5..<data.count)
            
            let decoder = JSONDecoder()
            do {
                let loginResponse = try decoder.decode(LoginResponse.self, from: newData)
                Auth.sessionId = loginResponse.session.id
                Auth.userId = loginResponse.account.key
                DispatchQueue.main.async {
                    completion(true, nil, nil)
                }
            } catch {
                do {
                    // try decoding into error response
                    let errorResponse = try decoder.decode(ErrorResponse.self, from: newData)
                    DispatchQueue.main.async {
                        completion(false, error, errorResponse.message)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(false, error, nil)
                    }
                }
            }
        }
        task.resume()
    }
    
    class func logout(completion: @escaping (Bool, Error?) -> Void) {
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                DispatchQueue.main.async {
                    completion(false, error)
                }
            } else {
                // successfully logged out, so reset session and user ids.
                Auth.sessionId = ""
                Auth.userId = ""
                DispatchQueue.main.async {
                    completion(true, nil)
                }
            }
        }
        task.resume()
    }
    
    class func postStudentLocation(studentLocation: PostLocationRequest, completion: @escaping (Bool, Error?) -> Void) {
        var request = URLRequest(url: Endpoints.postStudentLocation.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(studentLocation)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                DispatchQueue.main.async {
                    completion(false, error)
                }
            } else {
               DispatchQueue.main.async {
                    completion(true, nil)
                }
            }
        }
        task.resume()
    }
    
}
