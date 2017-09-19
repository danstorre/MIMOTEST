
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
    var stackLogin: UIStackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureTextfields()
        configureButtonLogin()
        setUpLoginStackView()
        self.view.backgroundColor = UIColor.blue
        self.view.needsUpdateConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func login(){
        
    }
    
    func configureButtonLogin(){
        buttonLogin = UIButton(forAutoLayout: ())
        buttonLogin.setTitle("Login!", for: UIControlState.normal)
        buttonLogin.addTarget(self, action: #selector(login), for: UIControlEvents.touchUpInside)
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
