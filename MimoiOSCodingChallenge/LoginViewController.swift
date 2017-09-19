
//
//  LoginViewController.swift
//  MimoiOSCodingChallenge
//
//  Created by Daniel Torres on 9/19/17.
//  Copyright © 2017 Mimohello GmbH. All rights reserved.
//

import UIKit
import PureLayout
import Alamofire

class LoginViewController: UIViewController {

    var emailTexfield = UITextField()
    var passTextField = UITextField()
    
    var buttonLogin: UIButton = UIButton()
    var buttonSingup: UIButton = UIButton()
    var stackLogin: UIStackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureTextfields()
        configureButtonsLogin()
        setUpLoginStackView()
        
        self.navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = UIColor.cyan
        self.view.needsUpdateConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- configure methods
    
    func configureButtonsLogin(){
        buttonLogin = UIButton(type: .roundedRect)
        buttonLogin.setTitle("Login!", for: UIControlState.normal)
        buttonLogin.addTarget(self, action: #selector(self.login), for: UIControlEvents.touchUpInside)
        buttonSingup = UIButton(type: .roundedRect)
        buttonSingup.setTitle("Sing up", for: UIControlState.normal)
        buttonSingup.addTarget(self, action: #selector(self.singUp), for: UIControlEvents.touchUpInside)
    }
    
    func configureTextfields(){
        emailTexfield = UITextField(forAutoLayout: ())
        emailTexfield.backgroundColor = UIColor.white
        emailTexfield.placeholder = "enter email"
        passTextField = UITextField(forAutoLayout: ())
        passTextField.isSecureTextEntry = true
        passTextField.backgroundColor = UIColor.white
        passTextField.placeholder = "enter pass"
        //todo delegate
    }
    
    func setUpLoginStackView(){
        
        stackLogin = UIStackView(forAutoLayout: ())
        stackLogin.axis = .vertical
        stackLogin.distribution = .fillProportionally
        stackLogin.alignment = .fill
        stackLogin.spacing = 40
        
        stackLogin.addArrangedSubview(emailTexfield)
        stackLogin.addArrangedSubview(passTextField)
        stackLogin.addArrangedSubview(buttonLogin)
        stackLogin.addArrangedSubview(buttonSingup)
        
        let margins = view.layoutMarginsGuide
        
        let centerYStack = stackLogin.centerYAnchor.constraint(equalTo: margins.centerYAnchor)
        let centerXStack = stackLogin.centerXAnchor.constraint(equalTo: margins.centerXAnchor)
        let widthStack = stackLogin.widthAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 0.9)
        
        self.view.addSubview(stackLogin)
        NSLayoutConstraint.activate([centerYStack,centerXStack,widthStack])
        
    }
    
    //MARK:- Utils
    
    func validateTexfields() -> Bool{
        guard emailTexfield.text! != "" else {
            self.displayAlert("Missing email", completionHandler: {})
            return false
        }
        guard passTextField.text! != "" else {
            self.displayAlert("Missing password", completionHandler: {})
            return false
        }
        return true
    }
    func toggleButtons(){
        buttonSingup.isEnabled = !buttonSingup.isEnabled
        buttonLogin.isEnabled = !buttonLogin.isEnabled
    }
    
}

//MARK:- Login Methods
fileprivate extension LoginViewController {
    
    @objc func singUp(){
        guard validateTexfields() else {
            return
        }
        toggleButtons()
        let params = [
            "email" : emailTexfield.text!,
            "pass" : passTextField.text!
        ]
        
        Alamofire.request(Router.singup(parameters: params)).responseJSON { response in
            DispatchQueue.main.async {
                self.toggleButtons()
                guard let json = response.result.value as? [String:AnyObject] else {
                    return
                }
                if let errorDescription = json["error"] as? String  {
                    return self.displayAlert(errorDescription, completionHandler: {})
                }
                if let statusCode = json["statusCode"] as? Int, !((statusCode >= 200) && (statusCode < 300))  {
                    if let errorDesc = json["description"] as? String{
                        self.displayAlert(errorDesc, completionHandler: {})
                    }
                    return
                }
                
                print("JSON: \(json)") //  json response
                guard let _ = json["email"] else {
                    if let errorDescription = json["error_description"] as? String {
                        self.displayAlert(errorDescription, completionHandler: {})
                    }
                    return
                }
                self.displayMessage("Success","Go ahead and login with your new accout. An email as been sent to you for verification too.", completionHandler: {})
            }
        }
    }
    
    @objc func login(){
        
        guard validateTexfields() else {
            return
        }
        
        toggleButtons()
        
        let params = [
            "email" : emailTexfield.text!,
            "pass" : passTextField.text!
        ]
        
        Alamofire.request(Router.login(parameters: params)).responseJSON { response in
            
                guard let json = response.result.value as? [String:AnyObject] else {
                    DispatchQueue.main.async {
                        self.toggleButtons()
                    }
                    return
                    
                }
                
                print("JSON: \(json)") //  json response
                guard let idToken = json["id_token"] as? String, let accessToken = json["access_token"] as? String else {
                    
                    if let errorDescription = json["error_description"] as? String {
                        DispatchQueue.main.async {
                            self.toggleButtons()
                            self.displayAlert(errorDescription, completionHandler: {})}
                        }
                    return
                }
                UserSession.shared.idToken = idToken
                UserSession.shared.accessToken = accessToken
                
                
                Alamofire.request(Router.userinfo()).responseJSON { response in
                    
                    guard let json = response.result.value as? [String:AnyObject] else {
                        DispatchQueue.main.async {
                            self.toggleButtons()
                        }
                        return
                    }
                    
                    
                    if let errorDescription = json["error_description"] as? String {
                        DispatchQueue.main.async {
                            self.toggleButtons()
                            self.displayAlert(errorDescription, completionHandler: {})}
                    }
                    
                    guard let email = json["email"] as? String, let nickname = json["nickname"] as? String, let picture = json["picture"] as? String else {
                        DispatchQueue.main.async {
                            self.toggleButtons()
                        }
                        return
                    }
                    
                    UserSession.shared.userObject = User(dict: ["email": email,"nickname": nickname,"picture": picture])
                    
                    let settingsVc = SettingsViewController()
                    DispatchQueue.main.async {
                        self.toggleButtons()
                        self.navigationController?.pushViewController(settingsVc, animated: true)
                    }
                }
                
        }
        
    }
    
}
