//
//
//  OnTheMap
// UIViewController+Extension.swift
//  Created by Alhanouf Alawwad on 06/12/1442 AH.
//

import UIKit
extension  UIViewController{
    
    func openURL(_ urlString: String){
        
        if isValidURL(urlString){
            if let url = URL(string: urlString){
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            else{
                showFailure(message: "Invalid URL")
            }
        }
        else {
            showFailure(message: "Invalid URL")
        }
    }
    
    func isValidURL (_ urlString: String) -> Bool {
        if let url  = URL(string: urlString) {
            return UIApplication.shared.canOpenURL(url)
        }
        
        return false
    }
    
    func showFailure(message: String) {
        let alertVC = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
}
