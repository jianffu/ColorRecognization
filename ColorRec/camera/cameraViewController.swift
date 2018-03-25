//
//  ViewController.swift
//  camera
//
//  Created by Natalia Terlecka on 10/10/14.
//  Copyright (c) 2014 imaginaryCloud. All rights reserved.
//

import UIKit
//import CameraManager

class cameraViewController: UIViewController {
    
    // MARK: - Constants

    let cameraManager = CameraManager()
    
    // MARK: - @IBOutlets

    @IBOutlet weak var cameraView: UIView!
    
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var flashModeButton: UIButton!
    
    @IBOutlet weak var askForPermissionsButton: UIButton!
    @IBOutlet weak var askForPermissionsLabel: UILabel!
    
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("hello")
        cameraManager.showAccessPermissionPopupAutomatically = false
        
        askForPermissionsButton.isHidden = true
        askForPermissionsLabel.isHidden = true

        let currentCameraState = cameraManager.currentCameraStatus()
        
        if currentCameraState == .notDetermined {
            askForPermissionsButton.isHidden = false
            askForPermissionsLabel.isHidden = false
        } else if (currentCameraState == .ready) {
            addCameraToView()
        }
        if !cameraManager.hasFlash {
            flashModeButton.isEnabled = false
            flashModeButton.setTitle("No flash", for: UIControlState())
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
        cameraManager.resumeCaptureSession()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cameraManager.stopCaptureSession()
    }
    
    
    // MARK: - ViewController
    
    fileprivate func addCameraToView()
    {
        cameraManager.addPreviewLayerToView(cameraView, newCameraOutputMode: CameraOutputMode.stillImage)
        cameraManager.showErrorBlock = { [weak self] (erTitle: String, erMessage: String) -> Void in
        
            let alertController = UIAlertController(title: erTitle, message: erMessage, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (alertAction) -> Void in  }))
            
            self?.present(alertController, animated: true, completion: nil)
        }
    }

    // MARK: - @IBActions

    @IBAction func Back(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func changeFlashMode(_ sender: UIButton)
    {
        switch (cameraManager.changeFlashMode()) {
        case .off:
            sender.setTitle("Flash Off", for: UIControlState())
        case .on:
            sender.setTitle("Flash On", for: UIControlState())
        case .auto:
            sender.setTitle("Flash Auto", for: UIControlState())
        }
    }
    
    @IBAction func recordButtonTapped(_ sender: UIButton) {
            cameraManager.capturePictureWithCompletion({ (image, error) -> Void in
                if let errorOccured = error {
                    self.cameraManager.showErrorBlock("Error occurred", errorOccured.localizedDescription)
                }
                else {
                    print("hello2")
                    let sb = UIStoryboard(name: "Main", bundle:nil)
                    let vc = sb.instantiateViewController(withIdentifier: "imageVC") as! ImageViewController
                    if let capturedImage = image {
                        vc.image = capturedImage
                    }
                    self.present(vc, animated: true, completion: nil)
                }
            })
    }
    
    @IBAction func outputModeButtonTapped(_ sender: UIButton) {
        
        cameraManager.cameraOutputMode = cameraManager.cameraOutputMode == CameraOutputMode.videoWithMic ? CameraOutputMode.stillImage : CameraOutputMode.videoWithMic
        switch (cameraManager.cameraOutputMode) {
        case .stillImage:
            cameraButton.isSelected = false
            cameraButton.backgroundColor = UIColor.green
            sender.setTitle("Image", for: UIControlState())
        case .videoWithMic, .videoOnly:
            sender.setTitle("Video", for: UIControlState())
        }
    }
    
    @IBAction func changeCameraDevice(_ sender: UIButton) {
        
        cameraManager.cameraDevice = cameraManager.cameraDevice == CameraDevice.front ? CameraDevice.back : CameraDevice.front
        switch (cameraManager.cameraDevice) {
        case .front:
            sender.setTitle("Front", for: UIControlState())
        case .back:
            sender.setTitle("Back", for: UIControlState())
        }
    }
    
    @IBAction func askForCameraPermissions(_ sender: UIButton) {
        
        cameraManager.askUserForCameraPermission({ permissionGranted in
            self.askForPermissionsButton.isHidden = true
            self.askForPermissionsLabel.isHidden = true
            self.askForPermissionsButton.alpha = 0
            self.askForPermissionsLabel.alpha = 0
            if permissionGranted {
                self.addCameraToView()
            }
        })
    }
    
    @IBAction func changeCameraQuality(_ sender: UIButton) {
        
        switch (cameraManager.changeQualityMode()) {
        case .high:
            sender.setTitle("High", for: UIControlState())
        case .low:
            sender.setTitle("Low", for: UIControlState())
        case .medium:
            sender.setTitle("Medium", for: UIControlState())
        }
    }
}


