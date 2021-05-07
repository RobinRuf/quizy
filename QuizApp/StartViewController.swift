//
//  StartViewController.swift
//  QuizApp
//
//  Created by Robin Ruf on 15.12.20.
//

import UIKit

class StartViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var highscoreButton: UIButton!
    @IBOutlet weak var highscoreLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet weak var categorieButton: UIButton!
    @IBOutlet weak var cityButton: UIButton!
    @IBOutlet weak var knowledgeButton: UIButton!
    @IBOutlet weak var germanyButton: UIButton!
    
    var tag: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - Setup Buttons
        highscoreButton.backgroundColor = UIColor(white: 1.0, alpha: 0.8)
        startButton.backgroundColor = UIColor(white: 1.0, alpha: 0.8)
        categorieButton.backgroundColor = UIColor(white: 1.0, alpha: 0.8)
        cityButton.backgroundColor = UIColor(white: 1.0, alpha: 0.8)
        knowledgeButton.backgroundColor = UIColor(white: 1.0, alpha: 0.8)
        germanyButton.backgroundColor = UIColor(white: 1.0, alpha: 0.8)
        
        highscoreButton.layer.cornerRadius = 25
        startButton.layer.cornerRadius = 25
        categorieButton.layer.cornerRadius = 25
        cityButton.layer.cornerRadius = 25
        knowledgeButton.layer.cornerRadius = 25
        germanyButton.layer.cornerRadius = 25
       
        
        // Button-Rand dicker machen
        highscoreButton.layer.borderWidth = 2
        startButton.layer.borderWidth = 2
        categorieButton.layer.borderWidth = 2
        cityButton.layer.borderWidth = 2
        knowledgeButton.layer.borderWidth = 2
        germanyButton.layer.borderWidth = 2
       
        
        // Button-Rand Farbe ändern
        highscoreButton.layer.borderColor = UIColor.black.cgColor
        startButton.layer.borderColor = UIColor.black.cgColor
        categorieButton.layer.borderColor = UIColor.black.cgColor
        cityButton.layer.borderColor = UIColor.black.cgColor
        knowledgeButton.layer.borderColor = UIColor.black.cgColor
        germanyButton.layer.borderColor = UIColor.black.cgColor
        
        // Highscore Label und Kategorie-Buttons unsichtbar machen
        highscoreLabel.alpha = 0.0
        cityButton.alpha = 0.0
        knowledgeButton.alpha = 0.0
        germanyButton.alpha = 0.0

        
    }
    
    var highscoreShow = false
    
    // MARK: - Show Highscore
    @IBAction func highscoreButton_Tapped(_ sender: UIButton) {
        UIView.animate(withDuration: 1) {
            
            if self.highscoreShow == false {
                self.highscoreLabel.alpha = 1.0
                self.highscoreShow = true
            } else {
                self.highscoreLabel.alpha = 0.0
                self.highscoreShow = false
            }
            
        }
        
        // Laden der permanent gespeicherten Highscore-Daten
        let score = userDefault.integer(forKey: "highScore")
        if let name = userDefault.object(forKey: "userName") as? String {
            highscoreLabel.text = "Name: \(name) Punkte: \(score)"
        }
      }
    
    // MARK: - Start Game
    @IBAction func startButton_Tapped(_ sender: UIButton) {
        
        if tag == 1 || tag == 2 || tag == 3 {
            self.performSegue(withIdentifier: "startgame", sender: nil)
        } else {
            categoryErrorAlert(message: "Bitte eine Kategorie auswählen!")
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "startgame" {
            let destVC = segue.destination as! ViewController
            destVC.categoryTag = tag
        }
    }
    
    // MARK: - Error Alert Category
    func categoryErrorAlert(message: String) {
        let alert = UIAlertController(title: "ACHTUNG", message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(alertAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Choose Categorie
    
    @IBAction func categorieButton_Tapped(_ sender: UIButton) {
        
        if self.cityButton.alpha == 0.0 && self.knowledgeButton.alpha == 0.0 && self.germanyButton.alpha == 0.0 {
            UIView.animate(withDuration: 0.5) {
                self.cityButton.alpha = 1.0
            } completion: { (true) in
                UIView.animate(withDuration: 0.5) {
                    self.knowledgeButton.alpha = 1.0
                } completion: { (true) in
                    UIView.animate(withDuration: 0.5) {
                        self.germanyButton.alpha = 1.0
                    }
                }
            }
        } else {
            UIView.animate(withDuration: 1.0) {
                self.cityButton.alpha = 0.0
                self.knowledgeButton.alpha = 0.0
                self.germanyButton.alpha = 0.0
            }
        }
    }
    
    @IBAction func chooseCategorieButtons_Tapped(_ sender: UIButton) {
        
        tag = sender.tag
        
        startButton.setTitleColor(UIColor .white, for: .normal)
        startButton.clipsToBounds = true
        
        if tag == 1 {
            startButton.setBackgroundImage(UIImage(named: "city"), for: .normal)
        } else if tag == 2 {
            startButton.setBackgroundImage(UIImage(named: "wissen"), for: .normal)
        } else if tag == 3 {
            startButton.setBackgroundImage(UIImage(named: "deutschland"), for: .normal)
        }
        
    }
    
}
