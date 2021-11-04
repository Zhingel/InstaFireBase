//
//  CameraController.swift
//  InstaFireBase
//
//  Created by Стас Жингель on 02.11.2021.
//

import Foundation
import UIKit
import AVFoundation

class CameraController: UIViewController, AVCapturePhotoCaptureDelegate {
    var selectedImage: UIImage?
    let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.85
        return view
    }()
    let footerView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.85
        return view
    }()
    let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "cancel_shadow"), for: .normal)
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        return button
    }()
    let capturePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "capture_photo"), for: .normal)
        button.addTarget(self, action: #selector(capturePhoto), for: .touchUpInside)
        return button
    }()
    
    @objc func capturePhoto() {
        let settings = AVCapturePhotoSettings()
        output.capturePhoto(with: settings, delegate: self)
        
    }
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {

         if let error = error {
             print("error occured : \(error.localizedDescription)")
         }

         if let dataImage = photo.fileDataRepresentation() {

             let dataProvider = CGDataProvider(data: dataImage as CFData)
             let cgImageRef: CGImage! = CGImage(jpegDataProviderSource: dataProvider!, decode: nil, shouldInterpolate: true, intent: .defaultIntent)
             let image = UIImage(cgImage: cgImageRef, scale: 1.0, orientation: UIImage.Orientation.right)
             self.selectedImage = image
             let preview = PreviewPhotoContainer()
             let navController = UINavigationController(rootViewController: preview)
             preview.imageView.image = self.selectedImage
             preview.selectedImage = self.selectedImage
             navController.modalPresentationStyle = .fullScreen
             present(navController,animated: false)
             
         } else {
             print("some error here")
         }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupCaptureSession()
        view.addSubview(headerView)
        view.addSubview(footerView)
        view.addSubview(capturePhotoButton)
        view.addSubview(cancelButton)
        let height = (view.bounds.height - view.bounds.width)/2
        cancelButton.constraints(top: view.topAnchor, bottom: nil, left: view.leftAnchor, right: nil, paddingTop: 12, paddingBottom: 0, paddingLeft: 12, paddingRight: 0, width: 50, height: 50)
        footerView.constraints(top: nil, bottom: view.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: height)
        headerView.constraints(top: view.topAnchor, bottom: nil, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: height)
       
        capturePhotoButton.constraints(top: nil, bottom: view.bottomAnchor, left: nil, right: nil, paddingTop: 0, paddingBottom: -24, paddingLeft: 0, paddingRight: 0, width: 80, height: 80)
        capturePhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    let output = AVCapturePhotoOutput()
    fileprivate func setupCaptureSession() {
        let captureSession = AVCaptureSession()
        guard let videoDevice = AVCaptureDevice.default(for: .video) else { return }

        do {
            let videoInput = try AVCaptureDeviceInput(device: videoDevice)
            if captureSession.canAddInput(videoInput) {
                captureSession.addInput(videoInput)
            }
        } catch {
            print("Some Error")
        }
        
        if captureSession.canAddOutput(output) {
            captureSession.addOutput(output)
        }
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.frame
        view.layer.addSublayer(previewLayer)
        captureSession.startRunning()
    }
    @objc fileprivate func handleCancel() {
        dismiss(animated: true)
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
