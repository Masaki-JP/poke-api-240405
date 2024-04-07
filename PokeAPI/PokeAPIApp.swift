import SwiftUI

@main
struct TaskGroupApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ContentView()
                    .preferredColorScheme(.light)
            }
        }
    }
}

let sample_1 = Pokemon(
    id: 1,
    name: "bulbasaur",
    height: 0.7,
    weight: 6.9,
    types: (slot1: .grass, slot2: Optional(.poison)),
    imageURL: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png")!
)

let sample_4 = Pokemon(
    id: 4,
    name: "charmander",
    height: 0.6,
    weight: 8.5,
    types: (slot1: .fire, slot2: nil),
    imageURL: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/4.png")!
)

let sample_151 = Pokemon(
    id: 151,
    name: "mew",
    height: 0.4,
    weight: 4.0,
    types: (slot1: .psychic, slot2: nil),
    imageURL: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/151.png")!
)
