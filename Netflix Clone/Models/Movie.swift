//
//  Movie.swift
//  Netflix Clone
//
//  Created by ADMIN on 24/11/2022.
//

import Foundation

struct TrendingMoviesResponse: Codable{
    let results: [Movie]
}
struct Movie: Codable{
    let id: Int
    let media_type: String?
    let original_title: String?
    let poster_path: String?
    let overview: String?
    let vote_count : Int
    let release_date : String?
    let vote_average : Double
}

struct UpcomingResponse: Codable{
    let results: [UpcomingMovie]
}

struct UpcomingMovie: Codable{
    let id: Int
    let backdrop_path: String?
    let adult : Bool
    let video: Bool
    let title: String?
    let original_title: String?
    let original_language: String?
    let poster_path: String?
    let overview: String?
    let vote_count : Int
    let release_date : String?
    let vote_average : Double
}
