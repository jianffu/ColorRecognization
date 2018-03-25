//
//  ColorRecognition.hpp
//  颜色识别
//
//  Created by JianJian on 2017/1/8.
//  Copyright © 2017年 傅建. All rights reserved.
//

#ifndef ColorRecognition_hpp
#define ColorRecognition_hpp

#include <stdio.h>
#include <opencv2/opencv.hpp>
#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <string>
#include <assert.h>
using namespace std;
std::string colorRecog (cv::Mat & image,double* ratioX,double*ratioY);
int getPath(string *str);
#endif /* ColorRecognition_hpp */
