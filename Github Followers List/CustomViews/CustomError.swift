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
    case userNotFound = "The requested user was not found." // Dodato za 404
    case unableToFavorite = "Error found trying to favorite this user. Try again"
}
