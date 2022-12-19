//
//  Extensions.swift
//  Netflix Clone
//
//  Created by ADMIN on 24/11/2022.
//

import Foundation

extension String{
    func capitalizeFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst() // There's already a built in function 
    }
    
}
