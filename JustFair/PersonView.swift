//
//  PersonView.swift
//  JustFair
//
//  Created by Andrew Li on 10/25/22.
//

import SwiftUI

class PersonViewViewModel: ObservableObject {
    @Published var color: Color = .gray
}

struct PersonView: View {
    
    var index: Int
    @StateObject var classroom: Classroom
    @Binding var person: Person
    @State private var presentAlert: Bool = false
    var size: Double
    
    var body: some View {
        Circle()
            .stroke(person.color, lineWidth: 5)
            .frame(height: CGFloat(size))
            .overlay {
                VStack {
                    Text(person.name)
                        .font(.title2)
                    
                    Text("\(person.points)")
                }
            }
            .onTapGesture {
                if classroom.classroomDeleteStudentMode {
                    presentAlert.toggle()
                } else {
                    onPicked()
                }
            }
            .alert("Delete student?", isPresented: $presentAlert, actions: {
                Button("Delete", role: .destructive, action: {
                    classroom.classroomDeleteStudentMode = false
                    classroom.people.remove(at: index)
                    for index in 0..<classroom.people.count {
                        if classroom.people[index].points == classroom.people.sorted(by: { $0.points < $1.points }).first?.points ?? 0 {
                            classroom.people[index].color = .orange
                        } else if classroom.people[index].points == classroom.people.sorted(by: { $0.points > $1.points }).first?.points ?? 0 {
                                classroom.people[index].color = .green.opacity(3)
                        } else {
                            classroom.people[index].color = .gray
                        }
                    }
                })
            }, message: {
                Text("This action cannot be undone.")
            })
    }

    func onPicked() {
        // Color Animation
        let storeColor: Color = person.color
        person.points += 1
        person.color = .blue
        withAnimation(.easeIn(duration: 3.0)) {
            person.color = storeColor
        }
        classroom.lastCalled = person.name
        
        // Color sorting
        for index in 0..<classroom.people.count {
            if classroom.people[index].points == classroom.people.sorted(by: { $0.points < $1.points }).first?.points ?? 0 {
                classroom.people[index].color = .orange
            } else if classroom.people[index].points == classroom.people.sorted(by: { $0.points > $1.points }).first?.points ?? 0 {
                    classroom.people[index].color = .green.opacity(3)
            } else {
                classroom.people[index].color = .gray
            }
        }
    }
}
