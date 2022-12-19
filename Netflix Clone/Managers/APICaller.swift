//
//  APICaller.swift
//  Netflix Clone
//
//  Created by ADMIN on 24/11/2022.
//

import Foundation


struct Constants{
    // https://api.themoviedb.org/3/movie/upcoming?api_key=<<api_key>>&language=en-US&page=1
    static let API_KEY = "9e604cc3901265dd67d7eaa1cde261f9"
    static let baseURL = "https://api.themoviedb.org/"
    static let YoutubeAPI_KEY = "AIzaSyAy1ouVDSAvklsRj_mTertZZCIkPnE6LCc"
    static let YoutubeBaseURL = "https://youtube.googleapis.com/youtube/v3/search?"
    
}

enum APIError: Error{
    case failedToGetData
}

class APICaller{
    static let shared = APICaller()
    
    func getTrendingMovies(completion: @escaping (Result<[Movie],(Error)>) -> Void){
        guard let url = URL(string: "\(Constants.baseURL)/3/trending/movie/day?api_key=\(Constants.API_KEY)") else{return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)){
            data,_,error in
            guard let data = data, error == nil else {return}
            do{
                let result = try JSONDecoder().decode(TrendingMoviesResponse.self, from: data)
                //print(result)
                completion(.success(result.results))
            }catch{
                completion(.failure(APIError.failedToGetData))
            // print(error.localizedDescription )
            } 
        }
        task.resume()

    }
    
    
    func getTrendingTvs(completion: @escaping (Result<[Tv],(Error)>) -> Void){
        guard let url = URL(string: "\(Constants.baseURL)/3/trending/tv/day?api_key=\(Constants.API_KEY)") else{return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)){
            data,_,error in
            guard let data = data, error == nil else {return}
            do{
                let result = try JSONDecoder().decode(TrendingTvResponse.self, from: data)
                completion(.success(result.results))
            }catch{
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
        
    }
    
    func getUpcomingMovies(completion: @escaping (Result<[UpcomingMovie],(Error)>) -> Void){
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/upcoming?api_key=\(Constants.API_KEY)&language=en-US&page=1") else{return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)){
            data,_,error in
            guard let data = data, error == nil else {return}
            do{
                let result = try JSONDecoder().decode(UpcomingResponse.self, from: data)
                completion(.success(result.results))
            }catch{
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
        
    }
    
    func getPopularMovies(completion: @escaping (Result<[UpcomingMovie],(Error)>) -> Void){
        // the upComingMovie model may have to be changed in future based on Database
        // there probably should be your own PopularMovie Model but it is the same for now
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/popular?api_key=\(Constants.API_KEY)&language=en-US&page=1") else{return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)){
            data,_,error in
            guard let data = data, error == nil else {return}
            do{
                let result = try JSONDecoder().decode(UpcomingResponse.self, from: data)
                completion(.success(result.results))
            }catch{
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
        
    }
    
    
    func getTopRated(completion: @escaping (Result<[UpcomingMovie],(Error)>) -> Void){
        // the upComingMovie model may have to be changed in future based on Database
        // there probably should be your own TopRatedMovie Model but it is the same for now

        guard let url = URL(string: "\(Constants.baseURL)/3/movie/top_rated?api_key=\(Constants.API_KEY)&language=en-US&page=1") else{return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)){
            data,_,error in
            guard let data = data, error == nil else {return}
            do{
                let result = try JSONDecoder().decode(UpcomingResponse.self, from: data)
                completion(.success(result.results))
            }catch{
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
        
    }
    
    
    func getDiscoverMovies(completion: @escaping (Result<[UpcomingMovie],(Error)>) -> Void){

        guard let url = URL(string: "\(Constants.baseURL)/3/discover/movie?api_key=\(Constants.API_KEY)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate") else{return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)){
            data,_,error in
            guard let data = data, error == nil else {return}
            do{
                let result = try JSONDecoder().decode(UpcomingResponse.self, from: data)
                completion(.success(result.results))
            }catch{
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    func search(with query: String, completion: @escaping (Result<[UpcomingMovie],(Error)>) -> Void){
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else{return}
        guard let url = URL(string: "\(Constants.baseURL)/3/search/movie?api_key=\(Constants.API_KEY)&&query=\(query)") else{return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)){
            data,_,error in
            guard let data = data, error == nil else {return}
            do{
                let result = try JSONDecoder().decode(UpcomingResponse.self, from: data)
                completion(.success(result.results))
            }catch{
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    
    
    func getMovie(with query: String, completion: @escaping (Result<VideoElement,(Error)>) -> Void){
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else{return}
        
        guard let url = URL(string: "\(Constants.YoutubeBaseURL)q=\(query)&key=\(Constants.YoutubeAPI_KEY)") else {return}
        // making the call on chrome to view the api response 
        // https://youtube.googleapis.com/youtube/v3/search?q=Harry%20Potter&key=AIzaSyAy1ouVDSAvklsRj_mTertZZCIkPnE6LCc

        let task = URLSession.shared.dataTask(with: URLRequest(url: url)){
            data,_,error in
            guard let data = data, error == nil else {return}
            do{
                let results = try JSONDecoder().decode(YoutubeSearchResponse.self, from: data)
                completion(.success(results.items[0]))
                
            }catch{
                //print(error.localizedDescription)
                completion(.failure(error))
            }
        }
        task.resume()
        
        
    }
}
