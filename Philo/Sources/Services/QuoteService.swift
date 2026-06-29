import Foundation

final class QuoteService {
    
    static let shared = QuoteService()
    
    private var allQuotes: [Quote] = []
    
    private init() {}
    
    func loadQuotes() -> [Quote] {
        if !allQuotes.isEmpty { return allQuotes }
        
        guard let url = Bundle.main.url(forResource: "quotes", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let quotes = try? JSONDecoder().decode([Quote].self, from: data) else {
            return []
        }
        
        allQuotes = quotes
        return quotes
    }
    
    func quotes(for mood: Mood) -> [Quote] {
        let quotes = loadQuotes()
        let moodRaw = mood.rawValue
        let matching = quotes.filter { $0.moodCategories.contains(moodRaw) }
        return matching.shuffled()
    }
    
    func quotes(for mood: Mood, limit: Int = 10) -> [Quote] {
        let quotes = loadQuotes()
        let moodRaw = mood.rawValue
        let matching = quotes.filter { $0.moodCategories.contains(moodRaw) }
        return Array(matching.shuffled().prefix(limit))
    }
    
    func dailyQuote() -> Quote? {
        let quotes = loadQuotes()
        guard !quotes.isEmpty else { return nil }
        
        let calendar = Calendar.current
        let dayOfYear = calendar.ordinality(of: .day, in: .year, for: Date()) ?? 0
        let index = dayOfYear % quotes.count
        return quotes[index]
    }
    
    func randomQuote() -> Quote? {
        loadQuotes().randomElement()
    }
    
    func searchQuotes(query: String) -> [Quote] {
        let quotes = loadQuotes()
        let lowercased = query.lowercased()
        return quotes.filter {
            $0.text.lowercased().contains(lowercased) ||
            $0.author.lowercased().contains(lowercased) ||
            $0.tags.contains { $0.lowercased().contains(lowercased) }
        }
    }
}
