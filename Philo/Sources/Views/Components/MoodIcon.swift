import SwiftUI

struct MoodIcon: View {
    let mood: Mood
    var size: CGFloat = 44
    var isSelected: Bool = false
    
    var body: some View {
        VStack(spacing: 4) {
            ZStack {
                Circle()
                    .fill(isSelected ? moodColor : moodColor.opacity(0.15))
                    .frame(width: size, height: size)
                
                Image(systemName: mood.systemImage)
                    .font(.system(size: size * 0.45))
                    .foregroundColor(isSelected ? .white : moodColor)
            }
            
            Text(mood.displayName)
                .font(.system(size: 10, weight: isSelected ? .semibold : .regular))
                .foregroundColor(isSelected ? moodColor : .secondary)
                .lineLimit(1)
        }
        .frame(width: size + 8)
    }
    
    private var moodColor: Color {
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
    HStack(spacing: 16) {
        MoodIcon(mood: .anxious, isSelected: true)
        MoodIcon(mood: .joyful)
        MoodIcon(mood: .peaceful, size: 60, isSelected: true)
    }
    .padding()
}
