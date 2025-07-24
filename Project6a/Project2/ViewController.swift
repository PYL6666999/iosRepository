//
//  ViewController.swift
//  Project2
//
//  Created by Pyl on 2025/7/22.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var button3: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button1: UIButton!
    
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    var times = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        countries += ["estonia","france","germany","ireland","italy","monaco","nigeria","poland","russia","spain","uk","us"]
        

        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor

        askQuestion()
        
        
    }
    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String
        
        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1
        } else {
            title = "Wrong"
            score -= 1
            // 告诉玩家选错了什么旗帜
            let correctCountry = countries[sender.tag].uppercased()
            title += " (That’s the flag of \(correctCountry))"
        }
        times += 1
        if times == 10 {
            let finalAC = UIAlertController(title: "Game Over", message: "Your final score is \(score)", preferredStyle: .alert)
            finalAC.addAction(UIAlertAction(title: "Play Again", style: .default) { [weak self] _ in
                self?.score = 0
                self?.times = 0
                self?.askQuestion()
            })
            present(finalAC, animated: true)
            return
        }
        
            let ac = UIAlertController(title: title, message:
                                        "Your score is \(score)", preferredStyle:.alert)
            ac.addAction(UIAlertAction(title:"Continue",style: .default, handler: askQuestion))
            present(ac, animated:true)
        
    }
    
    func askQuestion(action: UIAlertAction!=nil) {
        countries.shuffle()
        correctAnswer = Int.random(in:0...2)
        title = countries[correctAnswer].uppercased() + "(Score:\(score))"
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
    }


}

