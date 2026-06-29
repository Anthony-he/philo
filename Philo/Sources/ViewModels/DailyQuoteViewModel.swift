import Foundation
import Observation

@Observable
final class DailyQuoteViewModel {
    var todayQuote: Quote?
    var isLoading = true
    
    func loadDailyQuote() {
        isLoading = true
        todayQuote = QuoteService.shared.dailyQuote()
        isLoading = false
    }
    
    func refreshQuote() {
        todayQuote = QuoteService.shared.randomQuote()
    }
}
