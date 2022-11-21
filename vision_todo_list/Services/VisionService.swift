//
//  VisionService.swift
//  vision_todo_list
//
//  Created by Gatien DIDRY on 20/11/2022.
//

import Vision
import UIKit

class VisionService {

    let viewController: HomeViewController

    init(viewController: HomeViewController) {
        self.viewController = viewController
    }

    @objc func performTextRecognizing(image: UIImage) {

        guard let cgImage = image.cgImage else {
                   print("Unable to find image")
                   return
               }

        let requestHandler = VNImageRequestHandler(cgImage: cgImage)

        let request = VNRecognizeTextRequest(completionHandler: recognizeTextHandler)

        do {
            try requestHandler.perform([request])
         } catch {
            print("Unable to perform the requests: \(error).")
        }
    }

    func recognizeTextHandler(request: VNRequest, error: Error?) {
        guard let observations =
                request.results as? [VNRecognizedTextObservation] else {
            return
        }
        let recognizedStrings = observations.compactMap { observation in
            // Return the string of the top VNRecognizedText instance.
            return observation.topCandidates(1).first?.string
        }

        // Process the recognized strings.
        self.viewController.goToNextScreen(elements: recognizedStrings)
    }

}
