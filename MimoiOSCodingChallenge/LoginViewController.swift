
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
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureTextfields()
        configureButtonsLogin()
        setUpLoginStackViewAndActivity()
        
        self.navigationController?.isNavigationBarHidden = true
        
        self.view.needsUpdateConstraints()
        
        let gest = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        self.view.addGestureRecognizer(gest)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.view.backgroundColor = Theme(rawValue: ThemeManager.currentTheme())!.mainColor
        }
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
        buttonLogin.layer.borderWidth = 1
        buttonLogin.layer.cornerRadius = 4
        buttonSingup = UIButton(type: .roundedRect)
        buttonSingup.setTitle("Sing up", for: UIControlState.normal)
        buttonSingup.addTarget(self, action: #selector(self.singUp), for: UIControlEvents.touchUpInside)
        buttonSingup.layer.borderWidth = 1
        buttonSingup.layer.cornerRadius = 4
        ThemeManager.applyTheme(theme: ThemeManager.currentTheme())
    }
    
    func configureTextfields(){
        emailTexfield = UITextField(forAutoLayout: ())
        emailTexfield.placeholder = "enter email"
        emailTexfield.delegate = self
        emailTexfield.borderStyle = .roundedRect
        emailTexfield.layer.borderWidth = 1
        emailTexfield.layer.cornerRadius = 4
        passTextField = UITextField(forAutoLayout: ())
        passTextField.isSecureTextEntry = true
        passTextField.placeholder = "enter pass"
        passTextField.delegate = self
        passTextField.borderStyle = .roundedRect
        passTextField.layer.borderWidth = 1
        passTextField.layer.cornerRadius = 4
    }
    
    func setUpLoginStackViewAndActivity(){
        
        activityIndicator.hidesWhenStopped = true
        
        stackLogin = UIStackView(forAutoLayout: ())
        stackLogin.axis = .vertical
        stackLogin.distribution = .fillProportionally
        stackLogin.alignment = .fill
        stackLogin.spacing = 20
        
        stackLogin.addArrangedSubview(emailTexfield)
        stackLogin.addArrangedSubview(passTextField)
        stackLogin.addArrangedSubview(buttonLogin)
        stackLogin.addArrangedSubview(buttonSingup)
        
        let margins = view.layoutMarginsGuide
        
        let centerYStack = stackLogin.centerYAnchor.constraint(equalTo: margins.centerYAnchor, constant: -70)
        let centerXStack = stackLogin.centerXAnchor.constraint(equalTo: margins.centerXAnchor)
        let widthStack = stackLogin.widthAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 0.9)
        
        self.view.addSubview(stackLogin)
        activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([centerYStack,centerXStack,widthStack])
    }
    
    //MARK:- Utils
    func hideKeyboard(){
        emailTexfield.resignFirstResponder()
        passTextField.resignFirstResponder()
    }
    
    
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
        buttonLogin.isEnabled ? activityIndicator.stopAnimating() : activityIndicator.startAnimating()
    }
    
}

extension LoginViewController : UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let textfields = [emailTexfield,passTextField]
        let remainTextfields = textfields.filter { (textfieldOnArray) -> Bool in
            return textField != textfieldOnArray && textField.text != "" && textfieldOnArray.text == ""
        }
        textField.resignFirstResponder()
        if remainTextfields.count == 1 {remainTextfields[0].becomeFirstResponder() }
        return true
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
