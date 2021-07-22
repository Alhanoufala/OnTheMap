//
//  StudentLocationMapViewController.swift
//  OnTheMap
//
//  Created by Alhanouf Alawwad on 04/12/1442 AH.
//


import MapKit
class StudentLocationMapViewController: UIViewController{
    
    @IBOutlet weak var mapView: MKMapView!
    var annotations = [MKPointAnnotation]()
    
    
    func loadData(){
        mapView.removeAnnotations(annotations)
        annotations.removeAll()
        
        for student in StudentModel.studentList {
            let latitude = CLLocationDegrees(student.latitude)
            let longitude = CLLocationDegrees(student.longitude)
            
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(student.firstName) \(student.lastName)"
            annotation.subtitle = student.mediaURL
            
            annotations.append(annotation)
        }
        
        
         mapView.addAnnotations(annotations)
         mapView.showAnnotations(mapView.annotations, animated: true)
        
    }
    func reloadLocations(){
        loadData()
    }
    
    
}
extension StudentLocationMapViewController: MKMapViewDelegate{
    
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
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            
            if let toOpen = view.annotation?.subtitle! {
                openURL(toOpen)
            }
        }
    }
    
    
}

