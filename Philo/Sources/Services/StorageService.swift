import Foundation
import SwiftData

final class StorageService {
    
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    // MARK: - Mood Entries
    
    func saveMoodEntry(mood: Mood, note: String = "", savedQuotes: [Quote] = []) {
        let entry = MoodEntry(
            mood: mood.rawValue,
            note: note,
            savedQuoteTexts: savedQuotes.map { $0.text },
            savedQuoteAuthors: savedQuotes.map { $0.author }
        )
        modelContext.insert(entry)
        try? modelContext.save()
    }
    
    func fetchAllMoodEntries() -> [MoodEntry] {
        let descriptor = FetchDescriptor<MoodEntry>(
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        return (try? modelContext.fetch(descriptor)) ?? []
    }
    
    func fetchMoodEntries(for date: Date) -> [MoodEntry] {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        let predicate = #Predicate<MoodEntry> { entry in
            entry.createdAt >= startOfDay && entry.createdAt < endOfDay
        }
        
        let descriptor = FetchDescriptor<MoodEntry>(
            predicate: predicate,
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        return (try? modelContext.fetch(descriptor)) ?? []
    }
    
    func fetchMoodEntriesInRange(from startDate: Date, to endDate: Date) -> [MoodEntry] {
        let predicate = #Predicate<MoodEntry> { entry in
            entry.createdAt >= startDate && entry.createdAt <= endDate
        }
        let descriptor = FetchDescriptor<MoodEntry>(
            predicate: predicate,
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        return (try? modelContext.fetch(descriptor)) ?? []
    }
    
    func deleteMoodEntry(_ entry: MoodEntry) {
        modelContext.delete(entry)
        try? modelContext.save()
    }
    
    // MARK: - Statistics
    
    func moodCounts() -> [(Mood, Int)] {
        let entries = fetchAllMoodEntries()
        var counts: [String: Int] = [:]
        for entry in entries {
            counts[entry.mood, default: 0] += 1
        }
        return counts.compactMap { (key, value) in
            guard let mood = Mood(rawValue: key) else { return nil }
            return (mood, value)
        }.sorted { $0.1 > $1.1 }
    }
    
    func totalCheckIns() -> Int {
        fetchAllMoodEntries().count
    }
}
