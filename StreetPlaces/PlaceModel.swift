//
//  PlaceModel.swift
//  StreetPlaces
//
//  Created by Yevhen Danilov on 02.12.2022.
//

import RealmSwift

class Place: Object {
    
    @objc dynamic var name = ""
    @objc dynamic var location: String?
    @objc dynamic var type: String?
    @objc dynamic var imageData: Data?
    @objc dynamic var date = Date()
    
    convenience init(name: String, location: String?, type: String?, imageData: Data?) {
        self.init()
        self.name = name
        self.location = location
        self.type = type
        self.imageData = imageData
    }
    
   /* let restaurantNames = [
              "Burger Heroes", "Kitchen", "Bonsai", "Дастархан",
              "Индокитай", "X.O", "Балкан Гриль", "Sherlock Holmes",
              "Speak Easy", "Morris Pub", "Вкусные истории",
              "Классик", "Love&Life", "Шок", "Бочка", "Evraziya", "Пузата Хата",
              "Trattoria Zucca", "VINO e CUCINA"
          ]
    func savePlaces() {
        
        for place in restaurantNames {
            
            let image = UIImage(named: place)
            guard let imageData = image?.pngData() else { return }
            
            let newPlace = Place()
            
            newPlace.name = place
            newPlace.location = "Kyev"
            newPlace.type = "Restourant"
            newPlace.imageData = imageData
            
            StorageManager.saveObject(newPlace)
        }
    } */
}
