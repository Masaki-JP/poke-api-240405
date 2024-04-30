import SwiftUI

extension DetailView {
    func stat(_ stat: String, min: Double, max: Double, value: Double, tint: Color) -> some View{
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

    func informationContent<Content>(_ title: String, @ViewBuilder content: () -> Content) -> some View where Content: View {
        VStack(spacing: 0) {
            Text(title)
                .font(.title3.bold())
                .frame(maxWidth: .infinity, alignment: .leading)
            Divider()
                .padding(.top, 2.5)
            content()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 5)
        }
    }
}
