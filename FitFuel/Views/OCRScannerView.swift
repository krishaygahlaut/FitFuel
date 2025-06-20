import SwiftUI
import VisionKit
import Vision

struct OCRScannerView: UIViewControllerRepresentable {
    @Binding var scannedText: String

    func makeCoordinator() -> Coordinator {
        Coordinator(scannedText: $scannedText)
    }

    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let scanner = VNDocumentCameraViewController()
        scanner.delegate = context.coordinator
        return scanner
    }

    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) {}

    class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        @Binding var scannedText: String

        init(scannedText: Binding<String>) {
            _scannedText = scannedText
        }

        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            controller.dismiss(animated: true)

            var fullText = ""

            let request = VNRecognizeTextRequest { request, error in
                if let results = request.results as? [VNRecognizedTextObservation] {
                    for result in results {
                        if let top = result.topCandidates(1).first {
                            fullText += top.string + "\n"
                        }
                    }
                }
                self.scannedText = fullText
            }

            request.recognitionLevel = .accurate

            let queue = DispatchQueue(label: "OCR")
            queue.async {
                for i in 0..<scan.pageCount {
                    let image = scan.imageOfPage(at: i)
                    if let cgImage = image.cgImage {
                        let handler = VNImageRequestHandler(cgImage: cgImage)
                        try? handler.perform([request])
                    }
                }
            }
        }
    }
}
