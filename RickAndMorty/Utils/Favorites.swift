//
//  Favorites.swift
//  RickAndMorty
//
//  Created by Ariel Berguño on 19/09/2023.
//

import Foundation

class Favorites: ObservableObject {
    static let shared = Favorites()

    @Published var favorites: Set<Int> = []
    let defaults = UserDefaults.standard

    private init() { //This prevents others from using the default '()' initializer for this class.
        self.favorites = Set(defaults.array(forKey: "Favorites") as? [Int] ?? [])
    }

    func add(_ id: Int) {
        guard !favorites.contains(id) else { return }
        favorites.insert(id)
        save()
    }

    func remove(_ id: Int) {
        favorites.remove(id)
        save()
    }

    func save() {
        self.defaults.set(Array(self.favorites), forKey: "Favorites")
        defaults.synchronize()
    }
}
