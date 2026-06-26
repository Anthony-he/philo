import Foundation
import UserNotifications

final class NotificationService {
    
    static let shared = NotificationService()
    
    private init() {}
    
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if granted {
                self.scheduleDailyQuote()
            }
        }
    }
    
    func scheduleDailyQuote() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["dailyQuote"])
        
        let content = UNMutableNotificationContent()
        content.title = "今日哲思"
        content.sound = .default
        
        if let quote = QuoteService.shared.dailyQuote() {
            content.body = "「\(quote.text)」—— \(quote.author)"
        } else {
            content.body = "新的一天，愿你心中有光。"
        }
        
        var dateComponents = DateComponents()
        dateComponents.hour = 8
        dateComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "dailyQuote", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func sendTestNotification() {
        let content = UNMutableNotificationContent()
        content.title = "今日哲思"
        content.body = "「此刻即是你全部的生命。」—— 马可·奥勒留"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "test", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func checkScheduledStatus(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            let hasDaily = requests.contains { $0.identifier == "dailyQuote" }
            completion(hasDaily)
        }
    }
}
