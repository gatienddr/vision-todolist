//
//  HomeViewController.swift
//  vision_todo_list
//
//  Created by Gatien DIDRY on 12/11/2022.
//

import UIKit
import Vision
import PhotosUI

class HomeViewController: UIViewController, UIImagePickerControllerDelegate,
                          UINavigationControllerDelegate,
                          PHPickerViewControllerDelegate {

    var visionService: VisionService?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.visionService = VisionService(viewController: self)

        // MARK: Organize view
        view.backgroundColor = .systemBackground
        title = "Home"
        navigationController?.navigationBar.prefersLargeTitles = true

        // MARK: Setup camera button
        let buttonCamera = UIButton()

        buttonCamera.configuration = .bordered()
        buttonCamera.setTitle("Open the camera", for: .normal)
        buttonCamera.setImage(UIImage(systemName: "camera"), for: .normal)
        buttonCamera.translatesAutoresizingMaskIntoConstraints = false

        buttonCamera.addTarget(self, action: #selector(useCamera), for: .touchUpInside)

        // MARK: Setup library-pitures button
        let buttonLibrary = UIButton()

        buttonLibrary.configuration = .bordered()
        buttonLibrary.setTitle("Open the library", for: .normal)
        buttonLibrary.setImage(UIImage(systemName: "book"), for: .normal)
        buttonLibrary.translatesAutoresizingMaskIntoConstraints = false

        buttonLibrary.addTarget(self, action: #selector(useLibrary), for: .touchUpInside )

        // MARK: Center buttons in screen space
        let buttonsView = UIView()

        view.addSubview(buttonsView)

        buttonsView.translatesAutoresizingMaskIntoConstraints = false

        buttonsView.addSubview(buttonCamera)
        buttonsView.addSubview(buttonLibrary)

        // MARK: Constraints
        NSLayoutConstraint.activate([
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            buttonsView.widthAnchor.constraint(equalToConstant: 200),
            buttonsView.heightAnchor.constraint(equalToConstant: 200),

            buttonCamera.widthAnchor.constraint(equalTo: buttonsView.widthAnchor),
            buttonCamera.heightAnchor.constraint(equalToConstant: 30),

            buttonLibrary.widthAnchor.constraint(equalTo: buttonsView.widthAnchor),
            buttonLibrary.heightAnchor.constraint(equalToConstant: 30),
            buttonLibrary.topAnchor.constraint(equalTo: buttonCamera.bottomAnchor, constant: 100)
        ])

    }

    @objc func goToNextScreen(elements: [String]) {
        let nextScreen = TodoListTableViewController()
        nextScreen.elements = elements
        navigationController?.pushViewController(nextScreen, animated: true)
    }

    @objc func useCamera() {

        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self

        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePickerController.sourceType = .camera
            self.present(imagePickerController, animated: true, completion: nil)

        } else {
            print("Camera not avaible")
        }

    }

    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        picker.dismiss(animated: true)
        guard let image = info[.originalImage] as? UIImage else {
                print("No image found")
                return
            }

        self.visionService?.performTextRecognizing(image: image)

    }

    @objc func useLibrary() {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.selectionLimit = 1
        config.filter = .images

        let phVc = PHPickerViewController(configuration: config)
        phVc.delegate = self
        self.present(phVc, animated: true)

    }

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)

        results.first?.itemProvider.loadObject(ofClass: UIImage.self) { reading, error in

            guard let image = reading as? UIImage, error == nil else {
                return
            }

            DispatchQueue.main.async {

                self.visionService?.performTextRecognizing(image: image)

            }
        }
    }

}
