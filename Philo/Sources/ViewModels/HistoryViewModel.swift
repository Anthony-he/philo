import Foundation
import SwiftData
import Observation

@Observable
final class HistoryViewModel {
    private var storageService: StorageService?
    
    var entries: [MoodEntry] = []
    var isLoading = true
    var selectedEntry: MoodEntry?
    var selectedDate: Date?
    
    func setup(modelContext: ModelContext) {
        storageService = StorageService(modelContext: modelContext)
        loadEntries()
    }
    
    func loadEntries() {
        guard let storageService else { return }
        isLoading = true
        entries = storageService.fetchAllMoodEntries()
        isLoading = false
    }
    
    func entriesForDate(_ date: Date) -> [MoodEntry] {
        guard let storageService else { return [] }
        return storageService.fetchMoodEntries(for: date)
    }
    
    func deleteEntry(_ entry: MoodEntry) {
        guard let storageService else { return }
        storageService.deleteMoodEntry(entry)
        loadEntries()
    }
    
    func weekSummary() -> [(String, Int)] {
        let calendar = Calendar.current
        let today = Date()
        guard let weekAgo = calendar.date(byAdding: .day, value: -7, to: today) else { return [] }
        guard let storageService else { return [] }
        
        let weekEntries = storageService.fetchMoodEntriesInRange(from: weekAgo, to: today)
        var counts: [String: Int] = [:]
        for entry in weekEntries {
            counts[entry.mood, default: 0] += 1
        }
        return counts.map { ($0.key, $0.value) }.sorted { $0.1 > $1.1 }
    }
    
    var totalCheckIns: Int {
        guard let storageService else { return 0 }
        return storageService.totalCheckIns()
    }
    
    var streakDays: Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        var streak = 0
        var currentDate = today
        
        while true {
            let entries = entriesForDate(currentDate)
            if !entries.isEmpty {
                streak += 1
                currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate)!
            } else {
                break
            }
        }
        return streak
    }
}
