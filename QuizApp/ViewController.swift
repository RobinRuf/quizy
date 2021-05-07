//
//  ViewController.swift
//  QuizApp
//
//  Created by Robin Ruf on 13.12.20.
//

import UIKit

var userDefault = UserDefaults.standard

class ViewController: UIViewController {

    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var answerButton1: UIButton!
    @IBOutlet weak var answerButton2: UIButton!
    @IBOutlet weak var answerButton3: UIButton!
    
    @IBOutlet weak var questionCountLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var progressBarView: UIView!
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var categorieButton: UIButton!
    
    @IBOutlet weak var nextButton: UIButton!
    
    // MARK: - Variablen
    var score = 0
    var questionNumber = 0
    
    var questions = [Question]()
    
    var categoryTag: Int = 0  // Wert kommt vom StartViewController
    
    var answerTag: Int = 0 // Antwort 1,2,3 wird eingespeichert
    var answerButtonTapped: Bool = true  // überprüft, ob eine Antwort gegeben hat und stoppt die weitere Überprüfung der richtigen Antwort, damit der Index des Arrays nicht erhöht wird und wir nicht den Error "Out of Range" erhalten
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Setup Buttons
        setupButton()
        
        // Setup Questions
        switch categoryTag {
        case 1:
            createQuestionObjectsCategoryCity()
        case 2:
            createQuestionObjectsCategoryKnowledge()
        case 3:
            createQuestionObjectsCategoryGermany()
        default:
            createQuestionObjectsCategoryCity() // dieser Fall wird nie eintreten
        }
        
        questionLabel.text = questions[0].questionText
        answerButton1.setTitle(questions[0].answer1, for: .normal)
        answerButton2.setTitle(questions[0].answer2, for: .normal)
        answerButton3.setTitle(questions[0].answer3, for: .normal)
        
