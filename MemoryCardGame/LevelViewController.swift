//
//  LevelViewController.swift
//  MemoryCardGame
//
//  Created by תומר בסלו on 15.4.2018.
//  Copyright © 2018 תומר בסלו. All rights reserved.
//

import UIKit

class LevelViewController: UIViewController {
    public var userName:String = ""
    var difficulty:String = ""
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var LabelOfDifficulty: UILabel!
    @IBOutlet weak var StartButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(userName != ""){
            userLabel.text="Hello " + userName
        }
        
        else{
            userLabel.text = "Hello Guest"
            
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func EasyGame(_ sender: Any) {
        LabelOfDifficulty.text = "Easy Selected"
        StartButton.isEnabled=true
    }
    @IBAction func NormalGame(_ sender: Any) {
        LabelOfDifficulty.text = "Normal Selected"
         StartButton.isEnabled=true
    }
    @IBAction func HardGame(_ sender: Any) {
        LabelOfDifficulty.text = "Hard Selected"
        StartButton.isEnabled=true
    }
    @IBAction func StartGame(_ sender: Any) {
        performSegue(withIdentifier: "StartGame", sender: Any?.self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let gameViewController = segue.destination as?  GameViewController{
            gameViewController.difficulty=LabelOfDifficulty.text!
            
        }
    }
}
