//
//  MapViewController.swift
//  GroupProject
//
//  Created by XiaoQian Huang on 10/24/18.
//  Copyright © 2018 SiuChun Kung. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
  //  var annotations: [PhotoAnnotation] = []
  //  var capturedPhoto: UIImage?
    
    let locationManager = CLLocationManager()
  
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //set locationManager
        locationManager.delegate = self;
        locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;

        //set mapview
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        
        //test data
        setupData()
        
    }
    
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //ask users to get the root
        if CLLocationManager.authorizationStatus() == .notDetermined{
            locationManager.requestAlwaysAuthorization()
        }
        
        //if user didn't agree
        else if CLLocationManager.authorizationStatus() == .denied{
          // showAlert("Location services were previously denied")
            print("Location services were previously denied")
        
        }
        
        //if user agree
        else if CLLocationManager.authorizationStatus() == .authorizedAlways{
            locationManager.startUpdatingLocation()
        }
    }
    
    func setupData(){
        //check if it is success
        if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self){
            let title = "Lorrenzillo's"
            let coordinate = CLLocationCoordinate2DMake(37.783333, -122.416667)
            let regionRadius = 300.0
            
            //propetices
            let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude), radius: regionRadius, identifier: title)
            locationManager.startMonitoring(for: region)
        }
    }
    

   /* @IBOutlet weak var mapView: MKMapView!{
        didSet{
            let sfRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.783333, -122.416667),
                                                  MKCoordinateSpanMake(0.1, 0.1))
            mapView.setRegion(sfRegion, animated: false)
            mapView.delegate = self
        }
    }*/
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBOutlet weak var cameraButton: UIButton!
    
    
    func locationsPickedLocation(controller: LocationsViewController, latitude: NSNumber, longitude: NSNumber) {
        let locationCoordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
        //var image = controller
        // let annotation = MKPointAnnotation()
        let annotation = PhotoAnnotation()
        annotation.coordinate = locationCoordinate
        //annotation.title = "Picture!"
        mapView.addAnnotation(annotation)
        self.navigationController?.popToViewController(self, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        
        let reuseID = "myAnnotationView"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID)
        
        let resizeRenderImageView = UIImageView(frame: CGRect(x:0, y:0, width:45, height:45))
        resizeRenderImageView.layer.borderColor = UIColor.white.cgColor
        resizeRenderImageView.layer.borderWidth = 3.0
        resizeRenderImageView.contentMode = UIViewContentMode.scaleAspectFill
        // resizeRenderImageView.image = (annotation as? PhotoAnnotation)?.photo
        
        if let photoAnnotation = annotation as? PhotoAnnotation{
            
            resizeRenderImageView.image = capturedPhoto
            
            UIGraphicsBeginImageContext(resizeRenderImageView.frame.size)
            resizeRenderImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
            let thumbnail = UIGraphicsGetImageFromCurrentImageContext()
            
            
            if (annotationView == nil) {
                annotationView = MKPinAnnotationView(annotation: photoAnnotation, reuseIdentifier: reuseID)
                annotationView!.canShowCallout = true
                annotationView!.leftCalloutAccessoryView = UIImageView(frame: CGRect(x:0, y:0, width: 50, height:50))
                
                annotationView!.rightCalloutAccessoryView = UIButton(type: UIButtonType.detailDisclosure)
            }
            
            // UIGraphicsEndImageContext()
            
            let imageView = annotationView?.leftCalloutAccessoryView as! UIImageView
            // imageView.image = #imageLiteral(resourceName: "camera")
            // return annotationView
            imageView.image = thumbnail
            
            annotationView?.image = thumbnail
            
            UIGraphicsEndImageContext()
            //return annotationView
        }
        return annotationView
    }
    
    
    /**
     This method receives input from the camera button upon being clicked and then presents the camera/photo library
     - Parameter sender: The Camera Button that will be clicked on this view controller when the user wants to take a picture
     
     */
    @IBAction func didPressCameraButton(_ sender: Any) {
        performSegue(withIdentifier: "locationSegue", sender: nil)
    }
    /**
     This method keeps the capturedPhoto taken from UIImagePicker and sets the PhotoMapViewController's capturedPhoto to be the
     edited image.
     */
    /*func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        // Get the image captured by the UIImagePickerController
        // originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        // Do something with the images (based on your use case)
        capturedPhoto = editedImage
        // Dismiss UIImagePickerController to go back to your original view controller
        dismiss(animated: true, completion: nil)
        performSegue(withIdentifier: "tagSegue", sender: self)
    }*/
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "locationSegue" {
            let vc: LocationsViewController = segue.destination as! LocationsViewController
            vc.delegate = self
        }
        
    }
    
}
