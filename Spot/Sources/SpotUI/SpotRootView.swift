import SwiftUI
import Spot
import SDWebImageSwiftUI

@MainActor
public protocol TokenListViewModelProtocol {
  func loadDataTask() async
  var content: ContentState { get }
}

public struct SpotRootView: View {
  @State var viewModel: any TokenListViewModelProtocol
  
  public init(viewModel: some TokenListViewModelProtocol) {
    self.viewModel = viewModel
  }
  public var body: some View {
    content
      .navigationTitle("Spot tokens")
      .task{
        await viewModel.loadDataTask()
      }
      .refreshable(action: {
        await viewModel.loadDataTask()
      })
  }
  
  @ViewBuilder
  private var content: some View {
    switch viewModel.content {
    case .initial:
      ContentUnavailableView("Hello", image: "bitcoinsign")
    case .loading:
      ProgressView()
    case .empty:
      ContentUnavailableView("No tokens", image: "bitcoinsign.arrow.circlepath")
    case .failed(_):
      ContentUnavailableView(
        "Can't load tokens, please try again",
        image: "bitcoinsign.arrow.circlepath"
      )
    case .loaded(rows: let rows):
      list(rows)
    }
  }
  
  private func list(_ rows: [TokenRow]) -> some View {
    List(rows) { row in
      TokenRowView(row: row)
    }
  }
}

class MockTokenListViewModel: TokenListViewModelProtocol {
  init(content: ContentState) {
    self.content = content
  }
  func loadDataTask() async {}
  
  var content: ContentState
}

#Preview("Loaded data") {
  SpotRootView(viewModel: MockTokenListViewModel(content: .loaded(rows: TokenRow.sampleData)))
}

#Preview("Loading") {
  SpotRootView(viewModel: MockTokenListViewModel(content: .loading))
}

#Preview("Error") {
  SpotRootView(viewModel: MockTokenListViewModel(content: .failed(NSError(domain: "1", code: 1, userInfo: [NSLocalizedDescriptionKey: "No network"]))))
}
