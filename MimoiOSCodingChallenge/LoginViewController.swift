
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
    func toggleButtonsEnabled(){
        buttonSingup.isEnabled = !buttonSingup.isEnabled
        buttonLogin.isEnabled = !buttonLogin.isEnabled
    }
    
    func singUp(){
        guard validateTexfields() else {
            return 
        }
        toggleButtonsEnabled()
        let params = [
            "email" : emailTexfield.text!,
            "pass" : passTextField.text!
        ]
        Alamofire.request(Router.singup(parameters: params)).responseJSON { response in
            DispatchQueue.main.async {
                self.toggleButtonsEnabled()
                
                
                guard let json = response.result.value as? [String:AnyObject] else {
                    return
                }
                if let errorDescription = json["error"] as? String  {
                    return self.displayAlert(errorDescription, completionHandler: {})
                }
                
                print("JSON: \(json)") //  json response
                guard let id = json["email"] else {
                    
                    if let errorDescription = json["error_description"] as? String {
                        self.displayAlert(errorDescription, completionHandler: {})
                    }
                    return
                }
                self.displayMessage("Success","Go ahead and login with your new accout. An email as been sent to you for verification too.", completionHandler: {})
            }
        }
    }
    
    func login(){
        
        
        guard validateTexfields() else {
            return
        }
        
        toggleButtonsEnabled()
        
        let params = [
            "email" : emailTexfield.text!,
            "pass" : passTextField.text!
        ]
        
        Alamofire.request(Router.login(parameters: params)).responseJSON { response in
            DispatchQueue.main.async {
                self.toggleButtonsEnabled()
            
            
            guard let json = response.result.value as? [String:AnyObject] else {
                return
            }
                
            print("JSON: \(json)") //  json response
            guard let id = json["id_token"] else {
                    
                if let errorDescription = json["error_description"] as? String {
                    self.displayAlert(errorDescription, completionHandler: {})
                }
                return
            }
            
            }
        }
    }
    
    func configureButtonsLogin(){
        buttonLogin = UIButton(type: .roundedRect)
        buttonLogin.setTitle("Login!", for: UIControlState.normal)
        buttonLogin.addTarget(self, action: #selector(login), for: UIControlEvents.touchUpInside)
        buttonSingup = UIButton(type: .roundedRect)
        buttonSingup.setTitle("Sing up", for: UIControlState.normal)
        buttonSingup.addTarget(self, action: #selector(singUp), for: UIControlEvents.touchUpInside)
    }
    
    func configureTextfields(){
        emailTexfield = UITextField(forAutoLayout: ())
        emailTexfield.backgroundColor = UIColor.white
        emailTexfield.placeholder = "enter email"
        passTextField = UITextField(forAutoLayout: ())
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
