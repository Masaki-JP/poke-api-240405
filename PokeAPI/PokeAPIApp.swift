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
