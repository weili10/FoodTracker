//
//  MealViewController.swift
//  FoodTracker
//
//  Created by Wei Li on 7/1/18.
//  Copyright © 2018 Wei Li. All rights reserved.
//

import UIKit
import os.log

class MealViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
//    @IBOutlet weak var mealNameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var meal: Meal?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // handle the text field's user input through delegate callbacks
        nameTextField.delegate = self
        //The self refers to the ViewController class, because it’s referenced inside the scope of the ViewController class definition.
        
        // Set up views if editing an existing Meal.
        if let meal = meal {
            navigationItem.title = meal.name
            nameTextField.text = meal.name
            photoImageView.image = meal.photo
            ratingControl.rating = meal.rating
        }
        
        // Enable the Save button only if the text field has a valid Meal name.
        updateSaveButtonState()
        
        
        
    }

//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //resign the first responder(the fisrt object to respond to events) to hide the keyboard
        textField.resignFirstResponder()
        
        //"true" indicates the system should process the press of Return Key
        return true
    }
    
    // be called after textFieldshouldReturn
    func textFieldDidEndEditing(_ textField: UITextField) {
//        mealNameLabel.text = textField.text
        
        updateSaveButtonState()
        
        navigationItem.title = textField.text
        
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //disable the save button
        saveButton.isEnabled = false
    }
    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // dismiss the picker if the user canceled
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // the info dictionary may contain multiple representations of image, you want to use the original
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else { fatalError("Expected a dictionary containing an image, but was provieded following: \(info) ")  }
        
        // set photoImageView to displayed the selected image
        photoImageView.image = selectedImage
        
        // dismiss the image picker
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Navigation
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        let isPresentingInAddMealModel = presentingViewController is UINavigationController
        // true if the the view controller that presented this scene is of type UINavigationController
        // This means the meal detail scene is presented by the user tapping the Add button, as the meal veiw is embedded in its own navigation controller
        if isPresentingInAddMealModel{
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            // if the user is editing an existing meal
            // pop the meal detail scene from the navigation stack
            owningNavigationController.popViewController(animated: true)
            
        }
        else {
            fatalError("The mealViewController is not inside a navigation controller")
        }
        
    }
    
    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else{
            //downcast the sender to UIBarButtonItem, and than it identical to the saveButton
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let name = nameTextField.text ?? ""
        let photo = photoImageView.image
        let rating = ratingControl.rating
        
        // Set the meal to be passed to MealTableViewController after the unwind segue.
        meal = Meal(name: name, photo: photo, rating: rating)
        
    }
    
    
    //MARK: Actions
//    @IBAction func setDefaultLabelText(_ sender: UIButton) {
//       mealNameLabel.text = "Meal Name"
//    }
    
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        // hide keyboard if the user is typing in text field
        nameTextField.resignFirstResponder()
        
        //UIimagePickerController is a view controller that lets a user pick media from their photo library
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        
        // make sure ViewController is notified when the user picks an image
        imagePickerController.delegate = self
        
        present(imagePickerController, animated: true, completion: nil)
        
    }
    
    //MARK: Private Methods
    private func updateSaveButtonState(){
        // Disable the save button if the field is empty
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
}

