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
    case singup(parameters: Parameters)
    case logOut(parameters: Parameters)
    
    static let baseURLString = "https://mimo-test.auth0.com"
    
    var method: HTTPMethod {
        switch self {
        case .login,.singup:
            return .post
        case .logOut:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .login:
            return "/oauth/ro"
        case .singup:
            return "/dbconnections/signup"
        case .logOut:
            return "/v2/logout"
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .login,.singup:
            return ["Content-Type": "application/json"]
        case .logOut:
            return [String:String]()
        }
    }
    // MARK: URLRequestConvertible
    
    func asURLRequest() throws -> URLRequest {
        let url = try Router.baseURLString.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        switch self {
        case .login(let parameters):
            urlRequest.allHTTPHeaderFields = headers
            
            guard let email = parameters["email"], let pass = parameters["pass"] else {
                return urlRequest
            }
            let loginParams = [
                "client_id": "PAn11swGbMAVXVDbSCpnITx5Utsxz1co",
                "username": email,
                "password": pass,
                "connection": "Username-Password-Authentication",
                "scope": "openid profile email"
            ]
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: loginParams)
        case .singup(let parameters):
            urlRequest.allHTTPHeaderFields = headers
            
            guard let email = parameters["email"], let pass = parameters["pass"] else {
                return urlRequest
            }
            let singupParams = [
                "client_id": "PAn11swGbMAVXVDbSCpnITx5Utsxz1co",
                "email": email,
                "password": pass,
                "connection": "Username-Password-Authentication",
                "user_metadata": ""
            ]
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: singupParams)
        case .logOut(let parameters):
            
            guard let client_id = parameters["client_id"] else {
                return urlRequest
            }
            let singupParams = [
                "client_id": client_id
            ]
            urlRequest = try URLEncoding.queryString.encode(urlRequest, with: singupParams)
        }
        
        return urlRequest
    }
}
