//
//  Router.swift
//  MimoiOSCodingChallenge
//
//  Created by Daniel Torres on 9/19/17.
//  Copyright © 2017 Mimohello GmbH. All rights reserved.
//

import Foundation
import Alamofire

enum Router: URLRequestConvertible {
    case login(parameters: Parameters)
    
    static let baseURLString = "https://mimo-test.auth0.com"
    
    var method: HTTPMethod {
        switch self {
        case .login:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .login:
            return "/oauth/ro"
        }
    }
    
    // MARK: URLRequestConvertible
    
    func asURLRequest() throws -> URLRequest {
        let url = try Router.baseURLString.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        switch self {
        case .login(let parameters):
            var loginParams = [
                "client_id": "PAn11swGbMAVXVDbSCpnITx5Utsxz1co",
                "username": parameters["email"],
                "password": parameters["pass"],
                "connection": "Username-Password-Authentication",
                "scope": "openid profile email"
            ]
            let encodedURLRequest = try URLEncoding.queryString.encode(urlRequest, with: parameters)
            //urlRequest = try URLEncoding.URLEncoding.
//            urlRequest = try URLEncoding.///j.default.encode(urlRequest, with: parameters)
        default:
            break
        }
        
        return urlRequest
    }
}
