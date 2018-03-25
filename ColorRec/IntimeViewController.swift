//
//  ViewController.swift
//  颜色识别
//
//  Created by FuJ on 2017/11/10.
//  Copyright © 2017年 傅建. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class IntimeViewController: UIViewController,AVCapturePhotoCaptureDelegate {
    @IBOutlet var cameraButton:UIButton!
    @IBOutlet weak var colorLabel: UITextField!
    @IBOutlet weak var BackButton: UIButton!
    
    var captureSesssion: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var ratioX:Double = 0.0
    var ratioY:Double = 0.0
    var isFirstRes:Int=0
    var image:UIImage = UIImage()
    var viewPoint:CGPoint!
    var modelLabel:Int = 0
    
    
    @IBAction func takePhoto(_ sender: Any){
        /*相机功能设置*/
        let settingsForMonitoring = AVCapturePhotoSettings()
        settingsForMonitoring.flashMode = .auto
        settingsForMonitoring.isAutoStillImageStabilizationEnabled = true
        settingsForMonitoring.isHighResolutionPhotoEnabled = false
        /*拍照*/
        stillImageOutput?.capturePhoto(with: settingsForMonitoring, delegate: self)
        modelLabel = 2
    }
    
    @IBAction func BackTo(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        captureSesssion = AVCaptureSession()
        captureSesssion.sessionPreset = AVCaptureSessionPreset1920x1080
        stillImageOutput = AVCapturePhotoOutput()
        
        let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        do {
            let input = try AVCaptureDeviceInput(device: device)
            if (captureSesssion.canAddInput(input)) {
                captureSesssion.addInput(input)
                if (captureSesssion.canAddOutput(stillImageOutput)) {
                    captureSesssion.addOutput(stillImageOutput)
                    captureSesssion.startRunning()
                    let captureVideoLayer: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer.init(session: captureSesssion)
                    captureVideoLayer.frame = view.layer.frame
                    captureVideoLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
                    view.layer.addSublayer(captureVideoLayer)
                }
            }
        }
        catch {
            print(error)
        }
        
        
        // Bring the camera button to front
        view.bringSubview(toFront: cameraButton)
        //colorLabel.text="color display>>"
        view.bringSubview(toFront: colorLabel)
        
        view.bringSubview(toFront: BackButton)
        
        self.view.isUserInteractionEnabled = true
        

    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first;
        //当前触摸点在view上的点
        let pointInView = touch?.location(in: self.view);
        //触摸点在view上之前的位置
        let pointOfBefor = touch?.previousLocation(in: self.view);
        //触摸点，是否在当前视图上
        let isInView = self.view.point(inside: pointInView!, with: event);
        //点，在某个视图上的坐标
        viewPoint = self.view.convert(pointOfBefor!, to: self.view);
        
        /*相机功能设置*/
        let settingsForMonitoring = AVCapturePhotoSettings()
        settingsForMonitoring.flashMode = .auto
        settingsForMonitoring.isAutoStillImageStabilizationEnabled = true
        settingsForMonitoring.isHighResolutionPhotoEnabled = false
        /*拍摄照片*/
        stillImageOutput?.capturePhoto(with: settingsForMonitoring, delegate: self)
        
        modelLabel = 1
    }
    
    func colorRec(){
        /*计算图片边框显示尺寸*/
        let widthImage:Double = Double(self.view.frame.size.width)
        let heightImage:Double = Double(self.view.frame.size.height)
        
        /*计算触摸点比例*/
        ratioX = Double(viewPoint.x)/Double(widthImage)
        ratioY = Double(viewPoint.y)/Double(heightImage)
        
        print("坐标比例\(self.ratioX),\(self.ratioY).图像尺寸\(heightImage),\(widthImage).触摸点\(viewPoint.x),\(viewPoint.y)")
        //使用Swift指针，将数组的地址传给Objective-C方法
        var p:UnsafeMutablePointer<Double>
        let arrayPtr = UnsafeMutableBufferPointer<Double>(start:&ratioX,count:1)
        p=arrayPtr.baseAddress! as UnsafeMutablePointer<Double>
        
        var p2:UnsafeMutablePointer<Double>
        let arrayPtr2 = UnsafeMutableBufferPointer<Double>(start:&ratioY,count:1)
        p2=arrayPtr2.baseAddress! as UnsafeMutablePointer<Double>
        
        
        /*调用颜色识别算法*/
        var colorStr:String = String(CVWrapper.process(with: self.image,ratX:p,ratY:p2))
        print(colorStr)
        colorLabel.text = colorStr.description
        /*播报颜色*/
        if(isFirstRes==0){
            colorStr="触摸点的颜色 ".appending(colorStr)
            isFirstRes += 1
        }
        SpeechSynthesizer.Shared.speak(colorStr)
        SpeechSynthesizer.Shared.isSpeaking()
        
    }
    
    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        if let photoSampleBuffer = photoSampleBuffer {
            let photoData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer)
            self.image = UIImage(data: photoData!)!
           // UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
            if modelLabel==1{
                colorRec()
            }else if modelLabel==2{
                let sb = UIStoryboard(name: "Main", bundle:nil)
                let vc = sb.instantiateViewController(withIdentifier: "imageVC") as! ImageViewController
                    vc.image = UIImage(data: photoData!)!
                self.present(vc, animated: true, completion: nil)
                
            }
            
        }
    }

}


