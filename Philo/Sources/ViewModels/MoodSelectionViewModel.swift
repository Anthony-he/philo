import Foundation
import Observation

@Observable
final class MoodSelectionViewModel {
    var selectedMood: Mood?
    var matchedQuotes: [Quote] = []
    var isLoading = false
    var hasSearched = false
    
    let moods: [Mood] = Mood.allCases
    
    func selectMood(_ mood: Mood) {
        selectedMood = mood
        isLoading = true
        hasSearched = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            guard let self else { return }
            let quotes = QuoteService.shared.quotes(for: mood, limit: 10)
            self.matchedQuotes = quotes
            self.isLoading = false
            self.hasSearched = true
        }
    }
    
    func clearSelection() {
        selectedMood = nil
        matchedQuotes = []
        hasSearched = false
    }
}
