import SwiftUI
import SwiftData

struct HistoryView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = HistoryViewModel()
    @State private var selectedDetailEntry: MoodEntry?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Stats section
                    statsSection
                    
                    // Week summary
                    weekSummarySection
                    
                    // Entries timeline
                    entriesTimelineSection
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
            .navigationTitle("心情日记")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if !viewModel.entries.isEmpty {
                        EditButton()
                            .font(.system(size: 15))
                    }
                }
            }
            .onAppear {
                viewModel.setup(modelContext: modelContext)
            }
            .sheet(item: $selectedDetailEntry) { entry in
                entryDetailView(entry)
            }
        }
    }
    
    private var statsSection: some View {
        HStack(spacing: 16) {
            statCard(
                icon: "checkmark.circle.fill",
                value: "\(viewModel.totalCheckIns)",
                label: "总记录"
            )
            
            statCard(
                icon: "flame.fill",
                value: "\(viewModel.streakDays)",
                label: "连续天数"
            )
            
            statCard(
                icon: "calendar",
                value: "\(viewModel.entries.count > 0 ? "\(viewModel.entries.count)" : "0")",
                label: "日记条数"
            )
        }
    }
    
    private func statCard(icon: String, value: String, label: String) -> some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(.blue)
            
            Text(value)
                .font(.system(size: 24, weight: .bold))
            
            Text(label)
                .font(.system(size: 11))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(.regularMaterial)
        )
    }
    
    private var weekSummarySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("最近一周心情概览")
                .font(.system(size: 16, weight: .semibold))
            
            if viewModel.entries.isEmpty {
                HStack {
                    Spacer()
                    VStack(spacing: 8) {
                        Image(systemName: "heart.slash")
                            .font(.system(size: 24))
                            .foregroundColor(.secondary.opacity(0.5))
                        Text("还没有心情记录")
                            .font(.system(size: 13))
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 20)
                    Spacer()
                }
            } else {
                let summary = viewModel.weekSummary()
                if summary.isEmpty {
                    Text("最近七天尚未记录")
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)
                        .padding(.vertical, 8)
                } else {
                    HStack(spacing: 12) {
                        ForEach(summary.prefix(5), id: \.0) { (moodRaw, count) in
                            if let mood = Mood(rawValue: moodRaw) {
                                VStack(spacing: 4) {
                                    Image(systemName: mood.systemImage)
                                        .font(.system(size: 18))
                                        .foregroundColor(.blue)
                                    Text("\(count)")
                                        .font(.system(size: 14, weight: .semibold))
                                    Text(mood.displayName)
                                        .font(.system(size: 9))
                                        .foregroundColor(.secondary)
                                        .lineLimit(1)
                                }
                                .frame(maxWidth: .infinity)
                            }
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(.regularMaterial)
                    )
                }
            }
        }
    }
    
    private var entriesTimelineSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("历史记录")
                .font(.system(size: 16, weight: .semibold))
            
            if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 40)
            } else if viewModel.entries.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "book")
                        .font(.system(size: 40))
                        .foregroundColor(.secondary.opacity(0.4))
                    Text("还没有任何心情记录")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                    Text("记录心情，开始你的哲学日记")
                        .font(.system(size: 12))
                        .foregroundColor(.tertiary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
            } else {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.entries) { entry in
                        entryRow(entry)
                            .onTapGesture {
                                selectedDetailEntry = entry
                            }
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            let entry = viewModel.entries[index]
                            viewModel.deleteEntry(entry)
                        }
                    }
                }
            }
        }
    }
    
    private func entryRow(_ entry: MoodEntry) -> some View {
        HStack(spacing: 14) {
            // Mood icon
            if let mood = entry.moodEnum {
                ZStack {
                    Circle()
                        .fill(moodColor(mood).opacity(0.15))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: mood.systemImage)
                        .font(.system(size: 18))
                        .foregroundColor(moodColor(mood))
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    if let mood = entry.moodEnum {
                        Text(mood.displayName)
                            .font(.system(size: 15, weight: .semibold))
                    }
                    Spacer()
                    Text(entry.timeString)
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                }
                
                Text(entry.dateString)
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                
                if !entry.note.isEmpty {
                    Text(entry.note)
                        .font(.system(size: 13))
                        .foregroundColor(.primary)
                        .lineLimit(2)
                        .padding(.top, 2)
                }
                
                if !entry.savedQuoteTexts.isEmpty {
                    Text("收藏了 \(entry.savedQuoteTexts.count) 条语录")
                        .font(.system(size: 11))
                        .foregroundColor(.blue)
                        .padding(.top, 2)
                }
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(.regularMaterial)
        )
    }
    
    private func entryDetailView(_ entry: MoodEntry) -> some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Mood display
                    if let mood = entry.moodEnum {
                        VStack(spacing: 12) {
                            MoodIcon(mood: mood, size: 64, isSelected: true)
                            
                            Text(mood.displayName)
                                .font(.system(size: 20, weight: .semibold))
                            
                            Text(entry.dateString)
                                .font(.system(size: 14))
                                .foregroundColor(.secondary)
                        }
                        .padding(.top, 24)
                    }
                    
                    // Note
                    if !entry.note.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("备注")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(.secondary)
                            Text(entry.note)
                                .font(.system(size: 15))
                                .foregroundColor(.primary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.regularMaterial)
                        )
                    }
                    
                    // Saved quotes
                    if !entry.savedQuoteTexts.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("收藏的语录")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(.secondary)
                            
                            ForEach(Array(zip(entry.savedQuoteTexts, entry.savedQuoteAuthors)), id: \.0) { text, author in
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("「\(text)」")
                                        .font(.system(size: 14, design: .serif))
                                        .lineSpacing(6)
                                    
                                    Text("—— \(author)")
                                        .font(.system(size: 12))
                                        .foregroundColor(.secondary)
                                }
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(.regularMaterial)
                                )
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
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("关闭") {
                        selectedDetailEntry = nil
                    }
                }
            }
        }
    }
    
    private func moodColor(_ mood: Mood) -> Color {
        switch mood {
        case .anxious: return .orange
        case .sad: return .indigo
        case .angry: return .red
        case .lonely: return .purple
        case .overwhelmed: return .pink
        case .melancholic: return .mint
        case .uncertain: return .brown
        case .weary: return .gray
        case .joyful: return .yellow
        case .grateful: return .teal
        case .hopeful: return .cyan
        case .contemplative: return .blue
        case .peaceful: return .green
        case .inspired: return .orange
        }
    }
}

#Preview {
    HistoryView()
}
