//
//  ExtensionViewController.swift
//  OntheMap_DanielTorres
//
//  Created by Daniel Torres on 12/18/16.
//  Copyright © 2016 Daniel Torres. All rights reserved.
//

import UIKit

extension UIViewController {

    func displayAlert(_ errorString: String, completionHandler: @escaping (() -> Void)) {
        
        let alertViewController = UIAlertController(title: "Alert!", message: errorString, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertViewController.addAction(okButton)
        
        self.present(alertViewController, animated: true, completion: completionHandler )
    }
    
    func displayMessage(_ title: String, _ messageString: String, completionHandler: @escaping (() -> Void)) {
        
        let alertViewController = UIAlertController(title: title, message: messageString, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertViewController.addAction(okButton)
        
        self.present(alertViewController, animated: true, completion: completionHandler )
    }
    
    
    func getPresentedViewController() -> UIViewController {
        
        var viewControllerToReturn = UIViewController()
    
        if let rootViewController = UIApplication.shared.keyWindow?.rootViewController {
            viewControllerToReturn = rootViewController
            if let presented = viewControllerToReturn.presentedViewController {
                viewControllerToReturn = presented
            }
        }
        
        return viewControllerToReturn
    }

}









