import Foundation
import SwiftData

@Model
final class Quote: Codable, Identifiable {
    
    @Attribute(.unique) var id: UUID
    var text: String
    var author: String
    var source: String
    var era: String
    var tags: [String]
    var moodCategories: [String]
    
    init(id: UUID = UUID(), text: String, author: String, source: String = "", era: String = "", tags: [String] = [], moodCategories: [String] = []) {
        self.id = id
        self.text = text
        self.author = author
        self.source = source
        self.era = era
        self.tags = tags
        self.moodCategories = moodCategories
    }
    
    enum CodingKeys: String, CodingKey {
        case id, text, author, source, era, tags, moodCategories
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        text = try container.decode(String.self, forKey: .text)
        author = try container.decode(String.self, forKey: .author)
        source = try container.decodeIfPresent(String.self, forKey: .source) ?? ""
        era = try container.decodeIfPresent(String.self, forKey: .era) ?? ""
        tags = try container.decodeIfPresent([String].self, forKey: .tags) ?? []
        moodCategories = try container.decodeIfPresent([String].self, forKey: .moodCategories) ?? []
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(text, forKey: .text)
        try container.encode(author, forKey: .author)
        try container.encode(source, forKey: .source)
        try container.encode(era, forKey: .era)
        try container.encode(tags, forKey: .tags)
        try container.encode(moodCategories, forKey: .moodCategories)
    }
}
