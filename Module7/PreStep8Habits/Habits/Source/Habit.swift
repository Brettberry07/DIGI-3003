//
//  Habit.swift
//  Habits
//
//  Created by Berry, Brett A. (Student) on 12/5/24.
//

import Foundation

struct Habit {
    let name: String
    let category: Category
    let info: String
}
extension Habit: Codable { }

extension Habit: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }

    static func == (lhs: Habit, rhs: Habit) -> Bool {
        return lhs.name == rhs.name
    }
}

extension Habit: Comparable {
    static func < (lhs: Habit, rhs: Habit) -> Bool {
        return lhs.name < rhs.name
    }
}




