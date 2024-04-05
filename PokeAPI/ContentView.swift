import SwiftUI

struct ContentView: View {
    private let apiClient = PokeAPIClient()
    @State private var pokemons: [Pokemon?] = []
    private let gridItem = GridItem(.adaptive(minimum: 150, maximum: 200), spacing: 15)

    var body: some View {
        ScrollView {
            LazyVGrid(
                columns: [gridItem],
                spacing: 20
            ) {
                ForEach(pokemons.indices, id: \.self) { i in
                    if let pokemon = pokemons[i] {
                        NavigationLink {
                            DetailView(pokemon: pokemon)
                        } label: {
                            CardView(pokemon: pokemon)
                                .frame(maxHeight: 200)
                        }
                        .foregroundStyle(.primary)
                    }
                }
            }
            .padding(.horizontal, 10)
        }
        .safeAreaInset(edge: .bottom) {
            if pokemons.isEmpty {
                Button("ポケモンゲットだぜ！") {
                    Task {
                        pokemons = await apiClient.fetchPokemons(from: 1, to: 151)
                    }
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.capsule)
                .tint(.orange)
                .fontWeight(.semibold)
            }
        }
        .background(.brown.gradient)
    }
}

#Preview {
    ContentView()
}
