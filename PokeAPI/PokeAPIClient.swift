import Foundation

private struct PokemonDTO: Decodable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let types: [TypeSlot]
    let sprites: Sprites

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

        return Pokemon(
            id: self.id,
            name: self.name,
            height: Double(self.height) * 0.1,
            weight: Double(self.weight) * 0.1,
            types: types,
            imageURL: imageURL
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
