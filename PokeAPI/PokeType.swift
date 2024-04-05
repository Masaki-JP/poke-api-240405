import SwiftUI

/// No.0001 ~ No.0151
extension Pokemon {
    enum PokeType: String {
        case grass, poison, fire, flying, water, bug, normal, electric, ground, fairy, fighting, psychic, rock, steel, ice, ghost, drago
        case unknown
        
        var imageColor: Color {
            switch self {
            case .grass:
                    .init(red: 34 / 255 * 1.2, green: 139 / 255 * 1.2, blue: 34 / 255 * 1.2)
            case .poison:
                    .init(red: 148 / 255, green: 0 / 255, blue: 211 / 255)
            case .fire:
                    .init(red: 255 / 255, green: 0 / 255, blue: 0 / 255)
            case .flying:
                    .init(red: 70 / 255, green: 130 / 255, blue: 180 / 255)
            case .water:
                    .init(red: 0 / 255, green: 0 / 255, blue: 255 / 255)
            case .bug:
                    .init(red: 184 / 255, green: 134 / 255, blue: 11 / 255)
            case .normal:
                    .init(red: 128 / 255 * 1.1, green: 128 / 255 * 1.1, blue: 128 / 255 * 1.1)
            case .electric:
                    .init(red: 255 / 255, green: 200 / 255, blue: 0 / 255)
            case .ground:
                    .init(red: 160 / 255, green: 82 / 255, blue: 45 / 255)
            case .fairy:
                    .init(red: 205 / 255, green: 92 / 255, blue: 92 / 255)
            case .fighting:
                    .init(red: 165 / 255, green: 42 / 255, blue: 42 / 255)
            case .psychic:
                    .init(red: 255 / 255, green: 20 / 255, blue: 147 / 255)
            case .rock:
                    .init(red: 139 / 255, green: 69 / 255, blue: 19 / 255)
            case .steel:
                    .init(red: 192 / 255 * 0.9, green: 192 / 255 * 0.9, blue: 192 / 255 * 0.9)
            case .ice:
                    .init(red: 0 / 255, green: 206 / 255, blue: 209 / 255)
            case .ghost:
                    .init(red: 72 / 255, green: 61 / 255, blue: 139 / 255)
            case .drago:
                    .init(red: 25 / 255, green: 25 / 255, blue: 112 / 255)
            case .unknown:
                    .black
            }
        }
    }
}
