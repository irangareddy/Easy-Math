//
//  ContentView.swift
//  Easy Math
//
//  Created by RANGA REDDY NUKALA on 05/09/20.
//

import SwiftUI

let kWidth = UIScreen.main.bounds.size.width



struct Shake: GeometryEffect {
    var travelDistance: CGFloat = 10
    var shakesPerUnit = 3
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX:
            travelDistance * sin(animatableData * .pi * CGFloat(shakesPerUnit)),
            y: 0))
    }
}

struct ContentView: View {
    
    @State private var answers: [Int] = [].shuffled()
    @State private var levelSelected: Int = 2
    
    @State private var firstNumber: Int = 3
    @State private var secondNumber: Int = 6
    
    @State private var correctAnswer: Int = 18
    @State private var questionNo: Int = 1
    @State private var isWrong = false
    @State private var maxQuestions: Int = 10
    
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var scoreMessage = ""
    
    


    
    
    func getRandom() -> Int {
        Int.random(in: 1...20) * Int.random(in: 1...20)
    }
    
    func addAnswers() {
        for _ in 0...2 {
            answers.append(getRandom())
        }
        answers.append(correctAnswer)
    }
    

    var body: some View {
            VStack {
                HStack {
                    HStack(spacing: 2) {
                        ForEach(0..<maxQuestions) { index in
                            Rectangle()
                                .foregroundColor(index < questionNo ? Color(#colorLiteral(red: 0.3450980392, green: 0.8, blue: 0.007843137255, alpha: 1)) : Color.secondary.opacity(0.3))
                          }
                        }
                        .frame(maxHeight: 10)
                        .clipShape(Capsule())
                }.padding()
                Spacer()
                HStack(spacing: 10) {
                    Text("\(firstNumber)")
                    Image(systemName: "multiply")
                        .font(.system(size: 60, weight: .bold))
                    Text("\(secondNumber)")
                }.font(.system(size: 80, weight: .heavy))
                Spacer()
                if(answers != []) {
                    HStack {
                        ForEach(0..<answers.count/2, id: \.self) { num in
                            Button(action: {
                                if questionNo >= maxQuestions {
                                    questionNo = 1
                                    gameOver()
                                    score = 0
                                } else {
                                    questionNo+=1
                                    withAnimation(Animation.default) {
                                        checkAnswer(index: num)
                                    }
                                }
                                
                            }, label: {
                                
                                Text("\(answers[num])")
                                    .font(.system(size: 60, weight: .heavy))
                                    .frame(width: kWidth/2.5, height: kWidth/2.5, alignment: .center)
                                    .foregroundColor(Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)))
                                    .background(RoundedRectangle(cornerRadius: 16)
                                                    .foregroundColor(Color(#colorLiteral(red: 0.3450980392, green: 0.8, blue: 0.007843137255, alpha: 1))))
                                
                                
                                   
                            }).modifier(isWrong ? Shake(animatableData: CGFloat(4)) : Shake(animatableData: CGFloat(0)))
                            .padding(8)
                            
                        }
                        }
                    HStack {
                        ForEach(answers.count/2..<answers.count, id: \.self) { num in
                            Button(action: {
                                if questionNo >= maxQuestions {
                                    questionNo = 1
                                    gameOver()
                                    score = 0
                                } else {
                                    questionNo+=1
                                    withAnimation(Animation.default) {
                                        checkAnswer(index: num)
                                    }
                                }
                            }, label: {
                                Text("\(answers[num])")
                                    .font(.system(size: 60, weight: .heavy))
                                    .frame(width: kWidth/2.5, height: kWidth/2.5, alignment: .center)
                                    .foregroundColor(Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)))
                                    .background(RoundedRectangle(cornerRadius: 16)
                                                    .foregroundColor(Color(#colorLiteral(red: 0.3450980392, green: 0.8, blue: 0.007843137255, alpha: 1))))
                            })
                            .modifier(isWrong ? Shake(animatableData: CGFloat(4)) : Shake(animatableData: CGFloat(0))).padding(8)
                            
                            
                        }
                    }
                
                }
                
            }.onAppear(perform: {
                getQuestion()
                
            })
            .alert(isPresented: $showingScore) {
                        Alert(title: Text(scoreTitle), message: Text(scoreMessage),
                              primaryButton:.default(Text("Continue")) {
                            getQuestion()
                                score = 0
                              },secondaryButton: .default(Text("Cancel")) {
                                
                                  })
            }
    }
    
    func checkAnswer(index: Int) {
        if answers[index] == correctAnswer {
            score+=1
        } else {
            isWrong.toggle()
            if(score < 0) {
                score-=1
            }
        }
        getQuestion()
    }
    
   
    
     func getQuestion() {
        answers.removeAll()
        firstNumber = Int.random(in: 1...20)
        secondNumber = Int.random(in: 1...20)
        correctAnswer = firstNumber * secondNumber
        addAnswers()
        answers = answers.shuffled()
    }
    
    
    func gameOver() {
        showingScore = true
        scoreTitle = "Game Over"
        scoreMessage = "Your Score is \(score)"
    }
    
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


// MARK:- Upcoming Features

/*
 
 enum Level: String, CaseIterable {
     case easy = "Easy"
     case medium = "Medium"
     case hard = "Hard"
     case extreme = "Extreme"
 }

func getMaxQuestions() -> Int {
    let level =  levelSelected
    
    switch level {
    case 0:
        print("here level0")
        return 5
    case 1:
        print("here level1")
        return 8
    case 2:
        print("here level2")
        return 12
    case 3:
        print("here level3")
        return 15
    default:
        print("in default")
        return 5
    }
}

 
 Picker(selection: $levelSelected,label: Text("")) {
     ForEach(0..<Level.allCases.count, id: \.self) { index in
         Text("\(Level.allCases[index].rawValue)").tag(Int(Level.allCases[index].rawValue))
     }
 }.pickerStyle(SegmentedPickerStyle()).padding()
 .font(.largeTitle)
 
 
 */
