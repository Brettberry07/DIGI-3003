import Foundation

struct Emoji: Codable {
    var symbol: String
    var name: String
    var description: String
    var usage: String
    
    static func sampleEmojis() -> [Emoji] {
        return [
            Emoji(symbol: "😀", name: "Grinning Face", description: "A typical smiley face.", usage: "happiness"),
            Emoji(symbol: "😕", name: "Confused Face", description: "A confused, puzzled face.", usage: "unsure what to think; displeasure"),
            Emoji(symbol: "😍", name: "Heart Eyes", description: "A smiley face with hearts for eyes.", usage: "love of something; attractive"),
            Emoji(symbol: "👮‍♀️", name: "Police Officer", description: "A police officer wearing a blue cap with a gold badge.", usage: "person of authority"),
            Emoji(symbol: "🐢", name: "Turtle", description: "A cute turtle.", usage: "something slow"),
            Emoji(symbol: "🐘", name: "Elephant", description: "A gray elephant.", usage: "something big"),
            Emoji(symbol: "🍝", name: "Spaghetti", description: "A plate of spaghetti.", usage: "spaghetti"),
            Emoji(symbol: "🎲", name: "Die", description: "A single die, used in games.", usage: "taking a risk; chance"),
            Emoji(symbol: "⛺️", name: "Tent", description: "A small tent.", usage: "camping"),
            Emoji(symbol: "📚", name: "Stack of Books", description: "A stack of three colored books.", usage: "homework, studying"),
            Emoji(symbol: "💔", name: "Broken Heart", description: "A red, broken heart.", usage: "extreme sadness"),
            Emoji(symbol: "💡", name: "Light Bulb", description: "A light bulb, used to represent an idea.", usage: "a new idea"),
            Emoji(symbol: "📎", name: "Paperclip", description: "A silver paperclip.", usage: "organization"),
            Emoji(symbol: "🧑‍💻", name: "Technologist", description: "A person working on a laptop.", usage: "technology, software, coding"),
            Emoji(symbol: "🎉", name: "Party Popper", description: "A party popper, as used for celebrating.", usage: "celebration"),
            Emoji(symbol: "🌺", name: "Hibiscus", description: "A pink hibiscus flower.", usage: "beautiful, tropical"),
            Emoji(symbol: "🦄", name: "Unicorn", description: "A magical unicorn.", usage: "mythical, special"),
            Emoji(symbol: "🍕", name: "Pizza", description: "A slice of pizza.", usage: "favorite food")
        ]
    }
    
    static let archiveURL: URL = {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent("emojis").appendingPathExtension("plist")
    }()
    
    static func saveToFile(emojis: [Emoji]){
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(emojis)
            try data.write(to: archiveURL, options: .noFileProtection)
        } catch {
            print("Error saving emojis: \(error)")
        }
    }
    
    static func loadFromFile() -> [Emoji]?{
        let decoder = PropertyListDecoder()
        do {
            let data = try Data(contentsOf: archiveURL)
            let emojis = try decoder.decode([Emoji].self, from: data)
            return emojis
        } catch {
            print("Error loading emojis: \(error)")
            return []
        }
    }
}