        // UI einrichten
        // questionCountLabel.text = "1 / \(questions.count)"
        scoreLabel.text = "Score: 0"
        
    }
    
    // MARK: - Setup Buttons
    
    func setupButton() {
        // Tag vergeben
        answerButton1.tag = 1
        answerButton2.tag = 2
        answerButton3.tag = 3
        
        // Buttons abrunden
        answerButton1.layer.cornerRadius = 25
        answerButton2.layer.cornerRadius = 25
        answerButton3.layer.cornerRadius = 25
        backButton.layer.cornerRadius = 15
        nextButton.layer.cornerRadius = 15
        
        // Button-Rand dicker machen
        answerButton1.layer.borderWidth = 2
        answerButton2.layer.borderWidth = 2
        answerButton3.layer.borderWidth = 2
        backButton.layer.borderWidth = 2
        nextButton.layer.borderWidth = 2
        
        // Button-Rand Farbe ändern
        answerButton1.layer.borderColor = UIColor.black.cgColor // cgColor, weil borderColor vom Typ "cgColor" ist - einfach hinten dran schreiben, wenn man "UIColor" benutzt, um die Randfarbe zu ändern, wegen der Syntax
        answerButton2.layer.borderColor = UIColor.black.cgColor
        answerButton3.layer.borderColor = UIColor.black.cgColor
        backButton.layer.borderColor = UIColor.black.cgColor
        nextButton.layer.borderColor = UIColor.black.cgColor
    }
    
    
    @IBAction func answerButton_Tapped(_ sender: UIButton) {
        
        if answerButtonTapped == true {
            answerTag = sender.tag
            
            let result = checkAnswer(answerTag: answerTag)
            
            if result == true {
                sender.backgroundColor = UIColor(displayP3Red: 0, green: 100 / 255, blue: 0, alpha: 0.8)
            } else {
                sender.backgroundColor = UIColor(displayP3Red: 1, green: 67 / 255, blue: 0, alpha: 0.8)
                let correctTag = questions[questionNumber - 1].correctAnswerTag
                
                switch correctTag {
                case answerButton1.tag: answerButton1.backgroundColor = UIColor(displayP3Red: 0, green: 100 / 255, blue: 0, alpha: 0.8)
                case answerButton2.tag: answerButton2.backgroundColor = UIColor(displayP3Red: 0, green: 100 / 255, blue: 0, alpha: 0.8)
                case answerButton3.tag: answerButton3.backgroundColor = UIColor(displayP3Red: 0, green: 100 / 255, blue: 0, alpha: 0.8)
                default:
                    break
                }
            }
            
        }
        answerButtonTapped = false
    }
    
    func checkAnswer(answerTag: Int) -> Bool {
        if answerTag == questions[questionNumber].correctAnswerTag {
            score += 10
            questionNumber += 1
            return true
        } else {
            questionNumber += 1
            return false
        }
    }
    
    func nextQuestion() {
        if questionNumber < questions.count {
            questionLabel.text = questions[questionNumber].questionText
            answerButton1.setTitle(questions[questionNumber].answer1, for: .normal)
            answerButton2.setTitle(questions[questionNumber].answer2, for: .normal)
            answerButton3.setTitle(questions[questionNumber].answer3, for: .normal)
        } else {
            createRestartAlertBox()
        }
    }
    
    // MARK: - Restart Quiz
    
    func createRestartAlertBox() {
        let alert = UIAlertController(title: "QUIZ BEENDET", message: "Willst du das Quiz neu starten?", preferredStyle: .alert)
        
        let saveHighscoreAction = UIAlertAction(title: "Highscore speichern", style: .default) { (action) in
            self.saveHighscore()
        }
        
        let restartAction = UIAlertAction(title: "Neustart", style: .default) { (action) in
            self.restart()
        }
        
        alert.addAction(saveHighscoreAction)
        alert.addAction(restartAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func saveHighscore() {
        let alert = UIAlertController(title: "Highscore speichern", message: "Name eingeben", preferredStyle: .alert)
        
        var nameTextFieldTask: UITextField = UITextField()
        
        let saveAction = UIAlertAction(title: "Speichern", style: .default) { (saveAction) in
            
            // Name + Score dauerhaft speichern
            if let name = nameTextFieldTask.text {
                let username = name
                let highScore = self.score
                
                userDefault.set(username, forKey: "userName")
                userDefault.set(highScore, forKey: "highScore")
                
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Neustart", style: .default) { (cancelAction) in
            self.restart()
        }
        
        
        
        alert.addTextField { (nameTextField) in
            nameTextField.placeholder = "name eintippen"
            nameTextFieldTask = nameTextField
        }
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func restart() {
        questionNumber = 0
        score = 0
        questionCountLabel.text = "1 / \(questions.count)"
        nextQuestion()
    }
    
    // MARK: - Update UI
    
    func updateUI() {
        scoreLabel.text = String("Score: \(score)")
        questionCountLabel.text = String("\(questionNumber + 1) / \(questions.count)")
        
        let widthIphone = self.view.frame.size.width
        let widthProgressBar = Int(widthIphone) / questions.count
        
        progressBarView.frame.size.width = CGFloat(widthProgressBar) * CGFloat(questionNumber + 1)
    }
    
    @IBAction func backButton_Tapped(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextButton_Tapped(_ sender: UIButton) {
        if answerTag > 0 {
            nextQuestion()
            updateUI()
            answerTag = 0
            answerButtonTapped = true
            answerButton1.backgroundColor = UIColor(displayP3Red: 150 / 255, green: 173 / 255, blue: 198 / 255, alpha: 0.8)
            answerButton2.backgroundColor = UIColor(displayP3Red: 150 / 255, green: 173 / 255, blue: 198 / 255, alpha: 0.8)
            answerButton3.backgroundColor = UIColor(displayP3Red: 150 / 255, green: 173 / 255, blue: 198 / 255, alpha: 0.8)
        } else {
            errorNextButton("Bitte Antwort auswählen!")
        }
    }
    
    func errorNextButton(_ message: String) {
        let alert = UIAlertController(title: "WARNUNG", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (action) in }
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - Create category city objetcs
    func createQuestionObjectsCategoryCity() {
        let question1 = Question(text: "Hauptstadt von Deutschland?")
        question1.answer1 = "Berlin"
        question1.answer2 = "Hamburg"
        question1.answer3 = "München"
        question1.correctAnswerTag = 1
        
        let question2 = Question(text: "Hauptstadt von Polen?")
        question2.answer1 = "Berlin"
        question2.answer2 = "Warschau"
        question2.answer3 = "München"
        question2.correctAnswerTag = 2
        
        let question3 = Question(text: "Hauptstadt von Belgien?")
        question3.answer1 = "Berlin"
        question3.answer2 = "Hamburg"
        question3.answer3 = "Brüssel"
        question3.correctAnswerTag = 3
        
        let question4 = Question(text: "Hauptstadt von Össterreich?")
        question4.answer1 = "Wien"
        question4.answer2 = "Hamburg"
        question4.answer3 = "München"
        question4.correctAnswerTag = 1
        
        let question5 = Question(text: "Hauptstadt von Bulgarien?")
        question5.answer1 = "Berlin"
        question5.answer2 = "Sofia"
        question5.answer3 = "München"
        question5.correctAnswerTag = 2
        
        let question6 = Question(text: "Hauptstadt von Ungarn?")
        question6.answer1 = "Budapest"
        question6.answer2 = "Hamburg"
        question6.answer3 = "München"
        question6.correctAnswerTag = 1
        
        let question7 = Question(text: "Hauptstadt von Tschechien?")
        question7.answer1 = "Berlin"
        question7.answer2 = "Prag"
        question7.answer3 = "München"
        question7.correctAnswerTag = 2
        
        questions.append(question1) // Index 0
        questions.append(question2) // Index 1
        questions.append(question3) // Index 2
        questions.append(question4) // Index 3
        questions.append(question5) // Index 4
        questions.append(question6) // Index 5
        questions.append(question7) // Index 6
        
        questionCountLabel.text = "1 / \(questions.count)" // 1 / 7
    }
    
    // MARK: - Create category knowledge objetcs
    func createQuestionObjectsCategoryKnowledge() {
        let question1 = Question(text: "Wo liegt Brüssel?")
        question1.answer1 = "Deutschland"
        question1.answer2 = "Polen"
        question1.answer3 = "Belgien"
        question1.correctAnswerTag = 3
        
        let question2 = Question(text: "Wenn sich etwas leert, dann geht es zur ...?")
        question2.answer1 = "Blende"
        question2.answer2 = "Wende"
        question2.answer3 = "Neige"
        question2.correctAnswerTag = 3
        
        let question3 = Question(text: "Was ist keine Rotwein-Rebsorte?")
        question3.answer1 = "Merlot"
        question3.answer2 = "Chardonny"
        question3.answer3 = "Zinfandel"
        question3.correctAnswerTag = 2
        
        let question4 = Question(text: "Wie hieß der bekannteste Herrscher des Mongolenvolkes?")
        question4.answer1 = "Shir Khan"
        question4.answer2 = "Dchingins Khan"
        question4.answer3 = "Rasputin"
        question4.correctAnswerTag = 2
        
        let question5 = Question(text: "Was ist eine Mamba?")
        question5.answer1 = "Blut trinkende Maus"
        question5.answer2 = "afrikanische Spinne"
        question5.answer3 = "Giftschlange"
        question5.correctAnswerTag = 3
        
        let question6 = Question(text: "Wobei handelt es sich um eine Film-Trilogie?")
        question6.answer1 = "Zurück in die Zukunft"
        question6.answer2 = "Titanic"
        question6.answer3 = "Contact"
        question6.correctAnswerTag = 1
        
        let question7 = Question(text: "Größte Tier aller Zeiten")
        question7.answer1 = "Blauwal"
        question7.answer2 = "Afrikanischer Elefant"
        question7.answer3 = "Tirex"
        question7.correctAnswerTag = 1
        
        questions.append(question1) // Index 0
        questions.append(question2) // Index 1
        questions.append(question3) // Index 2
        questions.append(question4) // Index 3
        questions.append(question5) // Index 4
        questions.append(question6) // Index 5
        questions.append(question7) // Index 6
        
        questionCountLabel.text = "1 / \(questions.count)" // 1 / 7
    }
    
    // MARK: - Create category germany objetcs
    func createQuestionObjectsCategoryGermany() {
        let question1 = Question(text: "Hauptstadt von Deutschland?")
        question1.answer1 = "Berlin"
        question1.answer2 = "Hamburg"
        question1.answer3 = "München"
        question1.correctAnswerTag = 1
        
        let question2 = Question(text: "Einwohnerzahl Deutschlands?")
        question2.answer1 = "7000"
        question2.answer2 = "8300000"
        question2.answer3 = "7000000"
        question2.correctAnswerTag = 2
        
        let question3 = Question(text: "Währung in Deutschland?")
        question3.answer1 = "$"
        question3.answer2 = "Pfung"
        question3.answer3 = "€"
        question3.correctAnswerTag = 3
        
        let question4 = Question(text: "Tag der Deutschen Einheit")
        question4.answer1 = "3. Oktober"
        question4.answer2 = "3. November"
        question4.answer3 = "3. Juli"
        question4.correctAnswerTag = 1
        
        let question5 = Question(text: "Zeitraum des Dreißigjähriger Krieges?")
        question5.answer1 = "1510 - 1540"
        question5.answer2 = "1618 - 1648"
        question5.answer3 = "1603 - 1633"
        question5.correctAnswerTag = 2
        
        let question6 = Question(text: "Anzahl der Bundesländer")
        question6.answer1 = "16"
        question6.answer2 = "15"
        question6.answer3 = "17"
        question6.correctAnswerTag = 1
        
        let question7 = Question(text: "Bevölkerungsreichste Stadt")
        question7.answer1 = "Berlin"
        question7.answer2 = "Hamburg"
        question7.answer3 = "München"
        question7.correctAnswerTag = 1
        
        questions.append(question1) // Index 0
        questions.append(question2) // Index 1
        questions.append(question3) // Index 2
        questions.append(question4) // Index 3
        questions.append(question5) // Index 4
        questions.append(question6) // Index 5
        questions.append(question7) // Index 6
        
        questionCountLabel.text = "1 / \(questions.count)" // 1 / 7
    }

}

