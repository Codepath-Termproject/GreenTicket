//
//  Map.swift
//  GroupProject
//
//  Created by XiaoQian Huang on 10/24/18.
//  Copyright © 2018 SiuChun Kung. All rights reserved.
//

//import Foundation
import UIKit
import MapKit

class PhotoAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(0, 0)
    var photo: UIImage!
    
    var title: String? {
        return "\(coordinate.latitude)"
    }
}
