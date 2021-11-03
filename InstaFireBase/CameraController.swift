//
//  CameraController.swift
//  InstaFireBase
//
//  Created by Стас Жингель on 02.11.2021.
//

import Foundation
import UIKit
import AVFoundation

class CameraController: UIViewController {
    let dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "right_arrow_shadow"), for: .normal)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    let capturePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "capture_photo"), for: .normal)
        button.addTarget(self, action: #selector(capturePhoto), for: .touchUpInside)
        return button
    }()
    @objc func handleDismiss() {
        dismiss(animated: true)
    }
    @objc func capturePhoto() {
        dismiss(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupCaptureSession()
        view.addSubview(capturePhotoButton)
        view.addSubview(dismissButton)
        dismissButton.constraints(top: view.topAnchor, bottom: nil, left: nil, right: view.rightAnchor, paddingTop: 12, paddingBottom: 0, paddingLeft: 0, paddingRight: 12, width: 50, height: 50)
        capturePhotoButton.constraints(top: nil, bottom: view.bottomAnchor, left: nil, right: nil, paddingTop: 0, paddingBottom: -24, paddingLeft: 0, paddingRight: 0, width: 80, height: 80)
        capturePhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
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
        
        let output = AVCapturePhotoOutput()
        captureSession.addOutput(output)
        if captureSession.canAddOutput(output) {
            captureSession.addOutput(output)
        }
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.frame
        view.layer.addSublayer(previewLayer)
        captureSession.startRunning()
    }
}
