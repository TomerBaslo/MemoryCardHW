//
//  ViewController.swift
//  MemoryCardGame
//
//  Created by תומר בסלו on 28.3.2018.
//  Copyright © 2018 תומר בסלו. All rights reserved.
//

import UIKit

class GameViewController: UIViewController ,UICollectionViewDelegate,UICollectionViewDataSource{
    @IBOutlet weak var collectionView: UICollectionView!
    var arrayEasy:[String] = ["1","2","3","4","5","6",
                              "1","2","3","4","5","6"]
    var arrayNormal:[String] = ["1","2","3","4","5","6","7","8",
        "1","2","3","4","5","6","7","8"]
    var arrayHard:[String] = ["1","2","3","4","5","6","7","8","9","10",
        "1","2","3","4","5","6","7","8","9","10"]
    var usedArray:[String] = []
    public var difficulty:String=""
    var selectedFirst:Bool = false
    var selectedSecond:Bool = false
    var selectedIndex: IndexPath = IndexPath()
    var attempts: Int = 0
    var matches: Int = 0
    var gameTime: Int = 60
    var timer:Timer = Timer()
    var isTimeRunning:Bool = false
    @IBOutlet weak var gameTimeLabel: UILabel!
    var firstAttempt:Bool = true
    var gameOver:Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(difficulty == "Hard Selected"){
            setLayout(widthDiv: 6, heightDiv: 8)
        }else if(difficulty == "Normal Selected"){
            setLayout(widthDiv: 5, heightDiv: 6.5)
        }else{
            setLayout(widthDiv: 5, heightDiv: 6)
        }
        
    }

    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setLayout(widthDiv:CGFloat, heightDiv:CGFloat){
        let itemSize = UIScreen.main.bounds.width/widthDiv
        let itemHeight = UIScreen.main.bounds.height/heightDiv
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemSize, height: itemHeight)
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        // Do any additional setup after loading the view, typically from a nib.
        collectionView.collectionViewLayout = layout
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(difficulty == "Hard Selected"){
            usedArray = shuffleArray(array: arrayHard, last: arrayHard.count-1)
        }else if(difficulty == "Normal Selected"){
            usedArray = shuffleArray(array: arrayNormal, last: arrayNormal.count-1)
        }else{
            usedArray = shuffleArray(array: arrayEasy, last: arrayEasy.count-1)
            
        }
        return usedArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardView", for: indexPath) as! CardViewCell
        cell.imageView.image = UIImage(named: "cardback.png")
        cell.picture = UIImage(named: usedArray[indexPath.row]+".png")!
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(gameOver){
            return
        }
        if(selectedSecond){
            return
        }
        if(firstAttempt){
            firstAttempt = false
            runTimer()
        }
        let cell = collectionView.cellForItem(at: indexPath) as! CardViewCell
        if(cell.isShown){
            return
        }
        cell.imageView.image = cell.picture
        cell.imageView.setNeedsDisplay()
        cell.isShown = true
        
        if(!selectedFirst){
            selectedFirst = true
            selectedIndex = indexPath
        }else{
            if(!selectedSecond){
                attempts+=1
                selectedSecond = true
                let selectedCell = collectionView.cellForItem(at: selectedIndex) as! CardViewCell
                if(checkMatch(index1: indexPath.row , index2: selectedIndex.row)){
                    selectedFirst = false
                    selectedSecond = false
                    matches+=1
                    if(matches == usedArray.count/2){
                        //TODO - popup victory
                        self.gameOver = true
                        self.messageBox(messageTitle: "You Win!", messageAlert: "keep up the good work! :)")
                        DispatchQueue.main.asyncAfter(deadline: .now()+3.0, execute: {
                            self.dismiss(animated: true, completion: nil)
                            self.dismiss(animated: true, completion: nil)
                        })
                    }
                    return
                }else{
                    DispatchQueue.main.asyncAfter(deadline: .now()+1.0, execute: {
                        cell.imageView.image = UIImage(named: "cardback.png")
                        cell.imageView.setNeedsDisplay()
                        selectedCell.imageView.image = UIImage(named: "cardback.png")
                        selectedCell.imageView.setNeedsDisplay()
                        cell.isShown = false
                        selectedCell.isShown = false
                        self.selectedFirst = false
                        self.selectedSecond = false
                        if(self.attempts > self.usedArray.count+12){
                           //TODO - popup loss
                        }
                    })
                }
            }
        }
    }
    
    func runTimer(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self ,selector: #selector(updateTimer) ,userInfo: nil, repeats: true)
    }
    @objc func updateTimer(){
        gameTime-=1
        
        if(gameTime == 0){
            //TODO - lose game
            timer.invalidate()
            gameOver = true
            messageBox(messageTitle: "You Lost", messageAlert: "better luck next time")
            DispatchQueue.main.asyncAfter(deadline: .now()+3.0, execute: {
                self.dismiss(animated: true, completion: nil)
                self.dismiss(animated: true, completion: nil)
            })
        }
        
        let hours = Int(gameTime) / 3600
        let minutes = Int(gameTime) / 60 % 60
        let seconds = Int(gameTime) % 60
        
        gameTimeLabel.text = String(format: "%02i:%02i:%02i", hours,minutes,seconds)
    }
    
    func shuffleArray(array:[String], last:Int) -> [String]{
        var arrcopy = array
        var lastindex = last
        while(lastindex > 0){
            let rand = Int(arc4random_uniform(UInt32(last)))
            arrcopy.swapAt(last,rand)
            lastindex-=1
        }
        return arrcopy
    }
    
    func checkMatch(index1: Int , index2: Int) -> Bool{
        if(usedArray[index1] == usedArray[index2]){
            return true
        }
        return false
    }
    
    func messageBox(messageTitle: String, messageAlert: String)
    {
        let alert = UIAlertController(title: messageTitle, message: messageAlert, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) { _ in
            
        }
        
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
}





