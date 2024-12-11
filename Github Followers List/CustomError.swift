//
//  CustomError.swift
//  Github Followers List
//
//  Created by Orhan Pojskic on 12/11/24.
//

import Foundation

enum CustomErrorForGetFollowers: String, Error{
    case invalidURL = "Invalid URL"
    case errorData = "Check your internet connection"
    case invalidResponse = "Invalid response"
    case dataMissing = "No data"
}
