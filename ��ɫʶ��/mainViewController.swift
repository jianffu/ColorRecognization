//
//  mainViewController.swift
//  颜色识别
//
//  Created by JianJian on 2017/3/26.
//  Copyright © 2017年 傅建. All rights reserved.
//

import UIKit
class mainViewController: UIViewController{
    override func viewDidLoad() {
        //相册按钮
        let btn1:UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        btn1.center = CGPoint(x:view.frame.size.width/3.3, y:view.frame.size.height/4)
        btn1.setTitle("相册", for: UIControlState.normal) //按钮文字
        btn1.titleLabel?.font = UIFont.boldSystemFont(ofSize: 28) //文字大小
        btn1.setTitleColor(UIColor.orange, for: UIControlState.normal) //文字颜色
        btn1.setImage(UIImage(named: "icon2.png"), for: UIControlState.normal) //按钮图标
        
        view.addSubview(btn1)
        
        btn1.addTarget(self, action: #selector(tapped), for: .touchUpInside)
        
        /*相机按钮*/
        let btn2:UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        btn2.center = CGPoint(x:view.frame.size.width/1.4, y:view.frame.size.height/4)
        btn2.setTitle("Camera", for: UIControlState.normal) //按钮文字
        btn2.titleLabel?.font = UIFont.boldSystemFont(ofSize: 28) //文字大小
        btn2.setTitleColor(UIColor.orange, for: UIControlState.normal) //文字颜色
        btn2.setImage(UIImage(named: "camera.jpg"), for: UIControlState.normal) //按钮图标
        //btn1.titleEdgeInsets =
        
        //btn1.imageEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0)
        view.addSubview(btn2)
        
        btn2.addTarget(self, action: #selector(tapped2), for: .touchUpInside)
        /*即时相机按钮*/
        let btn3:UIButton = UIButton(frame: CGRect(x: 0, y: 0, width:100, height: 100))
        btn3.center = CGPoint(x:view.frame.size.width/3.3, y:view.frame.size.height/2.0)
        btn3.setTitle("即时相机", for: UIControlState.normal) //按钮文字
        btn3.titleLabel?.font = UIFont.boldSystemFont(ofSize: 28) //文字大小
        btn3.setTitleColor(UIColor.orange, for: UIControlState.normal) //文字颜色
        btn3.setImage(UIImage(named: "mirror"), for: UIControlState.normal) //按钮图标

        view.addSubview(btn3)
        
        btn3.addTarget(self, action: #selector(tapped3), for: .touchUpInside)
        
        let path = Bundle.main.path(forResource:"testData", ofType: "rtf")
        
        let lines = try? String(contentsOfFile: path!).characters.split{$0 == "\n"}.map(String.init)
        
        for item in lines! {
            
            print(item)
            
        }
        print(path!)
        var bl:Bool
        bl = CVWrapper.pathTrans(path!)
        if bl == true{
            print("path transmit success")
        }else {
            print("path transmit fail")
        }
    }
    func tapped(){
        let sb = UIStoryboard(name: "Main", bundle:nil)
        let vc = sb.instantiateViewController(withIdentifier: "photoVC") as! photoViewController
        present(vc, animated: true, completion: nil)
    }
    
    func tapped2(){
        let sb = UIStoryboard(name: "Main", bundle:nil)
        let vc = sb.instantiateViewController(withIdentifier: "cameraVC") as! cameraViewController
        present(vc, animated: true, completion: nil)
    }
    func tapped3(){
        let sb = UIStoryboard(name: "Main", bundle:nil)
        let vc = sb.instantiateViewController(withIdentifier: "intimeVC") as! IntimeViewController
        present(vc, animated: true, completion: nil)
    }
    
}
