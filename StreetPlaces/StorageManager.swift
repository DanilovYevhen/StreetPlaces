//
//  StorageManager.swift
//  StreetPlaces
//
//  Created by Yevhen Danilov on 10.01.2023.
//

import RealmSwift

let realm = try! Realm()

class StorageManager {
    static func saveObject(_ place: Place) {
        try! realm.write {
            realm.add(place)
        }
    }
}
