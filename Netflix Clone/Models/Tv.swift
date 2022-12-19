//
//  Tv.swift
//  Netflix Clone
//
//  Created by ADMIN on 24/11/2022.
//

import Foundation

struct TrendingTvResponse: Codable{
    let results: [Tv]
}

struct Tv: Codable{
    let id: Int
    let backdrop_path: String?
    let adult : Bool
    let original_name: String?
    let media_type: String?
    let original_title: String?
    let original_language: String?
    let poster_path: String?
    let overview: String?
    let vote_count : Int
    let release_date : String?
    let vote_average : Double
    let first_air_date: String
}
