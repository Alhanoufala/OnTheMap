//
//  UserResponse.swift
//  OnTheMap
//
//  Created by Alhanouf Alawwad on 02/12/1442 AH.
//

import Foundation

struct UserResponse: Codable {
    
    let firstName: String
    let lastName: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
    }
}
