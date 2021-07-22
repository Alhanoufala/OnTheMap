//
//  ErrorResponse.swift
//  OnTheMap
//
//  Created by Alhanouf Alawwad on 02/12/1442 AH.
//

import Foundation

struct ErrorResponse: Codable {
    
    let status: Int
    let error: String
}

extension ErrorResponse: LocalizedError {
    var errorDescription: String? {
        return error
    }
}
