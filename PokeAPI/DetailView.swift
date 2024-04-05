import SwiftUI

//<a target="_blank" href="https://icons8.com/icon/63311/pokeball">ポケモンボール</a> アイコン by <a target="_blank" href="https://icons8.com">Icons8</a>

struct DetailView: View {
    let pokemon: Pokemon

    var body: some View {
        ScrollView {
            VStack(spacing: nil) {
                header
                image
                types
            }
            .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.brown.gradient)
    }

    var header: some View {
        HStack(spacing: 0) {
            HStack(spacing: 3) {
                Image(.pokeBall)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                Text("No.\(String(format: "%04d", pokemon.id))")
                    .font(.footnote)
                Spacer()
            }
            ViewThatFits(in: .horizontal) {
                ForEach(0..<3) { i in
                    Text(pokemon.name)
                        .font(.system(size: CGFloat(22-i)))
                }
            }
            HStack(spacing: 5) { // 静的実装
                Spacer()
                Text("♂")
                    .frame(width: 20, height: 20)
                    .background(.blue)
                    .clipShape(Circle())
                Text("♀")
                    .frame(width: 20, height: 20)
                    .background(.pink)
                    .clipShape(Circle())
            }
        }
        .padding(5)
        .background(.orange.opacity(0.75))
        .foregroundStyle(.white)
    }

    var image: some View {
        AsyncImage(url: pokemon.imageURL) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image.resizable().scaledToFit()
            case .failure(let error):
                Text(error.localizedDescription)
            @unknown default:
                fatalError()
            }
        }
        .background(.ultraThinMaterial)
    }

    var types: some View {
        HStack(spacing: nil) {
            if let slot2 = pokemon.types.slot2 {
                LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 2)) {
                    Text(pokemon.types.slot1.rawValue)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 1)
                        .background(pokemon.types.slot1.imageColor)
                    Text(slot2.rawValue)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 1)
                        .background(slot2.imageColor)
                }
            } else {
                Text(pokemon.types.slot1.rawValue)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 1)
                    .background(pokemon.types.slot1.imageColor)
            }
        }
        .foregroundStyle(.white)
    }
}

#Preview("フシギダネ") {
    DetailView(pokemon: Pokemon(
        id: 1,
        name: "bulbasaur",
        types: (slot1: .grass, slot2: Optional(.poison)),
        imageURL: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png")!
    ))
}

#Preview("ヒトカゲ") {
    DetailView(
        pokemon: Pokemon(
            id: 4,
            name: "charmander",
            types: (slot1: .fire, slot2: nil),
            imageURL: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/4.png")!
        )
    )
}

#Preview("ミュー") {
    DetailView(
        pokemon: Pokemon(
            id: 151,
            name: "mew",
            types: (slot1: .psychic, slot2: nil),
            imageURL: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/151.png")!
        )
    )
}
