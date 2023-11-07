//
//  CameraViewController.swift
//  Knightrodex
//
//  Created by Max Bagatini Alves on 11/6/23.
//

import AVFoundation
import UIKit

class CameraViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var captureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    
    var user = User.getUserLogin()
    var isAvailable = true

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupQRCodeScanner()
    }
    
    func setupQRCodeScanner() {
        // Get the back-facing camera for capturing videos
        //let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera], mediaType: AVMediaType.video, position: .back)

        guard let captureDevice = AVCaptureDevice.default(for: .video) else {
            print("No video camera available.")
            return
        }

        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)

            // Set the input device on the capture session.
            captureSession.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            
            // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            
            // Initialize QR Code Frame to highlight the QR code
            qrCodeFrameView = UIView()

            if let qrCodeFrameView = qrCodeFrameView {
                qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
                qrCodeFrameView.layer.borderWidth = 2
                view.addSubview(qrCodeFrameView)
                view.bringSubviewToFront(qrCodeFrameView)
            }
            
            DispatchQueue.global(qos: .background).async {
                self.captureSession.startRunning()
            }
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            print("No QR code is detected")
            return
        }

        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject

        if metadataObj.type == AVMetadataObject.ObjectType.qr {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds

            if metadataObj.stringValue != nil {
                scanBadge(badgeId: metadataObj.stringValue!);
            }
        }
    }
    
    func scanBadge(badgeId: String) {
        if (!isAvailable) {
            return;
        }
        isAvailable = false;
        
        addBadge(userId: user.userId, badgeId: badgeId) { result in
            switch result {
            case .success(let badge):
                DispatchQueue.main.async {
                    if (self.isInvalidBadge(badge: badge)) {
                        self.showAlert(title: "Badge Scan Failed", message: badge.error)
                        return
                    }
                    
                    // TODO: Delegate to refresh Table View & Open Badge Screen
                    // ...
                    self.dismiss(animated: true, completion: nil);
                }
            case .failure(let error):
                print("Badge Scan API Call Error: \(error)")
                DispatchQueue.main.async {
                    self.showAlert(title: "Badge Scan Error", message: error.localizedDescription)
                }
            }
        }
    }

    func isInvalidBadge(badge: Badge) -> Bool {
        return (badge.error.count > 0)
    }

    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )

        let okAction = UIAlertAction(
            title: "Dismiss",
            style: .default,
            handler: { action in
                self.isAvailable = true
            }
        )

        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
