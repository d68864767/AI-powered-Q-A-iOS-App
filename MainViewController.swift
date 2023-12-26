```swift
import UIKit

class MainViewController: UIViewController {
    
    // MARK: - Properties
    private let imageCaptureService = ImageCaptureService()
    private let ocrService = OCRService()
    private let gp4Service = GP4Service()
    
    // MARK: - UI Elements
    private let captureButton: UIButton = {
        let button = UIButton()
        button.setTitle("Capture Question", for: .normal)
        button.backgroundColor = .systemBlue
        button.addTarget(self, action: #selector(captureButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        imageCaptureService.setupSession()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        imageCaptureService.startSession()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        imageCaptureService.stopSession()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.addSubview(captureButton)
        captureButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            captureButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            captureButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            captureButton.widthAnchor.constraint(equalToConstant: 200),
            captureButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: - Actions
    @objc private func captureButtonTapped() {
        imageCaptureService.captureImage { [weak self] image in
            guard let self = self, let image = image else { return }
            self.ocrService.extractText(from: image) { text, error in
                guard let text = text, error == nil else {
                    // Handle error
                    return
                }
                self.gp4Service.sendQuestion(text) { answer, error in
                    guard let answer = answer, error == nil else {
                        // Handle error
                        return
                    }
                    // Navigate to AnswerViewController with the answer
                    let answerVC = AnswerViewController()
                    answerVC.answer = answer
                    self.navigationController?.pushViewController(answerVC, animated: true)
                }
            }
        }
    }
}
```
