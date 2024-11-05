import SwiftUI
import SDWebImageSwiftUI

struct TokenRowView: View {
  var row: TokenRow
  
  @ScaledMetric var size: CGFloat = 30
  
  var body: some View {
    HStack {
      WebImage(url: row.imageURL) { image in
        image.resizable()
      } placeholder: {
        // handle wrong links with a placeholder
        Rectangle().foregroundColor(.gray)
      }
      .indicator(.activity)
      .frame(width: size, height: size)
      .cornerRadius(8)
      VStack(alignment: .leading) {
        Text(row.name)
        Text(row.symbol)
          .font(.caption2)
      }
      Spacer()
      VStack(alignment: .trailing) {
        Text(row.price)
          .font(.system(.caption, design: .monospaced))
        Text(row.lastTradeDate)
          .font(.caption2)
      }
    }
    .contentShape(Rectangle())
  }
}

#Preview {
  VStack {
    TokenRowView(row: TokenRow.sampleData[0])
  }
}
