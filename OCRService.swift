```swift
import Foundation
import Vision

class OCRService {
    
    // This function uses Vision's OCR to extract text from an image
    func extractText(from image: UIImage, completion: @escaping (String?, Error?) -> Void) {
        guard let cgImage = image.cgImage else {
            completion(nil, NSError(domain: "OCRServiceError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to convert UIImage to CGImage"]))
            return
        }
        
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        let request = VNRecognizeTextRequest { (request, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                completion(nil, NSError(domain: "OCRServiceError", code: 2, userInfo: [NSLocalizedDescriptionKey: "Failed to get text observations"]))
                return
            }
            
            let recognizedText = observations.compactMap { observation in
                return observation.topCandidates(1).first?.string
            }.joined(separator: " ")
            
            completion(recognizedText, nil)
        }
        
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true
        
        do {
            try requestHandler.perform([request])
        } catch {
            completion(nil, error)
        }
    }
}
```
