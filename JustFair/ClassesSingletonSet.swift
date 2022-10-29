//
//  ClassesSingletonSet.swift
//  JustFair
//
//  Created by Andrew Li on 10/22/22.
//

import SwiftUI

class ClassesSingleton {
    
    static let classesShared = ClassesSingleton()
    @Published var classes: [Classroom] = [Classroom(title: "Demo Classroom", people: [Person(name: "Anthony", points: 5), Person(name: "Britanny", points: 9), Person(name: "Carson", points: 12), Person(name: "Diana", points: 14), Person(name: "Emma", points: 5), Person(name: "Frank", points: 2), Person(name: "George", points: 4), Person(name: "Hannah", points: 6), Person(name: "Ian", points: 3)] )]
}
