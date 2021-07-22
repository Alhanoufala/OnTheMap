//
//  StudentLocationTabBarController.swift
//  OnTheMap
//
//  Created by Alhanouf Alawwad on 04/12/1442 AH.
//

import UIKit
class StudentLocationTabBarController :UITabBarController {
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        getStudentLocations()
    }
    
    func relodData(){
        guard let mapViewController = viewControllers?.first as?   StudentLocationMapViewController    ,
              let  tableViewController = viewControllers?.last as?   StudenLocationListViewController  else {
            return
        }
        mapViewController.reloadLocations()
        tableViewController.reloadLocations()
        
        
    }
    
    func getStudentLocations(){
        OTMClient.getStudentlocations { result, error in
            if error != nil{
                
                self.showFailure(message: error?.localizedDescription ?? "")
            }
            else{
                StudentModel.studentList.removeAll()
                
                StudentModel.studentList = result
            }
            
            self.relodData()
            
        }
    }
    @IBAction func refresh(_ sender: Any) {
        getStudentLocations()
    }
    
    @IBAction func addLocation(_ sender: Any) {
        if OTMClient.Auth.objectId.isEmpty{
            self.performSegue(withIdentifier: "AddNewLocation", sender: nil)
        }
        else{
            let alertVC = UIAlertController(title: "", message: "You have already posted a student location. Would you like to overwrite your current location?", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "Overwrite", style: .default, handler: { alertAction in
                self.performSegue(withIdentifier: "AddNewLocation", sender: nil)
            }))
            alertVC.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            present(alertVC, animated: true, completion: nil)
        }
    }
    
    
    
    @IBAction func logoutTapped(_ sender: Any) {
        OTMClient.logout { success, error in
            if success{
                self.dismiss(animated: true, completion: nil)
            }
            else {
                self.showFailure(message: error?.localizedDescription ?? "")
            }
        }
    }
    
    
}

