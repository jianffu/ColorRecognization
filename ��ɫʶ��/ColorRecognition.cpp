//
//  ColorRecognition.cpp
//  颜色识别
//
//  Created by JianJian on 2017/1/8.
//  Copyright © 2017年 傅建. All rights reserved.
//

#include "ColorRecognition.hpp"
#include <iostream>
#include <fstream>
#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <string>
#include <assert.h>
#include<map>
#include<vector>
#include<stdio.h>
#include<cmath>
#include<cstdlib>
#include<algorithm>
#include<sstream>

using namespace cv;
using namespace std;

typedef string tLabel;
typedef int tData;
typedef pair<int, double>  PAIR;
const int colLen = 3;
const int rowLen = 165;
string pathStr;
class KNN
{
private:
    tData dataSet[rowLen][colLen];
    string labels[rowLen];
    tData testData[colLen];
    int k;
    map<int, double> map_index_dis;
    map<tLabel, int> map_label_freq;
    double get_distance(tData *d1, tData *d2);
public:
    
    KNN();
    
    void getInstance(int t1, int t2, int t3);
    
    void get_all_distance();
    
    string get_max_freq_label();
    
    struct CmpByValue
    {
        bool operator() (const PAIR& lhs, const PAIR& rhs)
        {
            return lhs.second < rhs.second;
        }
    };
    
};

KNN::KNN()
{
    this->k=5;
    ifstream fin;
    if(pathStr.empty()){
        printf("file trans wrong");
    }else{
        printf("file trans succeed");
    }
    fin.open(pathStr);
    
    if (!fin)
    {
        cout << "can not open the file" << endl;
        exit(1);
    }
    string str;
    /* input the dataSet */
    for (int i = 0; i<rowLen; i++)
    {

        fin >> str;
        labels[i] = str;
        cout<< labels[i]<<" ";
        
        for (int j = 0; j<colLen; j++)
        {
            fin >> dataSet[i][j];
            cout<< dataSet[i][j]<<" ";
        }
        cout<<endl;
    }
    
    fin.close();
    testData[0] = 0;
    testData[1] = 0;
    testData[2] = 0;
    
}

void KNN::getInstance(int t1, int t2, int t3)
{
    testData[0] = t1;
    testData[1] = t2;
    testData[2] = t3;
}

/*
 * calculate the distance between test data and dataSet[i]
 */
double KNN::get_distance(tData *d1, tData *d2)
{
    double sum = 0;
    //double rate[3]={0.5,0.25,0.25};
    for (int i = 0; i<1 ; i++)
    {
        sum += pow((d1[i] - d2[i]), 2); //*rate[i]
    }
    
    
    //	cout<<"the sum is = "<<sum<<endl;
    return sqrt(sum);
}

/*
 * calculate all the distance between test data and each training data
 */
void KNN::get_all_distance()
{
    double distance;
    int i;
    for (i = 0; i<rowLen; i++)
    {
        distance = get_distance(dataSet[i], testData);
        //<key,value> => <i,distance>
        map_index_dis[i] = distance;
    }
    
    //traverse the map to print the index and distance
    map<int, double>::const_iterator it = map_index_dis.begin();
    while (it != map_index_dis.end())
    {
        cout << "index = " << it->first << " distance = " << it->second << endl;
        it++;
    }
}

/*
 * check which label the test data belongs to to classify the test data
 */
string KNN::get_max_freq_label()
{
    //transform the map_index_dis to vec_index_dis
    vector<PAIR> vec_index_dis(map_index_dis.begin(), map_index_dis.end());
    //sort the vec_index_dis by distance from low to high to get the nearest data
    sort(vec_index_dis.begin(), vec_index_dis.end(), CmpByValue());
    int test;
    int cores[10][10];
    for (int i = 0; i<k; i++)
    {
        cout << "the index = " << vec_index_dis[i].first << " the distance = " << vec_index_dis[i].second << " the label = " << labels[vec_index_dis[i].first] << " the coordinate ( " << dataSet[vec_index_dis[i].first][0] << "," << dataSet[vec_index_dis[i].first][1] << " )" << endl;
        //calculate the count of each label
        test = map_label_freq[labels[vec_index_dis[i].first]]++;
        cout<<test<<endl;
    }
    
    string labelStr[10];
    int i,j,no=0,flag=0;
    labelStr[no]=labels[vec_index_dis[0].first];
    no++;
    for ( i = 1; i<k; i++)
    {
        flag=0;
        for(j=0;j<no;j++){
            if(labelStr[j]==labels[vec_index_dis[i].first]){
                flag=1;
            }
        }
        if(flag==0){
            labelStr[no]=labels[vec_index_dis[i].first];
            no++;
        }
       
    }

    //map<tLabel, int>::const_iterator map_it = map_label_freq.begin();
    tLabel label;
    int max_freq = 0;
    int num;
    //find the most frequent label
    for( i=0;i<no;i++)
    {
        num = map_label_freq[labelStr[i]];
        if (num > max_freq)
        {
            max_freq = num;
            label = labelStr[i];
        }
    }
    cout << "The test data belongs to the " << label << " label" << endl;
    return label;
}

