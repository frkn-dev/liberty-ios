//
//  Router.swift
//  Liberty
//
//  Created by Yury Soloshenko on 24.12.2022.
//

import Alamofire

public enum Router: URLRequestConvertible {
    
    // MARK: - BaseURL
    
    public static var baseURLString: String = "https://api.fuckrkn1.org"
    
    // MARK: - Case
    
    case getPeer(parameters: Parameters)
    case getLocations
    
    // MARK: - Method
    
    var method: HTTPMethod {
        switch self {
            case .getPeer:      return .get
            case .getLocations: return .get
        }
    }
    
    // MARK: - Path
    
    var path: String {
        switch self {
            case .getPeer:      return "/peer"
            case .getLocations: return "/locations"
        }
    }
    
    // MARK: - Functions
    
    public func asURLRequest() throws -> URLRequest {
        guard let pathEncoded = path.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else {
            throw URLError(.badURL)
        }
        guard let url = makeUrlFrom(pathEncoded: pathEncoded, baseURLString: Router.baseURLString) else {
            // TODO: Add logging
            throw URLError(.badURL)
        }
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = method.rawValue
        urlRequest.timeoutInterval = 30
        
        try encodeParameters(for: &urlRequest)
        
        return urlRequest
    }
    
    private func makeUrlFrom(pathEncoded: String,baseURLString: String) -> URL? {
        return try? (baseURLString + pathEncoded).asURL()
    }
    
    private func encodeParameters(for urlRequest: inout URLRequest) throws {
        
        switch self {
        case .getPeer(let parameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        default:
            break
        }
    }
}
