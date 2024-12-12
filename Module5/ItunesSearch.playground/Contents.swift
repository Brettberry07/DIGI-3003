import Foundation

var urlComponents = URLComponents(string: "https://itunes.apple.com/search")!
urlComponents.queryItems = [
    URLQueryItem(name: "term", value: "Metallica"),
    URLQueryItem(name: "media", value: "music"),
].map { URLQueryItem(name: $0.name, value: $0.value) }

Task {
    let (data, response) = try await URLSession.shared.data(from: urlComponents.url!)
    
    if let httpResponse = response as? HTTPURLResponse,
       httpResponse.statusCode == 200,
       let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
        let results = json["results"] as? [[String: Any]]
        
        for result in results ?? [] {
            print(result["trackName"] as? String ?? "")
        }
    }
}
