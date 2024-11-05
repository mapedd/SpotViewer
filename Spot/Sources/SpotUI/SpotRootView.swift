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
      ProgressView()
    case .loading:
      ProgressView()
    case .empty:
      noContent(nil)
    case .failed(let error):
      noContent(error)
    case .loaded(rows: let rows):
      list(rows)
    }
  }
  
  private func noContent(_ error: (any Error)?) -> some View {
    ContentUnavailableView {
      if error == nil {
        Label("No tokens found", systemImage: "dog.circle.fill")
      } else {
        Label("Can't load tokens", systemImage: "exclamationmark.icloud.fill")
      }
    } description: {
      VStack(spacing: 20) {
        if let desc = error?.localizedDescription {
          Text(desc)
        }
        Button("Retry") {
          Task {
            await viewModel.loadDataTask()
          }
        }
        .buttonStyle(.borderedProminent)
      }
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

#Preview("Empty") {
  SpotRootView(viewModel: MockTokenListViewModel(content: .empty))
}

#Preview("Error") {
  SpotRootView(viewModel: MockTokenListViewModel(content: .failed(NSError(domain: "1", code: 1, userInfo: [NSLocalizedDescriptionKey: "No network"]))))
}
