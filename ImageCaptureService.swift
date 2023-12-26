```swift
import UIKit
import AVFoundation

class ImageCaptureService: NSObject {
    
    private var captureSession: AVCaptureSession?
    private var stillImageOutput: AVCapturePhotoOutput?
    private var previewLayer: AVCaptureVideoPreviewLayer?
    
    // This function sets up the camera capture session
    func setupSession() {
        captureSession = AVCaptureSession()
        captureSession?.sessionPreset = .photo
        
        guard let backCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
              let input = try? AVCaptureDeviceInput(device: backCamera) else {
            print("Unable to access back camera!")
            return
        }
        
        stillImageOutput = AVCapturePhotoOutput()
        
        if captureSession?.canAddInput(input) ?? false, captureSession?.canAddOutput(stillImageOutput!) ?? false {
            captureSession?.addInput(input)
            captureSession?.addOutput(stillImageOutput!)
            setupLivePreview()
        }
    }
    
    // This function sets up the live camera preview
    func setupLivePreview(view: UIView) {
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        previewLayer?.videoGravity = .resizeAspect
        previewLayer?.connection?.videoOrientation = .portrait
        view.layer.addSublayer(previewLayer!)
        
        // Start the session
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.captureSession?.startRunning()
            DispatchQueue.main.async {
                self?.previewLayer?.frame = view.bounds
            }
        }
    }
    
    // This function captures the image
    func captureImage(completion: @escaping (UIImage?, Error?) -> Void) {
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        stillImageOutput?.capturePhoto(with: settings, delegate: self)
    }
    
    // This function stops the camera preview
    func stopSession() {
        captureSession?.stopRunning()
    }
}

extension ImageCaptureService: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation() else {
            return
        }
        let image = UIImage(data: imageData)
        completion(image, nil)
    }
}
```
