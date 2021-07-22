//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Alhanouf Alawwad on 04/12/1442 AH.
//

import UIKit
import MapKit

class AddLocationViewController :UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var studentLocationRequest: StudentLocationRequest?
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var websiteTextField: UITextField!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        locationTextField.delegate = self
        websiteTextField.delegate = self
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubscribeFromKeyboardNotifications()
    }
    //Starting the geocoding from this view and only segue to the final posting screen if the geocoding is successful
    func geocodeAddress() {
        setGeocodeIn(true)
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(locationTextField.text ?? "") {  placemarks, error in
            
            if  error != nil {
                
                self.showFailure(message: "The location couldn't be found. Please re-enter a valid location")
                self.setGeocodeIn(false)
            }
            else {
                
                if let placemark = placemarks?.first , let  location = placemark.location{
                    self.studentLocationRequest = self.getStudentLocationRequest(coordinate: location.coordinate)
                    self.setGeocodeIn(false)
                    self.performSegue(withIdentifier:  "AddToTheMap", sender: nil)
                    
                }
            }
        }
    }
    
    func getStudentLocationRequest(coordinate: CLLocationCoordinate2D)-> StudentLocationRequest{
        let studentLocationRequest = StudentLocationRequest(uniqueKey: OTMClient.Auth.uniqueKey, firstName: OTMClient.Auth.firstName, lastName: OTMClient.Auth.lastName,  mapString: locationTextField.text ?? "" , mediaURL: websiteTextField.text ?? "", latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        return studentLocationRequest
        
    }
    
    func setGeocodeIn(_ geocodeIn: Bool) {
        geocodeIn ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }
    
    
    @IBAction func findLocation(_ sender: Any) {
        if locationTextField.text!.isEmpty || websiteTextField.text!.isEmpty {
            showFailure(message: "Enter your location and a website url please.")
        }
        
        else {
            geocodeAddress()
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddToTheMap" {
            guard let addToTheMapVC = segue.destination as?  AddLocationMapViewController else {
                return
            }
            
            addToTheMapVC.studentLocationRequest = studentLocationRequest
            
            
        }
        
    }
    
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //Keyboared
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self)
    }
    
    //Shifts the view up when the keyboardWillShow notification comes
    @objc func keyboardWillShow(_ notification:Notification) {
        if locationTextField.isFirstResponder{
            view.frame.origin.y  = -getKeyboardHeight(notification)/2
            
        }
        if websiteTextField.isFirstResponder{
            view.frame.origin.y = -getKeyboardHeight(notification)
            
        }
        
        
        
    }
    
    //Move the view back down when the keyboard is dismissed
    @objc  func keyboardWillHide(_ notification:Notification) {
        
        view.frame.origin.y  = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    
    
    
    
}
