```swift
import UIKit

class AnswerViewController: UIViewController {
    
    // UI Components
    private let questionLabel = UIComponents.createLabel(text: "", fontSize: 18)
    private let answerLabel = UIComponents.createLabel(text: "", fontSize: 18)
    private let explanationLabel = UIComponents.createLabel(text: "", fontSize: 18)
    private let activityIndicator = UIComponents.createActivityIndicator()
    
    // Services
    private let gp4Service = GP4Service()
    
    // Variables
    private var question: String?
    
    init(question: String) {
        self.question = question
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchAnswer()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        // Question Label
        questionLabel.text = question
        view.addSubview(questionLabel)
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            questionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            questionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            questionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        // Answer Label
        view.addSubview(answerLabel)
        answerLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            answerLabel.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 20),
            answerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            answerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        // Explanation Label
        view.addSubview(explanationLabel)
        explanationLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            explanationLabel.topAnchor.constraint(equalTo: answerLabel.bottomAnchor, constant: 20),
            explanationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            explanationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        // Activity Indicator
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func fetchAnswer() {
        guard let question = question else { return }
        
        activityIndicator.startAnimating()
        
        gp4Service.sendQuestion(question) { [weak self] (answer, error) in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                
                if let error = error {
                    let alert = UIComponents.createAlert(title: "Error", message: error.localizedDescription, actionTitle: "OK")
                    self?.present(alert, animated: true, completion: nil)
                    return
                }
                
                if let answer = answer {
                    // Assuming the answer and explanation are separated by a newline
                    let components = answer.components(separatedBy: "\n")
                    self?.answerLabel.text = "Answer: \(components.first ?? "")"
                    self?.explanationLabel.text = "Explanation: \(components.last ?? "")"
                }
            }
        }
    }
}
```
