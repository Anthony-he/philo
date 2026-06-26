import SwiftUI

struct QuoteDetailView: View {
    @Environment(\.dismiss) private var dismiss
    let quote: Quote
    
    @State private var isTextCopied = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 32) {
                    Spacer().frame(height: 20)
                    
                    // Main quote display
                    VStack(spacing: 24) {
                        Image(systemName: "quote.opening")
                            .font(.system(size: 36))
                            .foregroundColor(.blue.opacity(0.3))
                        
                        Text(quote.text)
                            .font(.system(size: 22, design: .serif))
                            .lineSpacing(10)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.primary)
                        
                        Image(systemName: "quote.closing")
                            .font(.system(size: 36))
                            .foregroundColor(.blue.opacity(0.3))
                    }
                    .padding(.horizontal, 24)
                    
                    // Author info
                    VStack(spacing: 4) {
                        Text(quote.author)
                            .font(.system(size: 18, weight: .semibold))
                        
                        if !quote.source.isEmpty {
                            Text(quote.source)
                                .font(.system(size: 14))
                                .foregroundColor(.secondary)
                        }
                        
                        if !quote.era.isEmpty {
                            Text(quote.era)
                                .font(.system(size: 12))
                                .foregroundColor(.tertiary)
                                .padding(.top, 2)
                        }
                    }
                    
                    // Tags
                    if !quote.tags.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("标签")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(.secondary)
                            
                            HStack(spacing: 8) {
                                ForEach(quote.tags, id: \.self) { tag in
                                    Text(tag)
                                        .font(.system(size: 12))
                                        .foregroundColor(.blue)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(
                                            Capsule()
                                                .fill(.blue.opacity(0.1))
                                        )
                                }
                            }
                        }
                    }
                    
                    // Related moods
                    VStack(alignment: .leading, spacing: 8) {
                        Text("匹配的心情")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.secondary)
                        
                        HStack(spacing: 8) {
                            ForEach(quote.moodCategories, id: \.self) { moodRaw in
                                if let mood = Mood(rawValue: moodRaw) {
                                    HStack(spacing: 4) {
                                        Image(systemName: mood.systemImage)
                                        Text(mood.displayName)
                                    }
                                    .font(.system(size: 11))
                                    .foregroundColor(.blue)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .background(
                                        Capsule()
                                            .fill(.blue.opacity(0.08))
                                    )
                                }
                            }
                        }
                    }
                    
                    Spacer().frame(height: 20)
                }
                .padding(.horizontal, 20)
            }
            .background(
                LinearGradient(
                    colors: [.primary.opacity(0.02), .primary.opacity(0.01)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            )
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                            Text("返回")
                        }
                        .font(.system(size: 15))
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: copyQuote) {
                        Image(systemName: isTextCopied ? "checkmark" : "doc.on.doc")
                            .font(.system(size: 14))
                    }
                }
            }
        }
    }
    
    private func copyQuote() {
        let text = "「\(quote.text)」—— \(quote.author)"
        UIPasteboard.general.string = text
        isTextCopied = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isTextCopied = false
        }
    }
}

#Preview {
    QuoteDetailView(
        quote: Quote(
            text: "我们听到的一切都是一个观点，不是事实。",
            author: "马可·奥勒留",
            source: "《沉思录》",
            era: "古罗马",
            tags: ["观点", "视角"],
            moodCategories: ["contemplative"]
        )
    )
}
