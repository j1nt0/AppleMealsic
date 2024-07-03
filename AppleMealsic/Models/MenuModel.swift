//
//  MenuModel.swift
//  AppleMealsic
//
//  Created by 이진 on 7/3/24.
//

import Foundation

struct Menu: Identifiable, Codable{
    var id: Int
    var date: Int
    var type: String
    var foods: [Foods]
    var kcal: Int
    var protein: Int
    
    struct Foods: Identifiable, Codable{
        var id: Int
        var name_kor: String
        var name_eng: String
        var isVegan: Bool
        var isMain: Bool
    }
}
