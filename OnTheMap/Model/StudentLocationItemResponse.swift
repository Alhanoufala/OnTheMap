//
//  StudentLocationItemResponse.swift
//  OnTheMap
//
//  Created by Alhanouf Alawwad on 01/12/1442 AH.
//

import Foundation
struct StudentLocationItemResponse: Codable {
    
    let objectId:String
    let uniqueKey:String
    let firstName:String
    let lastName:String
    let mapString:String
    let mediaURL:String
    let latitude:Double
    let longitude:Double
    let createdAt:String
    let updatedAt:String
    
}