string colorReco(Scalar* color);

cv::Mat img;
//string result_name = "result.jpg";

string colorRecog (cv::Mat& image,double* ratioX,double*ratioY){
    img = image;
    string str = "hello Swift!";
    
    // 读入一张图片（图片）
    Mat rgb_img = image;

    if (rgb_img.empty())
        return "-1";

    
    //BGR->HSV
    Mat hsv_img;
    cvtColor(rgb_img, hsv_img, CV_RGB2HSV);

    std::vector<Mat> hsv_vec;
    std::vector<Mat> rgb_vec;
    Mat img_h, img_s, img_v;
    Mat img_r,img_g,img_b;
    cv::split(hsv_img, hsv_vec);
    cv::split(rgb_img,rgb_vec);
    img_h = hsv_vec[0];
    img_s = hsv_vec[1];
    img_v = hsv_vec[2];
    img_r=rgb_vec[0];
    img_g=rgb_vec[1];
    img_b=rgb_vec[2];
    int rowNumber = img_h.rows;
    int colNumber = img_h.cols;
    double ratioRow[2] = {*ratioX,*ratioY};
    int color[3] = {0,0,0};
    int colorgb[3]={0,0,0};
    /*
     计算以触摸点为中心的100*100像素矩形区域的HSV均值
     */
    int centralRow = rowNumber*ratioRow[1];
    int centralCol = colNumber*ratioRow[0];
    

    int initialRow = centralRow - 6;
    int initialCol = centralCol - 6;
    cout<<"初始像素点： " <<initialCol <<","<< initialRow<<endl;
    for (int i = 0; i < 10; i++) {
        initialRow += 1;
        initialCol = centralCol - 6;
        for(int j = 0;j<10;j++){
            initialCol += 1;
            color[0] += (int)img_h.at<uchar>(initialRow, initialCol);
            color[1] += (int)img_s.at<uchar>(initialRow, initialCol);
            color[2] += (int)img_v.at<uchar>(initialRow, initialCol);

        }
    }
    color[0] = color[0] / 100;
    color[1] = color[1] / 100;
    color[2] = color[2] / 100;

    cout<<"触摸点："<<centralCol<<","<<centralRow<<endl;
    cout << "图片尺寸： "<<rowNumber <<","<< colNumber<<endl;
    cout << "the average hsv value of the pixel:" << color[0] << " " << color[1] << " " << color[2] << endl;
    
    /*根据HSV值进行颜色分类*/
    Scalar* scalar = new Scalar(color[0],color[1],color[2]);
    string stri = colorReco(scalar);

    cout << "颜色： "<<stri <<"坐标比例： "<<"("<<*ratioX<<","<<*ratioY<<")"<< endl;

    return stri;
}


string colorRecog(int h,int s,int v) {
    
    
    KNN knn;
    knn.getInstance(h, s, v);
    knn.get_all_distance();
    string str = knn.get_max_freq_label();
    cout<< str;
    return str;
    
}
string colorReco(Scalar* color) {
    int h = (int)(color->val[0]);
    int s = (int)(color->val[1]);
    int v = (int)(color->val[2]);
    
    assert(h<=180&&h>=0);
    assert(s>=0&&s<=255);
    assert(v>=0&&v<=255);
    
    if (v >= 0 && v <= 46)
        return "黑色";
    else if ((v >= 46 && v <= 220) && (s >= 0 && s <= 43))
        return "灰色";
    else if ((v >= 221 && v <= 255) && (s >= 0 && s <= 30))
        return "白色";
    else if (h >= 11 && h <= 77) {

        return colorRecog(h, s, v);
    }
    else  {
        return colorRecog(h, s, v);
    }
    
    return NULL;
}

int getPath(string *str){
    if(str!=NULL){
        pathStr = *str;
        return 1;
    }
    return 0;
}
