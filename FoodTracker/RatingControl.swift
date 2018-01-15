//
//  RatingControl.swift
//  FoodTracker
//
//  Created by Wei Li on 7/1/18.
//  Copyright © 2018 Wei Li. All rights reserved.
//

import UIKit

@IBDesignable class RatingControl: UIStackView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    //MARK: Properties
    private var ratingButtons = [UIButton]()
    var rating = 0 {
        didSet{
            updateButtonSelectionState()
        }
    }
    
    @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0){
        didSet {
            setupButtons()
        }
    }
    @IBInspectable var starCount: Int = 5{
        didSet {
            setupButtons()
        }
    }
    
    
    //MARK: Initialzation
    override init(frame: CGRect){
        super.init(frame: frame)
        setupButtons()
    }
    
    
    required init(coder: NSCoder){
        super.init(coder: coder)
        setupButtons()
    }
    //MARK: Button Action
    @objc func ratingButtonTapped(button: UIButton){
//        print("Button Pressed~")
        guard let index = ratingButtons.index(of: button) else {
            fatalError("the button \(button) is not in the rating buttons array: \(ratingButtons)")
        }
        
        // calculate the rating of selected button
        let selectedRating = index + 1
        
        // reset rating if select the current rating
        if selectedRating == rating{
            rating = 0
        } else {
            rating = selectedRating
        }
    }
    
    
    //MARK: Private Methods
    private func setupButtons(){
        // clear any existing buttons
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        ratingButtons.removeAll()
        
        // load button image
        let bundle = Bundle(for: type(of: self))
        let filledStar = UIImage(named: "filledStar", in: bundle, compatibleWith: self.traitCollection)
        let emptyStar = UIImage(named: "emptyStar", in: bundle, compatibleWith: self.traitCollection)
        let highlightedStar = UIImage(named: "highlightedStar", in: bundle, compatibleWith: self.traitCollection)
        
        
        
        for index in 0..<starCount {
            // create the button
            let button = UIButton()
//            button.backgroundColor = UIColor.red
            
            // set the button images
            button.setImage(emptyStar, for: .normal)
            button.setImage(filledStar, for: .selected)
            button.setImage(highlightedStar, for: .highlighted)
            button.setImage(highlightedStar, for: [.highlighted,.selected])
            
            // add constraints
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            
            // set the accessibility label
            button.accessibilityLabel = "Set \(index) star rating"
            
            
            // setup button actions
            button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(button:)), for: .touchUpInside)
            
            // add button to the stack
            addArrangedSubview(button)
            
            // add a new button to the rating button array
            ratingButtons.append(button)
        }
        
        updateButtonSelectionState()
    }
    
    private func updateButtonSelectionState(){
        for (index, button) in ratingButtons.enumerated(){
            // if the index of the button is less than the rating, the button should be seleceted
            button.isSelected = index < rating
            
            // set the hint string for the currently selected star
            let hintString: String?
            if rating == index + 1{
                hintString = "Tap to reset the rating to zero"
            } else {
                hintString = nil
            }
            
            // calculate the value string
            let valueString: String?
            switch (rating){
            case 0:
                valueString = "No rating set"
            case 1:
                valueString = "1 star set"
            default:
                valueString = "\(rating) stars set"
            }
            
            // assign the hint string and value string
            button.accessibilityHint = hintString
            button.accessibilityValue = valueString
        }
        
        
    }
    
    
}
