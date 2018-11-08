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
  
    var monitoredRegions: Dictionary<String, NSDate> = [:]
    
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
            //use UIAlertController to show some information
            //print("Location services were previously denied")
            let alert = UIAlertController(title: " ", message: "Location services were previously denied", preferredStyle: UIAlertControllerStyle.alert)
            
            // Add action buttons to the alert
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            // Present the alert to the view
            self.present(alert, animated: true, completion: nil)
        
        }
        
        //if user agree
        else if CLLocationManager.authorizationStatus() == .authorizedAlways{
            locationManager.startUpdatingLocation()
        }
    }
    
    func setupData(){
        //check if it is success
        if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self){
            let title = "San Francisco State University"
            let coordinate = CLLocationCoordinate2DMake(37.723081, -122.476008)
            let regionRadius = 50.0
            
            //propetices
            let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude), radius: regionRadius, identifier: title)
            locationManager.startMonitoring(for: region)
            
            //create annotation
            let restaurantAnnotation = MKPointAnnotation()
            restaurantAnnotation.coordinate = coordinate
            restaurantAnnotation.title = "\(title)"
            //mapView.addAnnotation(restaurantAnnotation)
            
            //create a circle to represent the range of region
            let circle = MKCircle(center: coordinate, radius: regionRadius)
            //mapView.add(circle)
        }
        else{
            print("System can't track regions")
        }
    }
    
    //draw circle
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let circleRenderer = MKCircleRenderer(overlay: overlay)
        circleRenderer.strokeColor = UIColor.red
        circleRenderer.lineWidth = 1.0
        return circleRenderer
        
    }
    
    func showAlert(Title: String, Message: String) {
        let alert = UIAlertController(title: Title, message: Message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //when the user enter a region
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        showAlert(Title: "enter \(region.identifier)", Message: "enter successfully")
        
        //record the enter time
        monitoredRegions[region.identifier] = NSDate()
    }

    //when the user exit a region
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        showAlert(Title: "enter \(region.identifier)", Message: "exit successfully")
        
        //exit time
        monitoredRegions.removeValue(forKey: region.identifier)
    }
    
    //update region
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        updateRegions()
    }
    
    //function updateRegions
    func updateRegions()
    {
        let regionMaxVisiting = 10.0
        var regionsToDelete: [String] = []
        
        for regionIdentifier in monitoredRegions.keys{
            
            //3.
            if NSDate().timeIntervalSince(monitoredRegions[regionIdentifier]! as Date) > regionMaxVisiting {
                showAlert(Title: "", Message: "Thanks for visiting our place")
                
                regionsToDelete.append(regionIdentifier)
            }
        }
        
        for regionIdentifier in regionsToDelete{
            monitoredRegions.removeValue(forKey: regionIdentifier)
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
    
   // @IBOutlet weak var cameraButton: UIButton!
    
    
    /*func locationsPickedLocation(controller: LocationsViewController, latitude: NSNumber, longitude: NSNumber) {
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
    
    @IBAction func didPressCameraButton(_ sender: Any) {
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "locationSegue" {
            let vc: LocationsViewController = segue.destination as! LocationsViewController
            vc.delegate = self
        }
        
    }*/
    
}
