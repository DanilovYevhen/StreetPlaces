//
//  PlaceModel.swift
//  StreetPlaces
//
//  Created by Yevhen Danilov on 02.12.2022.
//

import UIKit

struct Place {
    
    var name: String
    var location: String?
    var type: String?
    var image: UIImage?
    var restaurantImage: String?
    
    static let restaurantNames = [
              "Burger Heroes", "Kitchen", "Bonsai", "Дастархан",
              "Индокитай", "X.O", "Балкан Гриль", "Sherlock Holmes",
              "Speak Easy", "Morris Pub", "Вкусные истории",
              "Классик", "Love&Life", "Шок", "Бочка", "Evraziya", "Пузата Хата",
              "Trattoria Zucca", "VINO e CUCINA"
          ]
    static func getPlaces() -> [Place] {
        var places = [Place] ()
        for place in restaurantNames {
            places.append(Place(name: place, location: "Kiev",  type: "Restaurant", image: nil, restaurantImage: place))
        }
        return places
    }
}
