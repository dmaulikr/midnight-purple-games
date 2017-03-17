//
//  Bird.swift
//  BarcodeReaderTest
//
//  Created by caleb on 10/22/15.
//

import UIKit
import Foundation
import AVFoundation
import Fabric
import Crashlytics

protocol BirdDelegate {
    func readBarcode(code: String)
}

class Bird: UIView, AVCaptureMetadataOutputObjectsDelegate {
    let session = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer!
    var highlightView = UIView()
    var delegate : BirdDelegate?
    
    func start(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) {
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        var input : AVCaptureDeviceInput?
        
        do {
            input = try AVCaptureDeviceInput(device: device)
        } catch {
            print("This device does not have a camera.")
        }
        
        // box to highlight barcode
        self.highlightView.autoresizingMask =   UIViewAutoresizing.FlexibleTopMargin
        self.highlightView.layer.borderColor = UIColor(red: 0, green: 1, blue: 0, alpha: 0.7).CGColor
        self.highlightView.layer.borderWidth = 5
        self.addSubview(self.highlightView)
        
        if input != nil {
            session.addInput(input)
        }
        
        let output = AVCaptureMetadataOutput()
        output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        session.addOutput(output)
        output.metadataObjectTypes = output.availableMetadataObjectTypes
        previewLayer = AVCaptureVideoPreviewLayer(session: session) as AVCaptureVideoPreviewLayer
        previewLayer.frame = CGRectMake(x, y, width, height)
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.layer.addSublayer(previewLayer)
        session.startRunning()
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        var highlightViewRect = CGRectZero
        var barCodeObject : AVMetadataObject!
        var detectionString = ""
        let barCodeTypes = [AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeQRCode, AVMetadataObjectTypeAztecCode]
        
        for metadata in metadataObjects {
            for barcodeType in barCodeTypes {
                if metadata.type == barcodeType {
                    barCodeObject = self.previewLayer.transformedMetadataObjectForMetadataObject(metadata as! AVMetadataMachineReadableCodeObject)
                    highlightViewRect = barCodeObject.bounds
                    detectionString = (metadata as! AVMetadataMachineReadableCodeObject).stringValue
                    self.session.stopRunning()
                    break
                }
                
            }
        }
        
        if let validDelegate = delegate {
            if detectionString == "" {
                clear()
            } else {
                validDelegate.readBarcode(detectionString)
                self.highlightView.frame = highlightViewRect
                self.bringSubviewToFront(self.highlightView)
            }
        }
        
        // analytics
        for metadata in metadataObjects {
            let type: String = metadata.type
            Answers.logCustomEventWithName("Scan", customAttributes: ["type": type])
        }
    }
    
    func end() {
        self.session.stopRunning()
        previewLayer.removeFromSuperlayer()
        highlightView.removeFromSuperview()
    }
    
    func clear() {
        self.sendSubviewToBack(self.highlightView)
        session.startRunning()
    }
}
