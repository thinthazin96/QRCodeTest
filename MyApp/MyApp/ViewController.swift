//
//  ViewController.swift
//  MyApp
//
//  Created by Thazin, Thin on 2/25/20.
//  Copyright © 2020 Thazin, Thin. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    let session = AVCaptureSession()
    var camera : AVCaptureDevice?
    // user can see what camera is seeing
    var cameraPreviewLayer : AVCaptureVideoPreviewLayer?
    var cameraCaptureOutput : AVCapturePhotoOutput?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeCaptureSession()
        // Do any additional setup after loading the view.
    }
    func  displayCaptureedPhoto(capturedPhoto : UIImage) {
        let ImagePreviewViewController = storyboard?.instantiateViewController(identifier: "ImagePreviewViewController")as! ImagePreviewViewController
        ImagePreviewViewController.capturedImage = capturedPhoto
        navigationController?.pushViewController(ImagePreviewViewController, animated: true)
    }
    @IBAction func takepicture(_ sender: Any) {
        takePicture()
    }
    
    func initializeCaptureSession(){
        
        //quality level of the camera view
        session.sessionPreset = AVCaptureSession.Preset.high
        
        camera = AVCaptureDevice.default(for: AVMediaType.video)
        
        do {
            let cameraCaptureInput = try AVCaptureDeviceInput(device: camera!)
            cameraCaptureOutput = AVCapturePhotoOutput()
            
            session.addInput(cameraCaptureInput)
            session.addOutput(cameraCaptureOutput!)
        } catch {
            print(error.localizedDescription)
        }
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        // setting frame of the camera
        cameraPreviewLayer?.frame = view.bounds
        cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        // setting cameraPreviewLayer as sublayer
        view.layer.insertSublayer(cameraPreviewLayer!, at: 0)
        
        session.startRunning()
    }
    func takePicture(){
        let settings = AVCapturePhotoSettings()
        settings.flashMode = .auto
        cameraCaptureOutput?.capturePhoto(with: settings, delegate: self)
    }

}
extension ViewController : AVCapturePhotoCaptureDelegate{
         
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        
        if let unwrappedError = error{
            print(unwrappedError.localizedDescription)
        }else {
            if let sampleBuffer = photoSampleBuffer, let dataImage = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: sampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer){
                
                if let finalImage = UIImage(data: dataImage){
                    
                    displayCaptureedPhoto(capturedPhoto: finalImage)
                    
                }
            }
            
        }
    }
}

