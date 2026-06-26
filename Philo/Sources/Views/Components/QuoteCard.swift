import SwiftUI

struct QuoteCard: View {
    let quote: Quote
    var showAuthor: Bool = true
    var onTap: (() -> Void)?
    
    @State private var isAnimating = false
    
    var body: some View {
        Button(action: { onTap?() }) {
            VStack(alignment: .leading, spacing: 12) {
                Text("「")
                    .font(.system(size: 28, weight: .light))
                    .foregroundColor(.secondary)
                    .padding(.bottom, -8)
                
                Text(quote.text)
                    .font(.system(size: 17, design: .serif))
                    .lineSpacing(8)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                
                if showAuthor {
                    HStack {
                        Spacer()
                        VStack(alignment: .trailing, spacing: 2) {
                            Text("—— \(quote.author)")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.secondary)
                            if !quote.source.isEmpty {
                                Text(quote.source)
                                    .font(.system(size: 12))
                                    .foregroundColor(.tertiary)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 24)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.regularMaterial)
                    .shadow(color: .black.opacity(0.05), radius: 8, y: 2)
            )
        }
        .buttonStyle(.plain)
        .scaleEffect(isAnimating ? 1.0 : 0.95)
        .opacity(isAnimating ? 1.0 : 0.0)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                isAnimating = true
            }
        }
    }
}

struct QuoteCard_Previews: PreviewProvider {
    static var previews: some View {
        QuoteCard(
            quote: Quote(
                text: "我们听到的一切都是一个观点，不是事实。",
                author: "马可·奥勒留",
                source: "《沉思录》"
            )
        )
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
