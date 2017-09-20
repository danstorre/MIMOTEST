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
        navControoller.popToRootViewController(animated: true)
        
        Alamofire.request(Router.logOut(parameters: params)).responseJSON { response in
        }
    }
    
    func getAvatarImage(completionHandlerForGettingImage: @escaping (UIImage, Bool) -> Void) {
            
            let imageURL = userObject.picture
            let url = URL(string: imageURL)
            
            guard let data = try? Data(contentsOf: url!) else {
                return completionHandlerForGettingImage(UIImage(),false)
            }
            
            completionHandlerForGettingImage(UIImage(data: data)!,true)
    }
}


class User : NSObject {
    var email: String = ""
    var nickName: String = ""
    var picture: String = ""
    
    
    init(dict: [String: String]){
        
        if let email = dict["email"]{
            self.email = email
        }
        
        if let nickName = dict["nickname"]{
            self.nickName = nickName
        }
        
        if let pic = dict["picture"]{
            self.picture = pic
        }
        
        super.init()
    }
}

