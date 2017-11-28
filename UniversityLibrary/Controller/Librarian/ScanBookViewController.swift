//
//  ScanBookViewController.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 11/27/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import UIKit
import AVFoundation

class ScanBookViewController: UIViewController {
    // Properties
    
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var footerView: UIView!
    
    var barcodeFrame: UIView?
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    let supportedCodeTypes = [AVMetadataObject.ObjectType.upce,
                              AVMetadataObject.ObjectType.code39,
                              AVMetadataObject.ObjectType.code39Mod43,
                              AVMetadataObject.ObjectType.code93,
                              AVMetadataObject.ObjectType.code128,
                              AVMetadataObject.ObjectType.ean8,
                              AVMetadataObject.ObjectType.ean13,
                              AVMetadataObject.ObjectType.aztec,
                              AVMetadataObject.ObjectType.pdf417]
    
    // View Lifecyle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureAVFoundation()
    }
    
    // Barscanning method
    
    // TODO: - This method can be better
    func configureAVFoundation() {
        
        // Initialize device object and set it's media type
        let captureDevice = AVCaptureDevice.default(for: .video)
        
        do {
            
            // Store input from device
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            
            // Create capture session and add input
            captureSession = AVCaptureSession()
            captureSession?.addInput(input)
            
            // Store output and add to session
            let captureMetaDataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetaDataOutput)
            
            // Select code types for output
            captureMetaDataOutput.setMetadataObjectsDelegate(self as AVCaptureMetadataOutputObjectsDelegate, queue: DispatchQueue.main)
            captureMetaDataOutput.metadataObjectTypes = supportedCodeTypes
            
            // Add session to preview layer and configure preview frame
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer?.frame = cameraView.layer.bounds
            // TODO: - Fix this and unwrap properly
            cameraView.layer.addSublayer(videoPreviewLayer!)
            
            // Begin session
            captureSession?.startRunning()
            
            // Set up frame for barcode
            barcodeFrame = UIView()
            
            if let barcodeFrame = barcodeFrame {
                barcodeFrame.layer.borderColor = UIColor.green.cgColor
                barcodeFrame.layer.borderWidth = 2
                view.addSubview(barcodeFrame)
                cameraView.bringSubview(toFront: barcodeFrame)
                
            }
            
        } catch {
            // TODO: - Handle error!
            print("Error catching")
            return
        }
    }
    
}

// AVCapture Method
extension ScanBookViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        // Set barcode's frame to zero if no data is detected
        if metadataObjects == nil || metadataObjects.count == 0 {
            barcodeFrame?.frame = CGRect.zero
            print("No barcode decoded")
        }
        
        // TODO: - Work on fixing this if barcode cannot be interpretted
        guard let metadataObj = metadataObjects[0] as? AVMetadataMachineReadableCodeObject else {
            print("Could not read this code")
            return
        }
        
        // If data detected is compatible with barcode reader
        if supportedCodeTypes.contains(metadataObj.type) {
            let barcodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            
            // TODO: - Unwrap this carefully
            self.barcodeFrame?.frame = (barcodeObject?.bounds)!
            
            print("This is the type: \(metadataObj.type)")
            print("This is the barcode value: \(metadataObj.stringValue)")
            
        } else {
            print("ERROOORRR")
        }
        
    }
    
}
