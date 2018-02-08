//
//  ViewController.swift
//  TDCrossword
//
//  Created by Isols Group on 25/01/18.
//  Copyright © 2018 dahiyaboy. All rights reserved.
//

import UIKit

class ViewController: UIViewController , UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{

    @IBOutlet weak var cwCollectionView: UICollectionView!
    
    //MARK:- Properties
    //MARK:-
    private let kCellIdentifier = "CWCell"
    var arrStructureData : [CWWordStructure] = []
    
    var arrWordList : [CWWordList] = []
    
    var arrWordsHorizontal : [CWWordList] = []
    var arrWordsVertical : [CWWordList] = []
    var arrWordTagPosition : [CWWordTagPosition] = []
    
    var totRows : Int = 0
    var totCols : Int = 0
    
    var kBackgroundColor  =  UIColor.lightGray
    
    var kGrayColor : UIColor = UIColor(colorLiteralRed: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0)
    var kRedColor : UIColor = UIColor(colorLiteralRed: 246.0/255.0, green: 233.0/255.0, blue: 237.0/255.0, alpha: 1.0)
    var kGreenColor : UIColor = UIColor(colorLiteralRed: 234.0/255.0, green: 249.0/255.0, blue: 248.0/255.0, alpha: 1.0)
    
    //MARK:- VC Cycles
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        self.cwCollectionView.backgroundView?.backgroundColor = kBackgroundColor
        self.cwCollectionView.backgroundColor = kBackgroundColor
        
        let aDict = self.getJsonData()
        self.setStructure(arrData: aDict["list"] as! [Any])
        self.setWordList(aDict["word_list"] as! [Any])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
         AppUtility.lockOrientation(.portrait)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    //MARK:- Methods
    //MARK:-
    func getJsonData() -> [String: Any] {
        let aFilePath = Bundle.main.path(forResource: "CrossWord", ofType: "json")
        let aContent = NSData(contentsOfFile: aFilePath!)
        let ajson = try? JSONSerialization.jsonObject(with: aContent! as Data, options: [])
        
        return ajson as! [String : Any]
    }

    func setStructure(arrData : [Any]){
        
        var aIndex : Int = 0
        self.totRows = arrData.count
        
        for aitem in arrData{
            let aStrItem = aitem as! String
            self.totCols = aStrItem.characters.count
            
            for aChar in aStrItem.characters{
                let aword : CWWordStructure = CWWordStructure(char: String(aChar), index: aIndex)
                self.arrStructureData.append(aword)
                aIndex += 1
                
            }
        }
    }
    
    func setWordList(_ arrLists : [ Any])  {
        
        for aitem in arrLists{
            let aDict = aitem as! [String : Any]
            let aDictPos = aDict["position"] as! [String : Int]
            
            let aDirec : CWDirection!
            
            if aDict["direction"] as! String == CWDirection.horizontal.rawValue {
                aDirec = CWDirection(rawValue: CWDirection.horizontal.rawValue)
            }
            else{
                aDirec = CWDirection(rawValue: CWDirection.vertical.rawValue)
            }
            
            let aWord = CWWordList(word: aDict["word"] as! String,
                                   direction: aDirec,
                                   word_tag: aDict["word_tag"] as! Int,
                                   hint: aDict["description"] as! String,
                                   position: CWPosition(row: aDictPos["row"]! ,
                                                        col: aDictPos["col"]! ))
            
            let aWordIndex = (aDictPos["row"]! * totRows + aDictPos["col"]! )
            
            let aPos = CWWordTagPosition(tag    : aDict["word_tag"] as! Int,
                                         index  : aWordIndex)
            
            self.arrWordTagPosition.append(aPos)
            self.arrWordList.append(aWord)
        }
        
        self.splitArray(self.arrWordList)
    }
    
    func splitArray(_ arrLists : [ CWWordList])  {
        
        for aItem in arrLists {
            
            if aItem.direction?.rawValue  == CWDirection.horizontal.rawValue{
                self.arrWordsHorizontal.append(aItem)
            }
            else if aItem.direction?.rawValue  == CWDirection.vertical.rawValue{
                self.arrWordsVertical.append(aItem)
            }
        }
        let aHor = self.sortArray(array: arrWordsHorizontal)
        let aVer = self.sortArray(array: arrWordsVertical)
        
        arrWordsHorizontal.removeAll()
        arrWordsVertical.removeAll()
        
        arrWordsHorizontal  = aHor
        arrWordsVertical = aVer
    }
    
    func sortArray(array : [CWWordList]) -> [CWWordList] {
        
        let arrSorted = array.sorted { (first, second) -> Bool in
            if first.word_tag! < second.word_tag!{
                return true
            }
            else {
                return false
            }
        }
        return arrSorted
    }
    
    func getWordTagOPostionFor(index : Int) -> Int?{
        
        for aWordPos in arrWordTagPosition {
            if aWordPos.index == index{
                return aWordPos.tag
            }
        }
        
        return nil
    }
    
    
    //MARK:- CV Flowlayout
    //MARK:-
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        let aWidth = collectionView.frame.size.width / CGFloat(self.totCols)
        let aheight = collectionView.frame.size.height / CGFloat(self.totRows)
        
        return CGSize(width: aWidth, height: aheight)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    //MARK:- Delegates
    //MARK:-
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return arrStructureData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellIdentifier, for: indexPath) as! CWCell
        
        cell.backgroundColor = kBackgroundColor
        
        let aStrChar = self.arrStructureData[indexPath.row].char
        cell.lblIndexNumber.isHidden = true
        
        let aWordTagPos = self.getWordTagOPostionFor(index: indexPath.row)
        
        if aWordTagPos != nil{
            cell.lblIndexNumber.isHidden = false
            cell.lblIndexNumber.text = "\(aWordTagPos!)"
        }
        
        if aStrChar == "-"{
            cell.tfWord.isHidden = true
        }
        else{
            cell.tfWord.backgroundColor = kGreenColor
            cell.tfWord.text = ""
        }
        return cell
    }

    
}

extension ViewController : UITableViewDelegate, UITableViewDataSource{
    //MARK:- UITableViewDelegate
    //MARK:-
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            
            return "Across"
        }
        else {
            return "Down"
        }
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if section == 0{
            return arrWordsHorizontal.count
        }
        else {
            return arrWordsVertical.count
        }
        
        
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CWTblCell") as! CWTblCell
        
        if indexPath.section == 0{
            
            let aWord = self.arrWordsHorizontal[indexPath.row]
            cell.lblDescption.text = "\(aWord.word_tag!). \(aWord.hint!)"
            
        }
        else {
            
            let aWord = self.arrWordsVertical[indexPath.row]
            cell.lblDescption.text = "\(aWord.word_tag!). \(aWord.hint!)"
        }
        
        return cell
        
    }
    
}
