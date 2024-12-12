//
//  Athlete.swift
//  FavoriteAthlete
//
//  Created by Hunter, Chloe Mikhayla. (Student) on 10/20/24.
//

import Foundation
struct Athlete{
    var name: String
    var age: Int
    var league: String
    var team: String
    
    var description:String{
        return("\(name) is \(age) years old and plays for the \(team) in \(league).")
    }
}
