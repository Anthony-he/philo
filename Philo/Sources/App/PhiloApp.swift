import SwiftUI
import SwiftData

@main
struct PhiloApp: App {
    
    @State private var showSplash = true
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if showSplash {
                    SplashView()
                        .transition(.opacity)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                withAnimation(.easeOut(duration: 0.5)) {
                                    showSplash = false
                                }
                            }
                        }
                } else {
                    MainTabView()
                }
            }
            .modelContainer(for: [MoodEntry.self])
        }
    }
}

struct MainTabView: View {
    
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        TabView {
            DailyQuoteView()
                .tabItem {
                    Label("今日", systemImage: "sun.max")
                }
            
            MoodSelectionView()
                .tabItem {
                    Label("心情", systemImage: "heart")
                }
            
            HistoryView()
                .tabItem {
                    Label("日记", systemImage: "book")
                }
        }
        .tint(.blue)
        .tabViewStyle(.tabBar)
    }
}

struct SplashView: View {
    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0.0
    @State private var tagOpacity: Double = 0.0
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.blue.opacity(0.1), .purple.opacity(0.1)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 16) {
                Image(systemName: "book.closed.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .scaleEffect(scale)
                
                Text("Philo")
                    .font(.system(size: 42, weight: .bold, design: .serif))
                    .foregroundColor(.primary)
                
                Text("哲学慰藉")
                    .font(.system(size: 16))
                    .foregroundColor(.secondary)
                    .opacity(tagOpacity)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                scale = 1.0
                opacity = 1.0
            }
            withAnimation(.easeIn(duration: 0.8).delay(0.3)) {
                tagOpacity = 1.0
            }
        }
    }
}
