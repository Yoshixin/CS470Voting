//
//  ChatMessageCollectionCell.swift
//  CS470Voting
//
//  Created by Joe Mogannam on 5/7/17.
//  Copyright © 2017 student. All rights reserved.
//

import UIKit





class ChatMessageCollectionCell: UICollectionViewCell {
    let textView:  UITextView = {
        let tv = UITextView()
        tv.text = "someText"
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.translatesAutoresizingMaskIntoConstraints = false
        
        // since texView always have background color of white
        // to allow our blue buble background color
        // we need to fore the textLabe background color to clear
        tv.backgroundColor = UIColor.clear
        tv.textColor = UIColor.white
        return tv
    }()
    
    static let blueColor =  UIColor(red: 0/255, green: 137/255, blue: 255/255, alpha: 1)
    static let grayColor = UIColor(red: 240/255,
                                   green: 240/255, blue: 240/255, alpha: 1)
    
    let bubbleView:  UIView = {
        let view = UIView()
        
        
        view.backgroundColor = blueColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true// if not set to true corner rounding dosent take effect
        
        
        
        return view
    }()
    
  
    
    
    
    
    
    var bubleWIdthAnchor :  NSLayoutConstraint
  /*
    var BlueOrGrayCell = -1
    
    func setWhich(_ which: int) {
        BlueOrGrayCell = which
    }
 */
    
    
    
    override init(frame: CGRect){
        
        
        
        bubleWIdthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubleWIdthAnchor.isActive = true
        let width = frame.width/2
        let height = frame.height/2
        
        
        

        
        
        /*zeroWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 0)
        //zeroWidthAnchor.isActive = true
     
        fullWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: width)
        //fullWidthAnchor.isActive = true
         */
        
        super.init(frame: frame)
        //backgroundColor = UIColor.red
        
        
       
        
        // an image use to pin it to the left of the screen,
        // so I can use it as an anchor to pin the gray buble to the right
        //of it
        var tempIMAGE = UIImageView()
        
        
        addSubview(bubbleView) // add blue background to this users messages sent out
        addSubview(textView)
        addSubview(tempIMAGE)
        
        // put backgound blue buble view in our text view
        
        
        bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        
        
        
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor, constant: 8).isActive = true
        
        
        
        
        
        // set x,y,w,h
        // pin x to right side
        //textView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
        //textView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        textView.heightAnchor.constraint(equalTo: self.heightAnchor, constant: 8).isActive = true
        
        
        
        
        /*// anchor the tempImage
        tempIMAGE.backgroundColor = UIColor.black
        
        tempIMAGE.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        tempIMAGE.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        tempIMAGE.rightAnchor.constraint(equalTo: self.centerXAnchor, constant: -20).isActive = true
        textView.widthAnchor.constraint(equalToConstant:50).isActive = true
        tempIMAGE.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
         */
        
        
       // self.backgroundColor = UIColor.red
       
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("Init(coder:) has not been implemented")
 
    }

}
    
    

