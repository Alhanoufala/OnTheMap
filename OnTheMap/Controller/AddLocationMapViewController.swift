//
//  AddLocationMapViewController.swift
//  OnTheMap
//
//  Created by Alhanouf Alawwad on 04/12/1442 AH.
//

import UIKit
import MapKit

class AddLocationMapViewController :UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var studentLocationRequest: StudentLocationRequest?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showAnnotation()
    }
    
    
    
    func showAnnotation()  {
        if let student = studentLocationRequest {
            let annotation = MKPointAnnotation()
            annotation.title = student.mapString
            let coordinate = CLLocationCoordinate2DMake(student.latitude, student.longitude)
            annotation.coordinate = coordinate
            
            if var region = self.mapView?.region {
                region.center = coordinate
                region.span.longitudeDelta /= 8.0
                region.span.latitudeDelta /= 8.0
                self.mapView.setRegion(region, animated: true)
                
                self.mapView.addAnnotation(annotation)
                self.mapView.showAnnotations(self.mapView.annotations, animated: true)
                
            }
        }
        
        
    }
    @IBAction func addLocation(_ sender: Any) {
        loading(true)
        OTMClient.addStudentlocation(location: studentLocationRequest!) { success, error in
            if success{
                self.loading(false)
                self.dismiss(animated: true, completion: nil)
            }
            else{
                self.loading(false)
                self.showFailure(message: error?.localizedDescription ?? "")
                
            }
        }
    }
    
    func loading(_ startloading: Bool) {
        startloading ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        
        
    }
}
extension AddLocationMapViewController:MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
}


