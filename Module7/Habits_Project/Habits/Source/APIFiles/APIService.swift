//
//  APIService.swift
//  Habits
//
//  Created by Berry, Brett A. (Student) on 12/5/24.
//

import Foundation

struct HabitRequest: APIRequest {
    typealias Response = [String: Habit]

    var habitName: String?

    var path: String { "/habits" }
    
}
