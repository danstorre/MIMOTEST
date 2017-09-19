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
    var accessToken : String = ""
    
    func logOut(navControoller: UINavigationController){
        
        let params = [
            "client_id" : accessToken
        ]
        
        Alamofire.request(Router.logOut(parameters: params)).responseJSON { response in
            navControoller.popToRootViewController(animated: true)
        }
        
    }
    
    
}
