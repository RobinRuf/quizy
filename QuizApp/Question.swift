//
//  Question.swift
//  QuizApp
//
//  Created by Robin Ruf on 14.12.20.
//

import Foundation

class Question {
    var questionText: String = ""
    var answer1: String = ""
    var answer2: String = ""
    var answer3: String = ""
    var correctAnswerTag: Int = 0
    
    init(text: String) {
        self.questionText = text
    }
}
