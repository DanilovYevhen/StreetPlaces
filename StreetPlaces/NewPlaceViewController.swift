//
//  NewPlaceViewController.swift
//  StreetPlaces
//
//  Created by Yevhen Danilov on 10.12.2022.
//

import UIKit

class NewPlaceViewController: UITableViewController {
    
    var currentPlace: Place!
    var imageIsChanged = false
    
    @IBOutlet var saveButton: UIBarButtonItem!
    @IBOutlet var placeImage: UIImageView!
    @IBOutlet var placeName: UITextField!
    
    @IBOutlet var placeType: UITextField!
    @IBOutlet var placeLocation: UITextField!
    
    @IBOutlet var ratingControl: RatingControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: CGRect(x: 0,
                                                         y: 0,
                                                         width: tableView.frame.size.width,
                                                         height: 1))
        saveButton.isEnabled = false
        placeName.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        setupEditScreen()
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
    func savePlace() {
        let image = imageIsChanged ? placeImage.image : UIImage(named: "imagePlaceholder")
        let imageData = image?.pngData()
        let newPlace = Place(name: placeName.text!,
                             location: placeLocation.text,
                             type: placeType.text,
                             imageData: imageData,
                             rating: Double(ratingControl.rating))
        if currentPlace != nil {
            try! realm.write {
                currentPlace?.name = newPlace.name
                currentPlace?.location = newPlace.location
                currentPlace?.type = newPlace.type
                currentPlace?.imageData = newPlace.imageData
                currentPlace?.rating = newPlace.rating
            }
        } else {
            StorageManager.saveObject(newPlace)
        }
    }
    
    private func setupEditScreen() {
        if currentPlace != nil {
            setupNavigationBar()
            imageIsChanged = true
            guard let data = currentPlace?.imageData, let image = UIImage(data: data) else { return }
            
            placeImage.image = image
            placeImage.contentMode = .scaleAspectFill
            placeName.text = currentPlace?.name
            placeLocation.text = currentPlace?.location
            placeType.text = currentPlace?.type
            ratingControl.rating = Int(currentPlace.rating)
        }
    }
    
    private func setupNavigationBar() {
        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        navigationItem.leftBarButtonItem = nil
        title = currentPlace?.name
        saveButton.isEnabled = true
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true)
    }
    //MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let identifier = segue.identifier,
              let mapVC = segue.destination as? MapViewController else { return }
        
        mapVC.segueIdentifier = identifier
        mapVC.mapViewControllerDelegate = self
        if identifier == "showMap" {
            mapVC.place.name = placeName.text!
            mapVC.place.location = placeLocation.text
            mapVC.place.type = placeType.text!
            mapVC.place.imageData = placeImage.image?.pngData()
        }
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

extension NewPlaceViewController: MapViewControllerDelegate {
    func getAddress(_address address: String?) {
        placeLocation.text = address
    }
}

    
