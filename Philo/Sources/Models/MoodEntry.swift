import Foundation
import SwiftData

@Model
final class MoodEntry: Identifiable {
    @Attribute(.unique) var id: UUID
    var mood: String
    var note: String
    var createdAt: Date
    var savedQuoteTexts: [String]
    var savedQuoteAuthors: [String]
    
    init(
        id: UUID = UUID(),
        mood: String,
        note: String = "",
        createdAt: Date = Date(),
        savedQuoteTexts: [String] = [],
        savedQuoteAuthors: [String] = []
    ) {
        self.id = id
        self.mood = mood
        self.note = note
        self.createdAt = createdAt
        self.savedQuoteTexts = savedQuoteTexts
        self.savedQuoteAuthors = savedQuoteAuthors
    }
    
    var moodEnum: Mood? {
        Mood(rawValue: mood)
    }
    
    var dateString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.dateFormat = "yyyy年M月d日"
        return formatter.string(from: createdAt)
    }
    
    var timeString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: createdAt)
    }
}
