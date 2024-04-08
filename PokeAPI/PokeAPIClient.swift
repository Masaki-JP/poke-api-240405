import Foundation

private struct PokemonDTO: Decodable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let types: [TypeSlot]
    let sprites: Sprites
    let stats: [StatObject]

    struct TypeSlot: Decodable {
        let type: PokeType

        struct PokeType: Decodable {
            let name: String
        }
    }

    struct Sprites: Decodable {
        let frontDefault: String

        enum CodingKeys: String, CodingKey {
            case frontDefault = "front_default"
        }
    }

    struct StatObject: Decodable {
        let baseStat: Int
        let stat: Stat

        enum CodingKeys: String, CodingKey {
            case baseStat = "base_stat"
            case stat
        }

        struct Stat: Decodable {
            let name: String
        }
    }

    func convert() -> Pokemon? {
        guard
            let imageURL = URL(string: self.sprites.frontDefault),
            let types: (Pokemon.PokeType, Pokemon.PokeType?) = if self.types.count == 1 {
                (Pokemon.PokeType(rawValue: self.types[0].type.name) ?? .unknown , nil)
            } else if self.types.count == 2 {
                (
                    {
                        return .init(rawValue: self.types[0].type.name) ?? .unknown
                    }(),
                    {
                        let slot2: Pokemon.PokeType? = .init(rawValue: self.types[1].type.name) ?? .unknown
                        return slot2
                    }()
                )
            } else {
                nil
            }
        else { return nil }

        func getStat(_ name: String) -> Int? {
            let statObjects = self.stats.filter { $0.stat.name == name }
            guard let statObject = statObjects.first
            else { return nil }
            return statObject.baseStat
        }

        guard
            let hp = getStat("hp"),
            let attack = getStat("attack"),
            let defense = getStat("defense"),
            let specialAttack = getStat("special-attack"),
            let specialDefense = getStat("special-defense"),
            let speed = getStat("speed")
        else { return nil }

        return Pokemon(
            id: self.id,
            name: self.name,
            height: Double(self.height) / 10,
            weight: Double(self.weight) / 10,
            types: types,
            imageURL: imageURL,
            hp: hp,
            attack: attack,
            defense: defense,
            specialAttack: specialAttack,
            specialDefense: specialDefense,
            speed: speed
        )
    }
}

struct PokeAPIClient {
    func fetchPokemons(from firstID: Int, to lastID: Int) async -> [Pokemon?] {
        return await withTaskGroup(of: (id: Int, value: Pokemon?).self) { taskGroup in
            guard firstID < lastID else { return [] }
            let urls = (firstID...lastID).map(getURL(id:))

            for element in urls.enumerated() {
                taskGroup.addTask {
                    guard let url = element.element,
                          let (data, _) = try? await URLSession.shared.data(from: url),
                          let pokemonDTO = try? JSONDecoder().decode(PokemonDTO?.self, from: data),
                          let pokemon = pokemonDTO.convert()
                    else { return (id: element.offset, value: nil) }
                    return (id: element.offset, value: pokemon)
                }
            }

            var pokemons: [(id: Int, value: Pokemon?)] = []
            for await childTaskResult in taskGroup {
                pokemons.append(childTaskResult)
            }

            return pokemons.sorted(by: { $0.id < $1.id }).map(\.value)
        }
    }

    private func getURL(id: Int) -> URL? {
        URL(string: "https://pokeapi.co/api/v2/pokemon/\(id)")
    }
}
