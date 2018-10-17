#pragma once
 
extern "C" __declspec(dllexport) void vzDisparity(Mat L, Mat R, Mat DL, Mat DR);
extern "C" __declspec(dllexport) void vzDisparityTemporal(Mat L, Mat R, Mat preL, Mat preR, Mat preDL, Mat preDR, Mat DL, Mat DR);