//
//  ClassroomView.swift
//  JustFair
//
//  Created by Andrew Li on 10/22/22.
//

import SwiftUI



struct ClassroomView: View {
    
    @StateObject var classroom: Classroom
    @State private var editMode = false
    @State private var addStudentSheetIsPresented = false
    @State private var statsSheetIsPresented = false
    @State private var textFieldText: String = ""
    @State private var editNumPoints: Int = 0
    @State private var size: Double = UIScreen.main.bounds.width / 4
    @State private var isAlertDelete: Bool = false
    @State private var isEmptyAlert: Bool = false

    let columns: [GridItem] = [
        GridItem(.flexible(minimum: UIScreen.main.bounds.width / 6, maximum: UIScreen.main.bounds.width / 2)),
        GridItem(.flexible(minimum: UIScreen.main.bounds.width / 6, maximum: UIScreen.main.bounds.width / 2)), 
        GridItem(.flexible(minimum: UIScreen.main.bounds.width / 6, maximum: UIScreen.main.bounds.width / 2))
    ]
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray.opacity(0.3))
                .frame(height: 80)
                .frame(maxWidth: .infinity)
                .overlay {
                    Text(classroom.title)
                        .font(.system(size: 30, weight: .semibold))
                }
            
            Text("Last Called: \(classroom.lastCalled)")
                .font(.system(size: 25, weight: .medium))
            
            Spacer()
            
            LazyVGrid(columns: columns) {
                ForEach(0..<classroom.people.count, id: \.self) { index in
                    PersonView(index: index, classroom: classroom, person: $classroom.people[index], size: size)
                }
            }
            .onAppear {
                changeColorsAfterPicked()
            }
            Spacer()
            
            buttonsView
        }
    }
    
    var buttonsView: some View {
        VStack {
            HStack {
                Button {
                    if classroom.people.isEmpty && !editMode {
                        isEmptyAlert = true
                    } else if editMode {
                        addStudentSheetIsPresented.toggle()
                    } else {
                        let randomInt = Int.random(in: 0..<classroom.people.count)
                        classroom.people[randomInt].points += 1
                        classroom.lastCalled = classroom.people[randomInt].name
                        changeColorsAfterPicked()
                    }
                } label: {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(editMode ? Color.orange.opacity(0.8) : Color.blue.opacity(0.5))
                        .frame(height: 60)
                        .frame(maxWidth: .infinity)
                        .overlay {
                            Text(editMode ? "Add Student" : "Random Student")
                                .font(.headline)
                                .foregroundColor(editMode ? Color.white : Color.black.opacity(0.6))
                        }
                }
                .sheet(isPresented: $addStudentSheetIsPresented) {
                    VStack(alignment: .leading) {
                        Text("Add Student")
                            .font(.system(size: 45, weight: .semibold))
                            .padding()
                        Text("Name")
                            .font(.system(size: 30, weight: .medium))
                            .padding()
                        TextField("Add name here...", text: $textFieldText)
                            .font(.system(size: 30, weight: .medium))
                            .padding()
                        Text("Number of Points")
                            .font(.system(size: 30, weight: .medium))
                            .padding()
                        Picker("Number of Points", selection: $editNumPoints) {
                            ForEach(0..<50) { num in
                                Text("\(num)")
                            }
                        }
                        Button {
                            if !textFieldText.isEmpty {
                                classroom.people.append(Person(name: textFieldText, points: editNumPoints))
                                addStudentSheetIsPresented.toggle()
                                textFieldText = ""
                                changeColorsAfterPicked()
                            }
                        } label: {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(LinearGradient(gradient: Gradient(colors: [.purple, .blue]), startPoint: .topLeading, endPoint: .bottomTrailing))
                                .frame(height: 200)
                                .overlay {
                                    Text("Add Student")
                                        .foregroundColor(.white)
                                        .font(.system(size: 25, weight: .medium))
                                }
                                .padding()
                        }
                    }
                }
                
                Button {
                    if classroom.people.isEmpty {
                        isEmptyAlert = true
                    } else if editMode {
                        classroom.classroomDeleteStudentMode.toggle()
                        if classroom.classroomDeleteStudentMode {
                            for index in 0..<classroom.people.count {
                                classroom.people[index].color = .red
                            }
                        } else {
                            changeColorsAfterPicked()
                        }
                    } else {
                        var peopleWithLeastPoints: [Int] = []
                        let leastPoints: Int = classroom.people.sorted(by: { $0.points < $1.points }).first?.points ?? 0
                        for index in 0..<classroom.people.sorted(by: { $0.points < $1.points }).count {
                            if classroom.people[index].points == leastPoints {
                                peopleWithLeastPoints.append(index)
                            }
                        }
                        
                        let randomInt = Int.random(in: 0..<peopleWithLeastPoints.count)
                        classroom.people[peopleWithLeastPoints[randomInt]].points += 1
                        classroom.lastCalled = classroom.people[peopleWithLeastPoints[randomInt]].name
                        changeColorsAfterPicked()
                    }
                } label: {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(editMode ? Color.orange.opacity(0.8) : Color.blue.opacity(0.5))
                        .frame(height: 60)
                        .frame(maxWidth: .infinity)
                        .overlay {
                            Text(editMode ? "Delete student" : "Weighted Random")
                                .font(.headline)
                                .foregroundColor(editMode ? Color.white : Color.black.opacity(0.6))
                        }
                }
            }
            
            HStack {
                Button {
                    withAnimation(.spring()) {
                        editMode.toggle()
                    }
                } label: {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(editMode ? Color.orange.opacity(0.8) : Color.blue.opacity(0.5))
                        .frame(height: 60)
                        .frame(maxWidth: .infinity)
                        .overlay {
                            Text("Edit")
                                .font(.headline)
                                .foregroundColor(editMode ? Color.white : Color.black.opacity(0.6))
                        }
                }
                
                Button {
                    if classroom.people.isEmpty {
                        isEmptyAlert = true
                    } else if editMode {
                        if size < UIScreen.main.bounds.width / 3 {
                            size += 20
                        } else {
                            size = UIScreen.main.bounds.width / 7
                        }
                    } else {
                        statsSheetIsPresented.toggle()
                    }
                } label: {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(editMode ? Color.orange.opacity(0.8) : Color.blue.opacity(0.5))
                        .frame(height: 60)
                        .frame(maxWidth: .infinity)
                        .overlay {
                            Text(editMode ? "Change size" : "Stats")
                                .font(.headline)
                                .foregroundColor(editMode ? Color.white : Color.black.opacity(0.6))
                                .sheet(isPresented: $statsSheetIsPresented) {
                                    statsSheet
                                }
                        }
                }
            }
        }
        .alert("Please create students first (Edit -> Add Student)", isPresented: $isEmptyAlert) {
            Button("OK", role: .cancel) { }
        }
    }
    
    func changeColorsAfterPicked() {
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
    
    var statsSheet: some View {
        VStack {
            Text("Statistics for \(classroom.title)")
                .font(.title)
                .fontWeight(.semibold)
                .foregroundColor(.black)
            
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Average: \(Double(classroom.getTotalPoints()) / Double(classroom.people.count))")
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundColor(.black)
                    Text("Median: \(classroom.getMedian())")
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundColor(.black)
                    Text("Mode: \(classroom.getMode().map { String($0) }.joined(separator: ", "))")
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundColor(.black)
                    Text("Range: \(classroom.people.sorted(by: { $0.points < $1.points }).first?.points ?? 0) - \(classroom.people.sorted(by: { $0.points > $1.points }).first?.points ?? 0)")
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundColor(.black)
                }
                
                ForEach(classroom.people.sorted(by: { $0.points > $1.points }), id: \.self) { person in
                    HStack {
                        Text(person.name)
                            .font(.headline)
                            .fontWeight(.medium)
                            .foregroundColor(.black)
                        
                        Spacer()
                        
                        RoundedRectangle(cornerRadius: 5)
                            .frame(width: UIScreen.main.bounds.width / CGFloat(classroom.getTotalPoints() ) * CGFloat(person.points), height: 50)
                            .overlay {
                                Text("\(person.points)")
                                    .foregroundColor(Color.white)
                            }
                    }
                }
            }
        }
        .padding()
    }
}

struct ClassroomView_Previews: PreviewProvider {
    static var previews: some View {
        ClassroomView(classroom: ClassesSingleton.classesShared.classes.first ?? Classroom(title: "none", people: []))
            .previewInterfaceOrientation(.portrait)
    }
}
