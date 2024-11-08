import SwiftUI
import SpotUI
import Spot

@main
struct SpotViewerApp: App {
  var body: some Scene {
    WindowGroup {
      NavigationStack {
        SpotRootView(
          viewModel: TokenListViewModel.makeViewModel()
        )
      }
    }
  }
}
