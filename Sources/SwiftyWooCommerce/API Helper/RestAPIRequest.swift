//
//  RestAPIRequest.swift
//
//
//  Created by Chris Foreman on 8/12/20.
//

import Foundation


public protocol RestAPIRequest {
    
    associatedtype ResponseType:Decodable
    
    var headers: [String:String]? { get set }
    
    var parameters: [String:String]? { get set }
    
    var endPoint: String { get set }
    
    var body:Data? { get set }
    
    var method: HTTPMethod { get set }
    
    func send(completion: @escaping (Swift.Result<ResponseType, Error>) -> Void)
    
}

public extension RestAPIRequest {
    
    mutating func setBody(with dict: [String:Any]) {
        guard !dict.isEmpty else { return }
        do {
            self.body = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
        }catch {
            return
        }
    }
    
    ///Converts the RestAPIRequest to a URLRequest, sends it off via URLSession and tries to decode the response to the Requests associated type.
    func send(completion: @escaping (Swift.Result<ResponseType, Error>) -> Void) {
        var url = URLComponents(string: self.endPoint)!
        //Add params to the url.
        url.queryItems = parameters?.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }
        //Escape the + character correctly for encoded "application/x-www-form-urlencoded.
        url.percentEncodedQuery = url.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        var request = URLRequest(url: url.url!)
        request.httpMethod = self.method.rawValue
        request.allHTTPHeaderFields = self.headers
        request.cachePolicy = .reloadIgnoringLocalCacheData //Disable cache
    
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard
                let data = data
            else {
                //Safe force unwrap
                completion(.failure(error!))
                return
            }
            do {
                let object = try JSONDecoder().decode(ResponseType.self, from: data)
                completion(.success(object))
            } catch (let serializeErr) {
                completion(.failure(serializeErr))
            }
        }
        //Must call for completion block to execute.
        task.resume()
    }
}


public enum HTTPMethod:String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
}
