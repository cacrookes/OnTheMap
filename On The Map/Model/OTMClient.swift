//
//  OTMClient.swift
//  On The Map
//
//  Created by Christopher Crookes on 2020-07-23.
//  Copyright © 2020 Christopher Crookes. All rights reserved.
//

import Foundation

class OTMClient {
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case getStudentLocations(Int)
        
        var stringValue: String {
            switch self {
            case .getStudentLocations(let limit):
                return Endpoints.base + "/StudentLocation?order=-updatedAt&limit=\(limit)"
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
    
}
