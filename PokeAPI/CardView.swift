import SwiftUI

struct CardView: View {
    let pokemon: Pokemon

    var body: some View {
        VStack(spacing: 0) {
            AsyncImage(url: pokemon.imageURL) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image.resizable().scaledToFit()
                case .failure(let error):
                    Text(error.localizedDescription)
                @unknown default: fatalError()
                }
            }
            .frame(width: 80, height: 80)
            Text(pokemon.name)
                .fontWeight(.semibold)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 25.0))
        .overlay(alignment: .topLeading) {
            Text("No.\(String(format: "%04d", pokemon.id))")
                .font(.caption)
                .frame(width: 60, height: 25)
                .background(.orange)
                .clipShape(Capsule())
                .padding([.top, .leading], -5)
        }
    }
}

#Preview {
    CardView(
        pokemon: Pokemon(
            id: 1,
            name: "bulbasaur",
            height: 0.7,
            weight: 6.9,
            types: (slot1: .grass, slot2: Optional(.poison)),
            imageURL: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png")!
        )
    )
    .frame(width: 100, height: 100)
}
