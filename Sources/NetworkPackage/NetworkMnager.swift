//
//  NetworkMnager.swift
//  SwiftUI API Call
//
//  Created by Edwin Mbaabu on 11/20/24.
//

import Foundation

 public protocol Network{
    //creating a generic function
     func getDataFromUrl<T: Decodable>(url:String ,modelType:T.Type) async throws -> T
}
@available(iOS 15.0, macOS 12.0, *)
public class NetworkMnager{
    
    let urlSession : URLSession
    
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
}

@available(iOS 15.0, macOS 12.0, *)
extension NetworkMnager: Network{
    
    
    public func getDataFromUrl<T>(url: String, modelType: T.Type) async throws -> T where T : Decodable {
        
        guard let urlObject = URL(string: url) else{
            throw NetworkError.InvalidURLError
            
        }
        do{
            let (data, respose) = try await self.urlSession.data(from: urlObject)

            guard let response = respose as? HTTPURLResponse else{
                throw NetworkError.InvalidDataResponseError
            }
            guard (200...299).contains(response.statusCode) else{
                throw NetworkError.InvalidStatusCodeResponse
            }
            
            let parsedData = try JSONDecoder().decode(modelType, from: data)
            return parsedData
            
        }catch{
            print(error.localizedDescription)
            
            throw error
            
        }
        
    }
    
}
