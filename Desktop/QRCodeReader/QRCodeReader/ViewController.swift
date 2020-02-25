//
//  ViewController.swift
//  QRCodeReader
//
//  Created by Thazin, Thin on 2/25/20.
//  Copyright © 2020 Thazin, Thin. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    @IBOutlet var videoPreview : UIView!
    
    var stringURL = String()
    
    enum error: Error{
        case noCameraAvaliable
        case videoInputInitFail
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        do {
            try scanQRCode()
        } catch{
            print("Fail to scan the QR/Barcode.")
        }
    }
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count > 0 {
            let machineReadableCode = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
            if machineReadableCode.type == AVMetadataObject.ObjectType.qr{
                stringURL = machineReadableCode.stringValue!
                performSegue(withIdentifier: "openLink", sender: self)
            }
        }
    }
    func scanQRCode() throws{
        let avCaptureSession =  AVCaptureSession()
        guard let avCaptureDevice = AVCaptureDevice.default(for: AVMediaType.video) else{
            print("No Camera.")
            throw error.noCameraAvaliable
        }
        guard let avCaptureInput = try?
            AVCaptureDeviceInput(device: avCaptureDevice)else{
                print("Fail to init camera.")
                throw error.videoInputInitFail
        }
        let avCaptureMetadataOutput = AVCaptureMetadataOutput()
        avCaptureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        avCaptureSession.addInput(avCaptureInput)
        avCaptureSession.addOutput(avCaptureMetadataOutput)
        avCaptureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        let avCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: avCaptureSession)
        avCaptureVideoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        avCaptureVideoPreviewLayer.frame = videoPreview.bounds
        
        self.videoPreview.layer.addSublayer(avCaptureVideoPreviewLayer)
        avCaptureSession.startRunning()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openLink" {
            let destination = segue.destination as! WebViewController
            destination.url = URL(string: stringURL)
        }
    }
}

