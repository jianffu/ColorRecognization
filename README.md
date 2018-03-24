# ColorRecognization
A mobile application for the color-blindness to recognize color

##1.Summary
Software type: iOS application
Author: F
Time: 2016.12--2017.12

##2.Main
###The mobile application is aimed to recognize color in the camera of iOS devices for the color-blindness, including hypochromatopsia and achromatopsia.
###Function
1. The user clicks on the desired position in the screen and the application automatically recognizes the color of the area block centered on the touch point and feeds it back with text and speech.
2. On the one hand, you can get pictures through a gallery or camera. On the other hand, you can click on the object directly in the camera interface for color recognition (instant camera mode).


##3. Programming 
##Development Environment


- Development tools: Xcode 8.3.2 iOS 10.1


- Programming language: Swift3.0 C++ Objective-C


- Others:  OpenCV Library， C++, Swift Bridge Technology,  Cocoapods

##4.Algorithm
###Color Recognization Algorithm: Using a combination of search color range tables and kNN
###Details:


- By studying the characteristics of the HSV color space, we found that when the light is bright, hue(H) is the main influence factor of the color. However, when the environment is gloomy or dark, value(V) is the main factor.


- In particular, red has two divided ranges in hue because of the HSV conical model.


- First, we determine whether the saturation and value are in the range of white, gray and black when recognizing the HSV values of the color point from iOS devices.


- Second, we use the k Nearest Neighbor Algorithm. Calculate the distance from the pixel to be measured and the standard color HSV tables, and then get the nearest k standard colors. The color with the most number of color labels in the k neighbors is regarded as the color of the pixel.

##5.Advantages

1. This method solves the shortcomings of traditional color classification and the method's advantages:


2. Precision, there is no need to divide the range of HSVs for each color, and to achieve accurate classification of more than 50 colors.


3. In manual acquisition of a standard color HSV table, this method can achieve camera and standard color adjustments.

##6.Software screenshot
![主页](https://upload-images.jianshu.io/upload_images/1371509-f72ea2a41c8caa09.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
![识别照片](https://upload-images.jianshu.io/upload_images/1371509-890312dbd5d06591.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
![即时相机](https://upload-images.jianshu.io/upload_images/1371509-921230c04097a2f4.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)



Source code on Github
[http://github.com/J3069/ColorRecognization](http://github.com/J3069/ColorRecognization "Soure code on Github")
