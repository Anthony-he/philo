import Foundation
import SwiftData

enum Mood: String, CaseIterable, Codable, Identifiable {
    case anxious = "anxious"
    case sad = "sad"
    case angry = "angry"
    case lonely = "lonely"
    case overwhelmed = "overwhelmed"
    case melancholic = "melancholic"
    case uncertain = "uncertain"
    case weary = "weary"
    case joyful = "joyful"
    case grateful = "grateful"
    case hopeful = "hopeful"
    case contemplative = "contemplative"
    case peaceful = "peaceful"
    case inspired = "inspired"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .anxious: return "焦虑"
        case .sad: return "悲伤"
        case .angry: return "愤怒"
        case .lonely: return "孤独"
        case .overwhelmed: return "不堪重负"
        case .melancholic: return "忧郁"
        case .uncertain: return "迷茫"
        case .weary: return "疲惫"
        case .joyful: return "喜悦"
        case .grateful: return "感恩"
        case .hopeful: return "充满希望"
        case .contemplative: return "沉思"
        case .peaceful: return "平静"
        case .inspired: return "受鼓舞"
        }
    }
    
    var systemImage: String {
        switch self {
        case .anxious: return "heart.circle"
        case .sad: return "cloud.rain"
        case .angry: return "flame"
        case .lonely: return "moon.stars"
        case .overwhelmed: return "hurricane"
        case .melancholic: return "cloud.sun"
        case .uncertain: return "questionmark.circle"
        case .weary: return "zzz"
        case .joyful: return "sun.max"
        case .grateful: return "heart"
        case .hopeful: return "sparkles"
        case .contemplative: return "books.vertical"
        case .peaceful: return "leaf"
        case .inspired: return "star"
        }
    }
    
    var colorName: String {
        switch self {
        case .anxious: return "MoodAnxious"
        case .sad: return "MoodSad"
        case .angry: return "MoodAngry"
        case .lonely: return "MoodLonely"
        case .overwhelmed: return "MoodOverwhelmed"
        case .melancholic: return "MoodMelancholic"
        case .uncertain: return "MoodUncertain"
        case .weary: return "MoodWeary"
        case .joyful: return "MoodJoyful"
        case .grateful: return "MoodGrateful"
        case .hopeful: return "MoodHopeful"
        case .contemplative: return "MoodContemplative"
        case .peaceful: return "MoodPeaceful"
        case .inspired: return "MoodInspired"
        }
    }
}

extension Mood {
    static let negativeMoods: Set<Mood> = [.anxious, .sad, .angry, .lonely, .overwhelmed, .melancholic, .uncertain, .weary]
    static let positiveMoods: Set<Mood> = [.joyful, .grateful, .hopeful, .peaceful, .inspired]
    static let neutralMoods: Set<Mood> = [.contemplative]
}
