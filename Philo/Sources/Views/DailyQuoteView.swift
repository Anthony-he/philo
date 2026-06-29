import SwiftUI

struct DailyQuoteView: View {
    @State private var viewModel = DailyQuoteViewModel()
    @State private var showingMoodSelection = false
    @State private var showingDetail = false
    @State private var selectedQuote: Quote?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 28) {
                    // Header
                    headerView
                    
                    // Daily Quote Card
                    if viewModel.isLoading {
                        loadingView
                    } else if let quote = viewModel.todayQuote {
                        QuoteCard(quote: quote) {
                            selectedQuote = quote
                            showingDetail = true
                        }
                    } else {
                        emptyStateView
                    }
                    
                    // Mood Check-in Prompt
                    moodCheckinSection
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 40)
            }
            .background(
                LinearGradient(
                    colors: [.primary.opacity(0.03), .primary.opacity(0.01)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            )
            .navigationTitle("Philo")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { viewModel.refreshQuote() }) {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 14, weight: .medium))
                    }
                }
            }
            .onAppear {
                viewModel.loadDailyQuote()
            }
            .fullScreenCover(isPresented: $showingMoodSelection) {
                MoodSelectionView()
            }
            .sheet(isPresented: $showingDetail) {
                if let quote = selectedQuote {
                    QuoteDetailView(quote: quote)
                }
            }
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 4) {
            Text(formattedDate())
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(.secondary)
            
            Text("今日哲思")
                .font(.system(size: 22, weight: .semibold))
                .foregroundColor(.primary)
        }
        .padding(.top, 4)
    }
    
    private var loadingView: some View {
        VStack(spacing: 12) {
            ProgressView()
                .scaleEffect(1.2)
            Text("正在为你准备今日的哲思...")
                .font(.system(size: 14))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 80)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "books.vertical")
                .font(.system(size: 48))
                .foregroundColor(.secondary.opacity(0.5))
            Text("暂无语录")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 80)
    }
    
    private var moodCheckinSection: some View {
        VStack(spacing: 16) {
            Divider()
                .padding(.horizontal, -20)
            
            VStack(spacing: 8) {
                Text("今天心情如何？")
                    .font(.system(size: 18, weight: .semibold))
                
                Text("选择你的心情，获取匹配的哲思语录")
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
            }
            
            Button(action: { showingMoodSelection = true }) {
                HStack(spacing: 8) {
                    Image(systemName: "sparkles")
                    Text("开始心情记录")
                        .fontWeight(.medium)
                }
                .font(.system(size: 16))
                .foregroundColor(.white)
                .padding(.horizontal, 28)
                .padding(.vertical, 14)
                .background(
                    Capsule()
                        .fill(.linearGradient(
                            colors: [.blue, .purple.opacity(0.8)],
                            startPoint: .leading,
                            endPoint: .trailing
                        ))
                )
            }
        }
    }
    
    private func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.dateFormat = "yyyy年M月d日 EEEE"
        return formatter.string(from: Date())
    }
}

#Preview {
    DailyQuoteView()
}
