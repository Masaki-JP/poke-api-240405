import SwiftUI
import AVFoundation

//<a target="_blank" href="https://icons8.com/icon/63311/pokeball">ポケモンボール</a> アイコン by <a target="_blank" href="https://icons8.com">Icons8</a>

struct DetailView: View {
    let pokemon: Pokemon
    private let criesPlayer = AVPlayer()

    var body: some View {
        ScrollView {
            VStack(spacing: nil) {
                header
                image
                types
                VStack(spacing: 20) {
                    basestats
                    description
                    size
                    category
                    abilitys
                    evolution
                }
                .padding(.horizontal)
                .frame(maxWidth: .infinity)
                .padding(.vertical)
                .background(.regularMaterial)
            }
            .padding(.horizontal)
            .padding(.bottom, UIDevice.current.userInterfaceIdiom == .pad ? 15 : 0)
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
        .overlay(alignment: .bottomTrailing) {
            Button(action: playCries) {
                Image(systemName: "headphones.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
            }
            .padding([.trailing, .bottom])
        }
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

    var basestats: some View {
        informationContent("Base Stats") {
            VStack(spacing: 15) {
                stat("Hit Point", min: 0, max: 250, value: Double(pokemon.hp), tint: .green)
                stat("Attack", min: 0, max: 150, value: Double(pokemon.attack), tint: .red)
                stat("Defense", min: 0, max: 150, value: Double(pokemon.defense), tint: .blue)
                stat("Special Attack", min: 0, max: 150, value: Double(pokemon.specialAttack), tint: .orange)
                stat("Special Defense", min: 0, max: 150, value: Double(pokemon.specialDefense), tint: .cyan)
                stat("Speed", min: 0, max: 150, value: Double(pokemon.speed), tint: .yellow)
            }
            .padding(.vertical, 10)
        }
    }

    var description: some View {
        informationContent("Description") {
            Text("A strange seed was planted on its back at birth. The plant sprouts and grows with this Pokemon.") // 静的実装
        }
    }

    var size: some View {
        informationContent("Size") {
            HStack {
                Text("Height: \(pokemon.height.description)m")
                Text("/")
                Text("Weight: \(pokemon.height.description)kg")
            }
        }
    }

    var category: some View {
        informationContent("Category") {
            Text("Seed pokemon") // 静的実装
        }
    }

    var abilitys: some View {
        informationContent("Abilitys") {
            Text("overgrow / chlorophyll") // 静的実装
        }
    }

    var evolution: some View {
        informationContent("Evolution") {
            Grid(alignment: .leading) { // 静的実装
                GridRow {
                    Text("Before Evolution")
                    Text(":")
                    Text("none").padding(.leading, 3)
                }
                GridRow {
                    Text("After Evolution")
                    Text(":")
                    Text("ivysaur").padding(.leading, 3)
                }
            }
        }
    }

    func playCries() { // 著作権
        //        playErrorSound()
        guard (1...151).contains(pokemon.id)
        else { playErrorSound(); return; }
        let idString = String(format: "%03d", pokemon.id)
        guard let url = URL(string: "https://www.pokemon.jp/special/nakigoe151/sound/m/\(idString).mp3")
        else { playErrorSound(); return; }
        criesPlayer.replaceCurrentItem(with: .init(url: url))
        criesPlayer.play()
    }

    func playErrorSound() {
        let url = Bundle.main.url(forResource: "ErrorSound", withExtension: "mp3")!
        criesPlayer.replaceCurrentItem(with: .init(url: url))
        criesPlayer.play()
    }

}

#Preview("フシギダネ") {
    DetailView(pokemon: sample_1)
}

#Preview("ヒトカゲ") {
    DetailView(pokemon: sample_4)
}

#Preview("ミュウ") {
    DetailView(pokemon: sample_151)
}
