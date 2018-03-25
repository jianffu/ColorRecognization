//
//  ViewController.swift
//  FoodTracker
//
//  Created by JianJian on 2017/3/7.
//  Copyright © 2017年 傅建. All rights reserved.
//

import UIKit

class photoViewController: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    //Mark: Properties
    var point:CGPoint = CGPoint(x:0,y:0)
    @IBOutlet weak var colorText: UITextField!
    var frame = CGRect(x: 32, y: 80, width: 360, height: 480)
    let image = UIImage(named: "pic1")
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    var viewWidth:CGFloat = 360
    var viewHeight:CGFloat = 480
    let stanWidth:Int = 360
    let stanHeight:Int = 480
    var photoImageView = UIImageView(frame: CGRect(x: 20, y: 80, width: 360, height: 480))
    var gesture = UITapGestureRecognizer(target: self, action: #selector(photoViewController.singleTap))
    var ratioX:Double = 0.0
    var ratioY:Double = 0.0
    var isFirstRes:Int = 0
    
    
    @IBAction func selectPhoto(_ sender: UIButton) {
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        photoImageView.image = selectedImage
        
        /*计算图片边框显示尺寸*/
        let widthImage:Double = Double((photoImageView.image?.size.width)!)
        let heightImage:Double = Double((photoImageView.image?.size.height)!)
        
        //let imageRatio:Double = widthImage/heightImage
        if((heightImage/widthImage)>=(4/3.0)){
            viewWidth = CGFloat(Double(stanHeight)*widthImage/heightImage)
            viewHeight = CGFloat(stanHeight)
        }else{
            viewWidth = CGFloat(stanWidth)
            viewHeight = CGFloat(Double(stanWidth)*heightImage/widthImage)
        }
        //photoImageView.contentMode = .scaleAspectFit
        //photoImageView.clipsToBounds = true
        //        let sizeIm:CGSize = CGSize(width:30,height:40)
        //        photoImageView.sizeThatFits(sizeIm)
        photoImageView.frame = CGRect(x: 20, y: 80, width: viewWidth, height: viewHeight)
        
        //photoAdapted(frame: frame, image: selectedImage)
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoImageView.contentMode = .scaleAspectFit        //photoAdapted(image: image!)
        photoImageView.image = image
        //开启图像视图的交互功能
        photoImageView.isUserInteractionEnabled = true
        
        photoImageView.clipsToBounds = true
        //将图像视图添加到当前视图控制器的根视图
        self.view.addSubview(photoImageView)
        
        //创建一个手势检测类，这是一个抽象类，它定义了所有手势的基本行为，并拥有6个子类，来检测发生在设备中的各种手势
        gesture = UITapGestureRecognizer(target: self, action: #selector(photoViewController.singleTap))
        
        //将创建的手势，指定给图像视图
        photoImageView.addGestureRecognizer(gesture)
        
        //photoAdapted(frame: self.frame, image: image!)
        
    }

    //创建用于接收手势事件的方法
    func singleTap(){
        point = gesture.location(in: photoImageView)
        print(point)
        
        /*计算图片边框显示尺寸*/
        let widthImage:Double = Double((photoImageView.image?.size.width)!)
        let heightImage:Double = Double((photoImageView.image?.size.height)!)
        
        /*计算触摸点比例*/
        ratioX = Double(point.x)/Double(viewWidth)
        ratioY = Double(point.y)/Double(viewHeight)
        
        //使用Swift指针，将数组的地址传给Objective-C方法
        var p:UnsafeMutablePointer<Double>
        let arrayPtr = UnsafeMutableBufferPointer<Double>(start:&ratioX,count:1)
        p=arrayPtr.baseAddress! as UnsafeMutablePointer<Double>
        
        var p2:UnsafeMutablePointer<Double>
        let arrayPtr2 = UnsafeMutableBufferPointer<Double>(start:&ratioY,count:1)
        p2=arrayPtr2.baseAddress! as UnsafeMutablePointer<Double>
        
        
        /*调用颜色识别算法*/
        var colorStr:String = String(CVWrapper.process(with: photoImageView.image!,ratX:p,ratY:p2))
        /*播报颜色*/
        if(isFirstRes==0){
            colorStr="触摸点的颜色 ".appending(colorStr)
            isFirstRes += 1
        }
        SpeechSynthesizer.Shared.speak(colorStr)
        SpeechSynthesizer.Shared.isSpeaking()
        colorText.text = colorStr.description
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

