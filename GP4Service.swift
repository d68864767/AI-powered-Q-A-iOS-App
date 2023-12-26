```swift
import Foundation

class GP4Service {
    
    // This function sends a question to the GPT-4 API and returns the answer
    func sendQuestion(_ question: String, completion: @escaping (String?, Error?) -> Void) {
        guard let url = URL(string: AppConfig.gpt4BaseUrl) else {
            completion(nil, NSError(domain: "GP4ServiceError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(AppConfig.gpt4ApiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = ["prompt": question, "max_tokens": 60]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, NSError(domain: "GP4ServiceError", code: 2, userInfo: [NSLocalizedDescriptionKey: "No data received from server"]))
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let answer = json["choices"] as? [[String: Any]],
                   let first = answer.first,
                   let text = first["text"] as? String {
                    completion(text, nil)
                } else {
                    completion(nil, NSError(domain: "GP4ServiceError", code: 3, userInfo: [NSLocalizedDescriptionKey: "Failed to parse server response"]))
                }
            } catch {
                completion(nil, error)
            }
        }
        
        task.resume()
    }
}
```
