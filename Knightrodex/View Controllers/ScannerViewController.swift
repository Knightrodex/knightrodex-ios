//
//  ScannerViewController.swift
//  Knightrodex
//
//  Created by Ramir Dalencour on 11/3/23.
//

import AVFoundation
import UIKit

class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("loaded scan vc")
        
        let user = User.getUserLogin()
        
        print("This is coming from the User Default")
        print("UserId: \(user.userId)")
        print(user)
    }
    
    
    @IBAction func didTapQrButton(_ sender: UIButton) {
        print("test!")
        self.setupQRCodeScanner()
    }
    
    // Implement the setupQRCodeScanner function
    func setupQRCodeScanner() {
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            print("No video camera available.")
            return
        }
        
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            print(error)
            return
        }
        
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            print("Could not add video input to the session.")
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            print("Could not add metadata output to the session.")
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        view.layer.addSublayer(previewLayer)
    
        
        DispatchQueue.global(qos: .background).async {
            self.captureSession.startRunning()
        }
        

        
    
    }
    
    // Implement the metadataOutput delegate method
    
    // Note to Self, this is where we get the value
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
           
            
           let qrCodeValue = metadataObject.stringValue {
            print("Scanned QR Code: \(qrCodeValue)")
            
            self.captureSession.stopRunning()
            
            // This is how we stop the scanning
            
            
            previewLayer.removeFromSuperlayer()
        }
    }
}

