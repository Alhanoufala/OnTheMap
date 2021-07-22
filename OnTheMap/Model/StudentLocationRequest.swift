//
//  StudentLocationRequest.swift
//  OnTheMap
//
//  Created by Alhanouf Alawwad on 02/12/1442 AH.
//

import Foundation

struct StudentLocationRequest: Codable {
    
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Double
    let longitude: Double
}
