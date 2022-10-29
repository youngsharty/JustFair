//
//  ClassoomStruct.swift
//  JustFair
//
//  Created by Andrew Li on 10/22/22.
//

import SwiftUI

class Classroom: Hashable, ObservableObject {
    
    var title: String
    @Published var classroomDeleteStudentMode: Bool = false
    @Published var people: [Person]
    @Published var lastCalled: String = "none"
    
    init(title: String, people: [Person]) {
        self.title = title
        self.people = people
    }
    
    func getTotalPoints() -> Int {
        var total = 0
        for person in people {
            total += person.points
        }
        return total
    }
    
    func getMedian() -> Double {
        if people.count % 2 == 1 {
            return Double(people.sorted(by: { $0.points < $1.points })[people.count / 2].points)
        }
        return (Double(people.sorted(by: { $0.points < $1.points })[people.count / 2].points) + Double(people.sorted(by: { $0.points > $1.points })[people.count / 2].points)) / 2
    }
    
    func getMode() -> [Int] {
        var highestCounter = 0
        var mode: [Int] = []
        for index in 0..<people.count {
            var counter = 0
            for person in people {
                if people[index].points == person.points {
                    counter += 1
                }
            }
            if counter > highestCounter {
                highestCounter = counter
                mode.removeAll()
                mode.append(people[index].points)
            } else if counter == highestCounter && !mode.contains(people[index].points) {
                mode.append(people[index].points)
            }
        }
        return mode
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }
    
    static func ==(lhs: Classroom, rhs: Classroom) -> Bool {
        return lhs.title == rhs.title && lhs.people == rhs.people
    }
}

struct Person: Hashable, Equatable {
    
    var name: String
    var points: Int
    var color: Color = .gray
    let id = UUID().uuidString
    
    init(name: String, points: Int) {
        self.name = name
        self.points = points
    }
    
    mutating func changeColor(wantedColor: Color) {
        color = wantedColor
    }
    
    static func ==(lhs: Person, rhs: Person) -> Bool {
        return lhs.name == rhs.name && lhs.points == rhs.points
    }
}
