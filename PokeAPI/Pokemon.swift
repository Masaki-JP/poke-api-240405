import SwiftUI

struct Pokemon: Identifiable {
    let id: Int
    let name: String
    let height: Double
    let weight: Double
    let types: (slot1: PokeType, slot2: PokeType?)
    let imageURL: URL
    let hp: Int
    let attack: Int
    let defense: Int
    let specialAttack: Int
    let specialDefense: Int
    let speed: Int
}
