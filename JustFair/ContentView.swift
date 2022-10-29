//
//  ContentView.swift
//  JustFair
//
//  Created by Andrew Li on 10/21/22.
//

import SwiftUI

struct ContentView: View {
    
    @State private var plusSheetIsPresented: Bool = false
    @State private var textFieldText: String = ""
    
    func removeRows(at offsets: IndexSet) {
        ClassesSingleton.classesShared.classes.remove(atOffsets: offsets)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    List {
                        ForEach(ClassesSingleton.classesShared.classes, id: \.self) { classroom in
                            NavigationLink {
                                ClassroomView(classroom: classroom)
                            } label: {
                                Text(classroom.title)
                                    .font(.title2)
                                    .fontWeight(.medium)
                            }
                        }
                        .onDelete(perform: removeRows)
                        
                    }
                    LinearGradient(gradient: Gradient(colors: [Color(red: 0.51, green: 0.12, blue: 0.93), .blue]), startPoint: .leading, endPoint: .trailing)
                        .mask(Text("JustFair").font(.system(size: 70, weight: .bold)))
                        .offset(y: -UIScreen.main.bounds.height * 0.41)
                        .frame(height: 50, alignment: .top)
                }
                
                Button {
                    plusSheetIsPresented.toggle()
                } label: {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(red: 192, green: 192, blue: 192))
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .padding()
                        .shadow(color: .black.opacity(0.5), radius: 5, x: -5, y: +5)
                        .overlay {
                            Image(systemName: "plus")
                        }
                }
                .sheet(isPresented: $plusSheetIsPresented) {
                    VStack(alignment: .leading) {
                        Text("New Classroom")
                            .font(.system(size: 45, weight: .semibold))
                            .padding()
                        Text("Name")
                            .font(.system(size: 30, weight: .medium))
                            .padding()
                        TextField("Add name here...", text: $textFieldText)
                            .font(.system(size: 30, weight: .medium))
                            .padding()
                        Button {
                            if !textFieldText.isEmpty {
                                ClassesSingleton.classesShared.classes.append(Classroom(title: textFieldText, people: []))
                                plusSheetIsPresented = false
                                textFieldText = ""
                            }
                        } label: {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(LinearGradient(gradient: Gradient(colors: [.purple, .blue]), startPoint: .topLeading, endPoint: .bottomTrailing))
                                .frame(height: 200)
                                .overlay {
                                    Text("Submit")
                                        .foregroundColor(.white)
                                        .font(.system(size: 25, weight: .medium))
                                }
                                .padding()
                        }
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.portrait)
    }
}

