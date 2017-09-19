//
//  LoginAPI.swift
//  MimoiOSCodingChallenge
//
//  Created by Daniel Torres on 9/19/17.
//  Copyright © 2017 Mimohello GmbH. All rights reserved.
//

import Foundation
import Alamofire

class UserSession : NSObject {
    
    static let shared = UserSession()
    var idToken : String = ""
    var accessToken : String = ""
    var userObject: User
    
    override init() {
        userObject = User(dict: ["email":"" ,"nickname": ""])
        super.init()
        
    }
    
    func logOut(navControoller: UINavigationController){
        
        let params = [
            "client_id" : idToken
        ]
        
        Alamofire.request(Router.logOut(parameters: params)).responseJSON { response in
            navControoller.popToRootViewController(animated: true)
        }
    }
}


class User : NSObject {
    var email: String = ""
    var nickName: String = ""
    
    
    init(dict: [String: String]){
        
        if let email = dict["email"]{
            self.email = email
        }
        
        if let nickName = dict["nickname"]{
            self.nickName = nickName
        }
        
        super.init()
    }
}

