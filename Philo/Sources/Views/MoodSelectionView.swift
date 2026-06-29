import SwiftUI

struct MoodSelectionView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel = MoodSelectionViewModel()
    @State private var showingDetail = false
    @State private var selectedQuote: Quote?
    @State private var selectedMoodEntries: [Quote] = []
    
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 4)
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Title
                    VStack(spacing: 6) {
                        Text("你现在感觉怎么样？")
                            .font(.system(size: 22, weight: .semibold))
                        Text("选择一种心情，哲学将为你找到共鸣")
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 20)
                    
                    // Mood Grid
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(viewModel.moods) { mood in
                            MoodIcon(
                                mood: mood,
                                size: 48,
                                isSelected: viewModel.selectedMood == mood
                            )
                            .onTapGesture {
                                withAnimation(.spring(response: 0.3)) {
                                    viewModel.selectMood(mood)
                                    selectedMoodEntries = []
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 8)
                    
                    // Loading / Results
                    if viewModel.isLoading {
                        ProgressView()
                            .scaleEffect(1.2)
                            .padding(.vertical, 40)
                    } else if viewModel.hasSearched, let mood = viewModel.selectedMood {
                        resultsSection(for: mood)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
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
                
                if viewModel.selectedMood != nil {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("清除") {
                            withAnimation {
                                viewModel.clearSelection()
                            }
                        }
                        .font(.system(size: 15))
                    }
                }
            }
            .sheet(isPresented: $showingDetail) {
                if let quote = selectedQuote {
                    QuoteDetailView(quote: quote)
                }
            }
        }
    }
    
    private func resultsSection(for mood: Mood) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Divider()
            
            HStack {
                Image(systemName: mood.systemImage)
                    .foregroundColor(.blue)
                Text("给「\(mood.displayName)」的慰藉")
                    .font(.system(size: 17, weight: .semibold))
            }
            
            if viewModel.matchedQuotes.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "leaf")
                        .font(.system(size: 36))
                        .foregroundColor(.secondary.opacity(0.5))
                    Text("暂时没有找到匹配的语录")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
            } else {
                ForEach(viewModel.matchedQuotes) { quote in
                    QuoteCard(quote: quote) {
                        selectedQuote = quote
                        showingDetail = true
                    }
                }
            }
            
            // Save button
            if !viewModel.matchedQuotes.isEmpty {
                Button(action: {
                    selectedMoodEntries = viewModel.matchedQuotes
                    dismiss()
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "bookmark.fill")
                        Text("记录此刻心情与这些语录")
                    }
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.linearGradient(
                                colors: [.blue, .purple.opacity(0.8)],
                                startPoint: .leading,
                                endPoint: .trailing
                            ))
                    )
                }
                .padding(.top, 4)
            }
        }
    }
}

#Preview {
    MoodSelectionView()
}
