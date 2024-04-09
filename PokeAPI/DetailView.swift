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
                    Grid {
                        GridRow {
                            Divider()
                            Text("Status")
                                .font(.title3.bold())
                            Divider()
                        }
                    }
                    statView("Hit Point", min: 0, max: 250, value: Double(pokemon.hp), tint: .green)
                    statView("Attack", min: 0, max: 150, value: Double(pokemon.attack), tint: .red)
                    statView("Defense", min: 0, max: 150, value: Double(pokemon.defense), tint: .blue)
                    statView("Special Attack", min: 0, max: 150, value: Double(pokemon.specialAttack), tint: .orange)
                    statView("Special Defense", min: 0, max: 150, value: Double(pokemon.specialDefense), tint: .cyan)
                    statView("Speed", min: 0, max: 150, value: Double(pokemon.speed), tint: .yellow)
                }
                .padding()
                .background(.regularMaterial)
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

    func playCries() { // 著作権
        
        playErrorSound()

//        guard (1...151).contains(pokemon.id)
//        else { playErrorSound(); return; }
//        let idString = String(format: "%03d", pokemon.id)
//        guard let url = URL(string: "https://www.pokemon.jp/special/nakigoe151/sound/m/\(idString).mp3")
//        else { playErrorSound(); return; }
//        criesPlayer.replaceCurrentItem(with: .init(url: url))
//        criesPlayer.play()
    }

    func playErrorSound() {
        let url = Bundle.main.url(forResource: "ErrorSound", withExtension: "mp3")!
        criesPlayer.replaceCurrentItem(with: .init(url: url))
        criesPlayer.play()
    }

    func statView(_ stat: String, min: Double, max: Double, value: Double, tint: Color) -> some View{
        VStack(alignment: .leading) {
            Text("\(stat): \(String(format: "%.0f", value))")
                .font(.headline)
            Gauge(value: value, in: min...max) {
                EmptyView()
            } currentValueLabel: {
                EmptyView()
            } minimumValueLabel: {
                Text(String(format: "%.0f", min))
            } maximumValueLabel: {
                Text(String(format: "%.0f", max))
            }
            .gaugeStyle(.accessoryLinear)
            .tint(tint)
        }
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
