//
//  DataPersistenceManager.swift
//  Netflix Clone
//
//  Created by ADMIN on 28/11/2022.
//

import Foundation
import CoreData
import UIKit

class DataPersistenceManager{
    
    enum DatabaseError: Error{
        case failedToSaveData
        case failedToFetchData
        case failedTODeleteData
    }
    
    static let shared = DataPersistenceManager()
    
    func downloadTitle(with model: Movie, completion: @escaping(Result<Void, Error>)-> Void){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{return}
        
        let context = appDelegate.persistentContainer.viewContext
        let item = TitleItem(context: context)
        
        item.original_title = model.original_title
        item.id = Int64(model.id)
        item.original_name = model.original_title
        item.overview = model.overview
        item.media_type = model.media_type
        item.vote_count = Int64(model.vote_count)
        item.poster_path = model.poster_path
        
        do{
            try context.save()
            completion(.success(()))
        }
        catch{
            completion(.failure(DatabaseError.failedToSaveData))
        }
    }
    
    
    
    func fetchingTitleFromDataBase(completion: @escaping (Result<[TitleItem], Error>)->Void){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{return}
        
        let context = appDelegate.persistentContainer.viewContext
        //let item = TitleItem(context: context)
        
 
        
        let request: NSFetchRequest<TitleItem>
        request = TitleItem.fetchRequest()
        
        do{
            let titles =  try context.fetch(request)
            completion(.success(titles))
            
        }catch{
            completion(.failure(DatabaseError.failedToFetchData))
            print(error.localizedDescription)
        }
    }
    
    
    
    func deleteTitleWith(model: TitleItem, completion: @escaping(Result<Void, Error>)-> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        context.delete(model) // asking the database manager to delete certain object
        do {
            try context.save()
            completion(.success (()))
        } catch {
            completion(.failure(DatabaseError.failedTODeleteData))
        }
                       
    }
}
                    
