//
//  NewPlaceViewController.swift
//  StreetPlaces
//
//  Created by Yevhen Danilov on 10.12.2022.
//

import UIKit

class NewPlaceViewController: UITableViewController {
    
    
    var imageIsChanged = false
    
    @IBOutlet var saveButton: UIBarButtonItem!
    @IBOutlet var placeImage: UIImageView!
    @IBOutlet var placeName: UITextField!
    
    @IBOutlet var placeType: UITextField!
    @IBOutlet var placeLocation: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        saveButton.isEnabled = false
        placeName.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        
    }
        //MARK: - table view delegate
        
    override func tableView(_ tableView: UITableView, didSelectRowAt IndexPath: IndexPath) {
        
        if IndexPath.row == 0 {
            let cameraIcon = UIImage(named: "camera")
            let photoIcon = UIImage(named: "photo")
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let camera = UIAlertAction(title: "Camera", style: .default) { _ in
                self.chooseImagePicker(sours: .camera)
            }
            camera.setValue(cameraIcon, forKey: "image")
            camera.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            let photo = UIAlertAction(title: "Photo", style: .default) { _ in
                self.chooseImagePicker(sours: .photoLibrary)
            }
            photo.setValue(photoIcon, forKey: "image")
            photo.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            actionSheet.addAction(camera)
            actionSheet.addAction(photo)
            actionSheet.addAction(cancel)
            present(actionSheet, animated: true)
        } else {
            view.endEditing(true)
            }
        }
    func saveNewPlace() {
        var image: UIImage?
        if imageIsChanged {
            image = placeImage.image
        } else {
            image = UIImage(named: "imagePlaceholder")
        }
        let imageData = image?.pngData()
        let newPlace = Place(name: placeName.text!,
                             location: placeLocation.text,
                             type: placeType.text,
                             imageData: imageData)
        StorageManager.saveObject(newPlace)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true)
    }
    
}

//MARK: - Text field delegate

        extension NewPlaceViewController: UITextFieldDelegate {
            
            // Скрываю клавиатуру по нажатию на Done
            
            func textFieldShouldReturn(_ textField: UITextField) -> Bool {
                textField.resignFirstResponder()
                return true
            }
            
            @objc private func textFieldChanged() {
                if placeName.text?.isEmpty == false {
                    saveButton.isEnabled = true
                } else {
                    saveButton.isEnabled = false
                }
            }
        }

//MARK: - Work with image

extension NewPlaceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func chooseImagePicker (sours: UIImagePickerController.SourceType) {
        
        if UIImagePickerController.isSourceTypeAvailable(sours) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = sours
            present(imagePicker, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        placeImage.image = info[.editedImage] as? UIImage
        placeImage.contentMode = .scaleAspectFill
        placeImage.clipsToBounds = true
        imageIsChanged = true
        dismiss(animated: true)
    }
}

    
