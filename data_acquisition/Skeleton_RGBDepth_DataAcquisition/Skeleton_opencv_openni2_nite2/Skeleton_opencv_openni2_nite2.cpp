﻿// STL Header
#include <iostream>
#include <fstream>
#include <math.h>
// OpenCV Header
#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/imgproc/imgproc.hpp>

// namespace
#include <windows.h>
#include <iostream> 
#include <NuiApi.h>
#include <opencv2/opencv.hpp>

#include <windows.h>

//define the output file name

//Kinect camera input dimensions
#define width 640
#define height 480 

using namespace std;
using namespace cv;


bool tracked[NUI_SKELETON_COUNT]={FALSE};

//skeleton_count = 6
//skeleton_position_count = 20 #of joints
CvPoint skeletonPoint[NUI_SKELETON_COUNT][NUI_SKELETON_POSITION_COUNT]={cvPoint(0,0)}; 
CvPoint colorPoint[NUI_SKELETON_COUNT][NUI_SKELETON_POSITION_COUNT]={cvPoint(0,0)}; 

//function headers -> declare in classes
void getColorImage(HANDLE &colorEvent, HANDLE &colorStreamHandle, Mat &colorImage); 
void getDepthImage(HANDLE &depthEvent, HANDLE &depthStreamHandle, Mat &depthImage); 
void getSkeletonImage(HANDLE &skeletonEvent, Mat &skeletonImage, Mat &colorImage, Mat &depthImage); 
void drawSkeleton(Mat &image, CvPoint pointSet[], int witchone, NUI_SKELETON_DATA skeletonData); 
void getTheContour(Mat &image, int whichone, Mat &mask);

char fnameC[sizeof "C:\\Users\\Adam\\Desktop\\complete_color_skeleton_C++_AdamLi\\Skeleton_opencv_openni2_nite2\\Color_Image\\Color_01_c1_00_00_000.png"];
char fnameD[sizeof "C:\\Users\\Adam\\Desktop\\complete_color_skeleton_C++_AdamLi\\Skeleton_opencv_openni2_nite2\\Depth_Image\\Depth_01_c1_00_00_000.png"];
//char fnameCVS[sizeof "C:\\Skeleton_01_c1_00.cvs"];
char fnameCVS[sizeof "C:\\Users\\Adam\\Desktop\\complete_color_skeleton_C++_AdamLi\\Skeleton_opencv_openni2_nite2\\Skeleton_01_c1_02.csv"];


LARGE_INTEGER frequency;
LARGE_INTEGER t1, t2;
double elapsedTime;

SYSTEMTIME ctime;

int main(int argc, char *argv[])
{

	//csv file initialization


	GetSystemTime(&ctime);
	sprintf(fnameCVS, "C:\\Users\\Adam\\Desktop\\complete_color_skeleton_C++_AdamLi\\Skeleton_opencv_openni2_nite2\\Skeleton_01_c1_%02d.csv", ctime.wDay );

	ofstream myfile;
	myfile.open (fnameCVS, ios::app);


	//commented out for usage of new joint data acquisition algorithm based on meters
	//instead of pixel values
	myfile << "head_x" << "," << "head_y"<<"," << "head_z" <<","<<
	"shoulder_center_x"<<","<<"shoulder_center_y"<<","<<"shoulder_center_z"<<","<<
	"spine_x"<<","<<"spine_y"<<","<<"spine_z"<<","<<
	"hip center_x"<<","<<"hip center_y"<<","<<"hip center_z"<<","<<
	"shoulder left_x"<<","<<"shoulder left_y"<<","<<"shoulder left_z"<<","<<
	"elbow left_x"<<","<<"elbow left_y"<<","<<"elbow left_z"<<","<<
	"wrist left_x"<<","<<"wrist left_y"<<","<<"wrist left_z"<<","<<
	"hand left_x"<<","<<"hand left_y"<<","<<"hand left_z"<<","<<
	"shoulder right_x"<<","<<"shoulder right_y"<<","<<"shoulder right_z"<<","<<
	"elbow right_x"<<","<<"elbow right_y"<<","<<"elbow right_z"<<","<<
	"wrist right_x"<<","<<"wrist right_y"<<","<<"wrist right_z"<<","<<
	"hand right_x"<<","<<"hand right_y"<<","<<"hand right_z"<<","<<
	"hip left_x"<<","<<"hip left_y"<<","<<"hip left_z"<<","<<
	"knee left_x"<<","<<"knee left_y"<<","<<"knee left_z"<<","<<
	"ankle left_x"<<","<<"ankle left_y"<<","<<"ankle left_z"<<","<<
	"foot left_x"<<","<<"foot left_y"<<","<<"foot left_z"<<","<<
	"hip right_x"<<","<<"hip right_y"<<","<<"hip right_z"<<","<<
	"knee right_x"<<","<<"knee right_y"<<","<<"knee right_z"<<","<<
	"ankle right_x"<<","<<"ankle right_y"<<","<<"ankle right_z"<<","<<
	"foot right_x"<<","<<"foot right_y"<<","<<"foot right_z"<<","<<"time_stamp"<<endl; 
	myfile.close();

	/* Mat==class with matrix header about size of matrix
	and method used for storing
	Creates 4 different Mat windows

	CV_8U3 = unsigned char type that are 8 bits long
	and each pixel has 3
	*/	
	Mat colorImage;
	colorImage.create(480, 640, CV_8UC3); 
	Mat depthImage;
	depthImage.create(480, 640, CV_8UC3); 
	Mat skeletonImage;
	skeletonImage.create(480, 640, CV_8UC3); 
	//Mat mask;
	//mask.create(240, 320, CV_8UC3); 

	//create handles for color/depth/skeleton event, and color/depthstreams
	HANDLE colorEvent = CreateEvent( NULL, TRUE, FALSE, NULL ); 
	HANDLE depthEvent = CreateEvent( NULL, TRUE, FALSE, NULL ); 
	HANDLE skeletonEvent = CreateEvent( NULL, TRUE, FALSE, NULL ); 

	HANDLE colorStreamHandle = NULL; 
	HANDLE depthStreamHandle = NULL; 

	//initialize sensor called hr
    HRESULT hr = NuiInitialize(NUI_INITIALIZE_FLAG_USES_COLOR |
		NUI_INITIALIZE_FLAG_USES_DEPTH_AND_PLAYER_INDEX |
		NUI_INITIALIZE_FLAG_USES_SKELETON);   
   
	//error checks
	//S_OK = operation successful
	if( hr != S_OK )   
	{   
		cout<<"NuiInitialize failed"<<endl;   
		return hr;   
	} 

	//initialize sensor; returns true or false
    hr = NuiImageStreamOpen(NUI_IMAGE_TYPE_COLOR, //depth or rgb camera
		NUI_IMAGE_RESOLUTION_640x480, //image resolution
		NULL, //image stream flags, e.g. near mode
		4, //number of frames to buffer
		colorEvent, // event handle
		&colorStreamHandle); 
	if( hr != S_OK )   
	{   
       cout<<"Open the color Stream failed"<<endl; 
       NuiShutdown(); 
       return hr;   
	} 
	hr = NuiImageStreamOpen(NUI_IMAGE_TYPE_DEPTH_AND_PLAYER_INDEX, 
		NUI_IMAGE_RESOLUTION_640x480, 
		NULL, 
		2, 
		depthEvent, 
		&depthStreamHandle); 
	if( hr != S_OK )   
	{   
		cout<<"Open the depth Stream failed"<<endl; 
		NuiShutdown(); 
		return hr;   
	} 
	hr = NuiSkeletonTrackingEnable( skeletonEvent, 0 );  
	if( hr != S_OK )   
	{   
		cout << "NuiSkeletonTrackingEnable failed" << endl;   
		NuiShutdown(); 
		return hr;   
	} 
 
	int count=0;
	while (1) 
	{ 
		/*if handle to object is signaled,
		run through each function method
		Function: WaitForSingleObject(handlein, dwmilliseconds)
		*/


		//QueryPerformanceFrequency(&frequency);
		//QueryPerformanceCounter(&t1);

		if(WaitForSingleObject(colorEvent, 0)==0) 
			getColorImage(colorEvent, colorStreamHandle, colorImage); 
		if(WaitForSingleObject(depthEvent, 0)==0) 
			getDepthImage(depthEvent, depthStreamHandle, depthImage); 
		if(WaitForSingleObject(skeletonEvent, INFINITE)==0) //{
			getSkeletonImage(skeletonEvent, skeletonImage, colorImage, depthImage); 
         
		waitKey(10);

		GetSystemTime(&ctime);

		sprintf(fnameC, "C:\\Users\\Adam\\Desktop\\complete_color_skeleton_C++_AdamLi\\Skeleton_opencv_openni2_nite2\\Color_Image\\Color_01_c1_%02d_%02d_%03d.png", ctime.wMinute, ctime.wSecond, ctime.wMilliseconds);
		sprintf(fnameD, "C:\\Users\\Adam\\Desktop\\complete_color_skeleton_C++_AdamLi\\Skeleton_opencv_openni2_nite2\\Depth_Image\\Depth_01_c1_%02d_%02d_%03d.png", ctime.wMinute, ctime.wSecond, ctime.wMilliseconds);

		cv::imwrite(fnameC, colorImage);
		cv::imwrite(fnameD, depthImage);

		count += 1;
	//}

		imshow("colorImage", colorImage); 
       //imshow("depthImage", depthImage); 
       //imshow("skeletonImage", skeletonImage); 

		//QueryPerformanceCounter(&t2);
		//cout << ctime.wDay <<":"<< ctime.wMinute<<":" << ctime.wSecond  << ":" << ctime.wMilliseconds <<  endl;

		//elapsedTime = (t2.QuadPart - t1.QuadPart) * 1000.0 / frequency.QuadPart;
		//cout << 1000/elapsedTime << endl;	 //check that 'esc' is not pressed

		if(cvWaitKey(1)==27) 
			break; 
	} //end of while
	NuiShutdown();	
	return 0; 
}

/* Function: getColorImage
* Inputs: 
colorEvent - a reference to a handle for the color event
colorStreamHandle - a reference to a handle for the color stream
colorImage - a reference to the Mat for color image

* Outputs: void
*/
void getColorImage(HANDLE &colorEvent, HANDLE &colorStreamHandle, Mat &colorImage) 
{ 
	//initialize structure containing all metadata about the frame: number, resolution, etc.
	const NUI_IMAGE_FRAME *colorFrame = NULL; 

	//gets the next fram of data from 'colorStreamHandle', waits 0 ms before returning
	// and passes a reference to a NUI_IMAGE_FRAME 'colorFrame' that contains next image frame
	//return value: HRESULT
	NuiImageStreamGetNextFrame(colorStreamHandle, 0, &colorFrame); 

	//manages the frame data
	INuiFrameTexture *pTexture = colorFrame->pFrameTexture;   

	//pointer to actual data
	NUI_LOCKED_RECT LockedRect; 

	//lock frame data so Kinect knows not to modify it while we're reading
    pTexture->LockRect(0, &LockedRect, NULL, 0);   

	//if # of bytes in 1 row of texture resource != 0, proceed
	//make sure we've received valid data
	if( LockedRect.Pitch != 0 ) 
	{ 
		//loop through the rows of the color image to receive byte/pixel data
		for (int i=0; i<colorImage.rows; i++) 
		{
			//unsigned char ptr returns pointer to specified row matrix
			uchar *ptr = colorImage.ptr<uchar>(i);  

			//pbuffer = bits in lockedrect + currentrow# * bytes in pitch
			uchar *pBuffer = (uchar*)(LockedRect.pBits) + i * LockedRect.Pitch;

			for (int j=0; j<colorImage.cols; j++) //loop through the columns in Mat colorIMage
			{ 
				   ptr[3*j] = pBuffer[4*j];
				   ptr[3*j+1] = pBuffer[4*j+1]; 
				   ptr[3*j+2] = pBuffer[4*j+2]; 
			} 
		} 
	}//end of if statement 
	else 
	{ 
		cout<<"Failed to receive valid data from LockedRect!"<<endl; 
	}

	//unlocks the pTexture buffer
	pTexture->UnlockRect(0); 

	//releases colorStream handle and color frame
	NuiImageStreamReleaseFrame(colorStreamHandle, colorFrame);
} 


/* Function: getDepthImage
* Inputs: 
depthEvent - a reference to a handle for the depth event
depthStreamHandle - a reference to a handle for the color stream
depthImage - a reference to the Mat for color image

* Outputs: void
*/
void getDepthImage(HANDLE &depthEvent, HANDLE &depthStreamHandle, Mat &depthImage) 
{ 
	//initialize depthFrame pointer
	const NUI_IMAGE_FRAME *depthFrame = NULL; 

	//gets next image frame from depth stream handle
	NuiImageStreamGetNextFrame(depthStreamHandle, 0, &depthFrame);

	//pointer to an INUIframetexture object that can be used to 
	//manipulate frame data as a texture resource
	//*to access frame data, call lockrect, and then use pBits
	INuiFrameTexture *pTexture = depthFrame->pFrameTexture;   

	NUI_LOCKED_RECT LockedRect; 
	pTexture->LockRect(0, &LockedRect, NULL, 0);   

	RGBQUAD q; //defines a RGBQuad structure that describes a color from r,g,b 

	if( LockedRect.Pitch != 0 ) 
	{ 
		for (int i=0; i<depthImage.rows; i++) 
		{ 
			uchar *ptr = depthImage.ptr<uchar>(i); 
			uchar *pBuffer = (uchar*)(LockedRect.pBits) + i * LockedRect.Pitch;
			USHORT *pBufferRun = (USHORT*) pBuffer; //convert buffer data to unsigned short

			for (int j=0; j<depthImage.cols; j++) //loop through depthimage's columns
			{ 
				//3 lower bits represent player id information (0-6)
				//rest of bits represent pixel information
				int player = pBufferRun[j]&7; //pbufferrun & 0111

				//pbufferrun & 1111111111111000 shift right 3 times
				//this is the depth value we care about
				int data = (pBufferRun[j]&0xfff8) >> 3; 
                
				uchar imageData = 255-(uchar)(256*data/0x0fff); //255-256*data/4095
				q.rgbBlue = q.rgbGreen = q.rgbRed = 0;	//set red, green and blue all to 0

				switch(player) 
				{ 
					case 0:   
						q.rgbRed = imageData / 2;   
						q.rgbBlue = imageData / 2;   
						q.rgbGreen = imageData / 2;   
						break;   
					case 1:    
						q.rgbRed = imageData;   
						break;   
					case 2:   
						q.rgbGreen = imageData;   
						break;   
					case 3:   
						q.rgbRed = imageData / 4;   
						q.rgbGreen = q.rgbRed*4;  
						q.rgbBlue = q.rgbRed*4;  
						break;   
					case 4:   
						q.rgbBlue = imageData / 4;  
						q.rgbRed = q.rgbBlue*4;   
						q.rgbGreen = q.rgbBlue*4;   
						break;   
					case 5:   
						q.rgbGreen = imageData / 4;  
						q.rgbRed = q.rgbGreen*4;   
						q.rgbBlue = q.rgbGreen*4;   
						break;   
					case 6:   
						q.rgbRed = imageData / 2;   
						q.rgbGreen = imageData / 2;    
						q.rgbBlue = q.rgbGreen*2;   
						break;   
					case 7:   
						q.rgbRed = 255 - ( imageData / 2 );   
						q.rgbGreen = 255 - ( imageData / 2 );   
						q.rgbBlue = 255 - ( imageData / 2 ); 
				}

				//Mat's image pointer gets the intensities of blue, green, red
				ptr[3*j] = q.rgbBlue; 
				ptr[3*j+1] = q.rgbGreen; 
				ptr[3*j+2] = q.rgbRed; 
			} 
		} 
	} 
	else 
	{ 
		cout << "Capturing invalid data!" << endl; 
	} 

	//unlock frame
	pTexture->UnlockRect(0);
	NuiImageStreamReleaseFrame(depthStreamHandle, depthFrame);  
} 


/* Function: getSkeletonImage
* Inputs: 
SkeletonEvent - a handle for the skeleton event
skeletonImage - a reference to a Mat object that holds the skeleton image
colorImage - a reference to a Mat for the color image
depthImage - a reference to the Mat for depth image

* Outputs: void
*/
void getSkeletonImage(HANDLE &skeletonEvent, Mat &skeletonImage, Mat &colorImage, Mat &depthImage) 
{ 
	NUI_SKELETON_FRAME skeletonFrame = {0};
	bool bFoundSkeleton = false;  

	//if getting next frame of data from skeleton stream (wait 0 seconds, 
	//pointer to the skeletonFrame) is capturing valid data, proceed
	if(NuiSkeletonGetNextFrame( 0, &skeletonFrame ) == S_OK )   
	{   
	//loop through to find player ID
		for( int i = 0 ; i < NUI_SKELETON_COUNT ; i++ )   
		{   
			if( skeletonFrame.SkeletonData[i].eTrackingState == NUI_SKELETON_TRACKED ) 
			{   
				//skeletonFrame.SkeletonData[count].eTrackingState is player ID skeleton
				bFoundSkeleton = true;   
				break; 
			}   
		}   
	} 
	else 
	{ 
		cout <<"Next fram is not valid data"<< endl; 
		return;  
	} 

	//no skeleton was found through the for loop
	if( !bFoundSkeleton )   
	{   
		return;  
	}   

	//filters skeleton positions to reduce jitter between frames
	//points to the skeleton frame that contains the skeleton data to be smoothed
	//***Should  we include smoothing parameters instead of NULL?
	NUI_TRANSFORM_SMOOTH_PARAMETERS defaultParams =
       {0.65f, 0.25f, 0.5f, 0.20f, 0.20f}; //filters out small jittesr
	NuiTransformSmooth(&skeletonFrame, &defaultParams);
	skeletonImage.setTo(0);   //set skeletonimage array elements to 0

	for( int i = 0 ; i < NUI_SKELETON_COUNT ; i++ )   
	{   
		if( skeletonFrame.SkeletonData[i].eTrackingState == NUI_SKELETON_TRACKED &&   
           skeletonFrame.SkeletonData[i].eSkeletonPositionTrackingState[NUI_SKELETON_POSITION_SHOULDER_CENTER] != NUI_SKELETON_POSITION_NOT_TRACKED)   
		{   
			float fx, fy;   

			for (int j = 0; j < NUI_SKELETON_POSITION_COUNT; j++)	//loop through different joints
			{   
				//returns depth space coordinates of specified point in skeleton space
				//skeletonFrame.trkeletonData[i].SkeletonPositions[j] is the point to transform
				//fx, fy are pointers to a float that recieves x, y coordinates
				NuiTransformSkeletonToDepthImage(skeletonFrame.SkeletonData[i].SkeletonPositions[j], &fx, &fy );   
				skeletonPoint[i][j].x = (int)fx;   //array's x coord gets fx
				skeletonPoint[i][j].y = (int)fy;   //array's y coord gets fy
			}   

			for (int j=0; j<NUI_SKELETON_POSITION_COUNT ; j++)   
			{   
				if (skeletonFrame.SkeletonData[i].eSkeletonPositionTrackingState[j] != NUI_SKELETON_POSITION_NOT_TRACKED)
				{   
					LONG colorx, colory;

					//gets pixel coords in color space that corresponds to specified pixel coords in depth space.
					NuiImageGetColorPixelCoordinatesFromDepthPixel(NUI_IMAGE_RESOLUTION_640x480, 0,  
                       skeletonPoint[i][j].x, skeletonPoint[i][j].y, 0 ,&colorx, &colory); 
       

					//holds the pointer to a long value that receives x,y-coord of pixel
					//in color image space in the colorPoint[i][j] array
					colorPoint[i][j].x = int(colorx);
					colorPoint[i][j].y = int(colory); 


					circle(colorImage, colorPoint[i][j], 4, cvScalar(0, 255, 255), 1, 8, 0); 
					circle(skeletonImage, skeletonPoint[i][j], 3, cvScalar(0, 255, 255), 1, 8, 0); 

					tracked[i] = TRUE; 
				} 
			} 
			drawSkeleton(colorImage, colorPoint[i], i, skeletonFrame.SkeletonData[i]);  
			drawSkeleton(skeletonImage, skeletonPoint[i], i, skeletonFrame.SkeletonData[i]); 
		} 
	}   
} 

void drawSkeleton(Mat &image, CvPoint pointSet[], int whichone, NUI_SKELETON_DATA skeletonData) 
{ 
   CvScalar color; 
   switch(whichone)
   { 
   case 0: 
       color = cvScalar(255); 
       break; 
   case 1: 
       color = cvScalar(0,255); 
       break; 
   case 2: 
       color = cvScalar(0, 0, 255); 
       break; 
   case 3: 
       color = cvScalar(255, 255, 0); 
       break; 
   case 4: 
       color = cvScalar(255, 0, 255); 
       break; 
   case 5: 
       color = cvScalar(0, 255, 255); 
       break; 
   }  

   if((pointSet[NUI_SKELETON_POSITION_HEAD].x!=0 || pointSet[NUI_SKELETON_POSITION_HEAD].y!=0) && 
       (pointSet[NUI_SKELETON_POSITION_SHOULDER_CENTER].x!=0 || pointSet[NUI_SKELETON_POSITION_SHOULDER_CENTER].y!=0)) 
       line(image, pointSet[NUI_SKELETON_POSITION_HEAD], pointSet[NUI_SKELETON_POSITION_SHOULDER_CENTER], color, 2); 
   if((pointSet[NUI_SKELETON_POSITION_SHOULDER_CENTER].x!=0 || pointSet[NUI_SKELETON_POSITION_SHOULDER_CENTER].y!=0) && 
       (pointSet[NUI_SKELETON_POSITION_SPINE].x!=0 || pointSet[NUI_SKELETON_POSITION_SPINE].y!=0)) 
       line(image, pointSet[NUI_SKELETON_POSITION_SHOULDER_CENTER], pointSet[NUI_SKELETON_POSITION_SPINE], color, 2); 
   if((pointSet[NUI_SKELETON_POSITION_SPINE].x!=0 || pointSet[NUI_SKELETON_POSITION_SPINE].y!=0) && 
       (pointSet[NUI_SKELETON_POSITION_HIP_CENTER].x!=0 || pointSet[NUI_SKELETON_POSITION_HIP_CENTER].y!=0)) 
       line(image, pointSet[NUI_SKELETON_POSITION_SPINE], pointSet[NUI_SKELETON_POSITION_HIP_CENTER], color, 2); 

   //??oEIO?? 
   if((pointSet[NUI_SKELETON_POSITION_SHOULDER_CENTER].x!=0 || pointSet[NUI_SKELETON_POSITION_SHOULDER_CENTER].y!=0) && 
       (pointSet[NUI_SKELETON_POSITION_SHOULDER_LEFT].x!=0 || pointSet[NUI_SKELETON_POSITION_SHOULDER_LEFT].y!=0)) 
       line(image, pointSet[NUI_SKELETON_POSITION_SHOULDER_CENTER], pointSet[NUI_SKELETON_POSITION_SHOULDER_LEFT], color, 2); 
   if((pointSet[NUI_SKELETON_POSITION_SHOULDER_LEFT].x!=0 || pointSet[NUI_SKELETON_POSITION_SHOULDER_LEFT].y!=0) && 
       (pointSet[NUI_SKELETON_POSITION_ELBOW_LEFT].x!=0 || pointSet[NUI_SKELETON_POSITION_ELBOW_LEFT].y!=0)) 
       line(image, pointSet[NUI_SKELETON_POSITION_SHOULDER_LEFT], pointSet[NUI_SKELETON_POSITION_ELBOW_LEFT], color, 2); 
   if((pointSet[NUI_SKELETON_POSITION_ELBOW_LEFT].x!=0 || pointSet[NUI_SKELETON_POSITION_ELBOW_LEFT].y!=0) && 
       (pointSet[NUI_SKELETON_POSITION_WRIST_LEFT].x!=0 || pointSet[NUI_SKELETON_POSITION_WRIST_LEFT].y!=0)) 
       line(image, pointSet[NUI_SKELETON_POSITION_ELBOW_LEFT], pointSet[NUI_SKELETON_POSITION_WRIST_LEFT], color, 2); 
   if((pointSet[NUI_SKELETON_POSITION_WRIST_LEFT].x!=0 || pointSet[NUI_SKELETON_POSITION_WRIST_LEFT].y!=0) && 
       (pointSet[NUI_SKELETON_POSITION_HAND_LEFT].x!=0 || pointSet[NUI_SKELETON_POSITION_HAND_LEFT].y!=0)) 
       line(image, pointSet[NUI_SKELETON_POSITION_WRIST_LEFT], pointSet[NUI_SKELETON_POSITION_HAND_LEFT], color, 2); 

   //OOEIO?? 
   if((pointSet[NUI_SKELETON_POSITION_SHOULDER_CENTER].x!=0 || pointSet[NUI_SKELETON_POSITION_SHOULDER_CENTER].y!=0) && 
       (pointSet[NUI_SKELETON_POSITION_SHOULDER_RIGHT].x!=0 || pointSet[NUI_SKELETON_POSITION_SHOULDER_RIGHT].y!=0)) 
       line(image, pointSet[NUI_SKELETON_POSITION_SHOULDER_CENTER], pointSet[NUI_SKELETON_POSITION_SHOULDER_RIGHT], color, 2); 
   if((pointSet[NUI_SKELETON_POSITION_SHOULDER_RIGHT].x!=0 || pointSet[NUI_SKELETON_POSITION_SHOULDER_RIGHT].y!=0) && 
       (pointSet[NUI_SKELETON_POSITION_ELBOW_RIGHT].x!=0 || pointSet[NUI_SKELETON_POSITION_ELBOW_RIGHT].y!=0)) 
       line(image, pointSet[NUI_SKELETON_POSITION_SHOULDER_RIGHT], pointSet[NUI_SKELETON_POSITION_ELBOW_RIGHT], color, 2); 
   if((pointSet[NUI_SKELETON_POSITION_ELBOW_RIGHT].x!=0 || pointSet[NUI_SKELETON_POSITION_ELBOW_RIGHT].y!=0) && 
       (pointSet[NUI_SKELETON_POSITION_WRIST_RIGHT].x!=0 || pointSet[NUI_SKELETON_POSITION_WRIST_RIGHT].y!=0)) 
       line(image, pointSet[NUI_SKELETON_POSITION_ELBOW_RIGHT], pointSet[NUI_SKELETON_POSITION_WRIST_RIGHT], color, 2); 
   if((pointSet[NUI_SKELETON_POSITION_WRIST_RIGHT].x!=0 || pointSet[NUI_SKELETON_POSITION_WRIST_RIGHT].y!=0) && 
       (pointSet[NUI_SKELETON_POSITION_HAND_RIGHT].x!=0 || pointSet[NUI_SKELETON_POSITION_HAND_RIGHT].y!=0)) 
       line(image, pointSet[NUI_SKELETON_POSITION_WRIST_RIGHT], pointSet[NUI_SKELETON_POSITION_HAND_RIGHT], color, 2); 

   //??oIAO?? 
   if((pointSet[NUI_SKELETON_POSITION_HIP_CENTER].x!=0 || pointSet[NUI_SKELETON_POSITION_HIP_CENTER].y!=0) && 
       (pointSet[NUI_SKELETON_POSITION_HIP_LEFT].x!=0 || pointSet[NUI_SKELETON_POSITION_HIP_LEFT].y!=0)) 
       line(image, pointSet[NUI_SKELETON_POSITION_HIP_CENTER], pointSet[NUI_SKELETON_POSITION_HIP_LEFT], color, 2); 
   if((pointSet[NUI_SKELETON_POSITION_HIP_LEFT].x!=0 || pointSet[NUI_SKELETON_POSITION_HIP_LEFT].y!=0) && 
       (pointSet[NUI_SKELETON_POSITION_KNEE_LEFT].x!=0 || pointSet[NUI_SKELETON_POSITION_KNEE_LEFT].y!=0)) 
       line(image, pointSet[NUI_SKELETON_POSITION_HIP_LEFT], pointSet[NUI_SKELETON_POSITION_KNEE_LEFT], color, 2); 
   if((pointSet[NUI_SKELETON_POSITION_KNEE_LEFT].x!=0 || pointSet[NUI_SKELETON_POSITION_KNEE_LEFT].y!=0) && 
       (pointSet[NUI_SKELETON_POSITION_ANKLE_LEFT].x!=0 || pointSet[NUI_SKELETON_POSITION_ANKLE_LEFT].y!=0)) 
       line(image, pointSet[NUI_SKELETON_POSITION_KNEE_LEFT], pointSet[NUI_SKELETON_POSITION_ANKLE_LEFT], color, 2); 
   if((pointSet[NUI_SKELETON_POSITION_ANKLE_LEFT].x!=0 || pointSet[NUI_SKELETON_POSITION_ANKLE_LEFT].y!=0) &&  
       (pointSet[NUI_SKELETON_POSITION_FOOT_LEFT].x!=0 || pointSet[NUI_SKELETON_POSITION_FOOT_LEFT].y!=0)) 
       line(image, pointSet[NUI_SKELETON_POSITION_ANKLE_LEFT], pointSet[NUI_SKELETON_POSITION_FOOT_LEFT], color, 2); 
 
   if((pointSet[NUI_SKELETON_POSITION_HIP_CENTER].x!=0 || pointSet[NUI_SKELETON_POSITION_HIP_CENTER].y!=0) && 
       (pointSet[NUI_SKELETON_POSITION_HIP_RIGHT].x!=0 || pointSet[NUI_SKELETON_POSITION_HIP_RIGHT].y!=0)) 
       line(image, pointSet[NUI_SKELETON_POSITION_HIP_CENTER], pointSet[NUI_SKELETON_POSITION_HIP_RIGHT], color, 2); 
   if((pointSet[NUI_SKELETON_POSITION_HIP_RIGHT].x!=0 || pointSet[NUI_SKELETON_POSITION_HIP_RIGHT].y!=0) && 
       (pointSet[NUI_SKELETON_POSITION_KNEE_RIGHT].x!=0 || pointSet[NUI_SKELETON_POSITION_KNEE_RIGHT].y!=0)) 
       line(image, pointSet[NUI_SKELETON_POSITION_HIP_RIGHT], pointSet[NUI_SKELETON_POSITION_KNEE_RIGHT],color, 2); 
   if((pointSet[NUI_SKELETON_POSITION_KNEE_RIGHT].x!=0 || pointSet[NUI_SKELETON_POSITION_KNEE_RIGHT].y!=0) && 
       (pointSet[NUI_SKELETON_POSITION_ANKLE_RIGHT].x!=0 || pointSet[NUI_SKELETON_POSITION_ANKLE_RIGHT].y!=0)) 
       line(image, pointSet[NUI_SKELETON_POSITION_KNEE_RIGHT], pointSet[NUI_SKELETON_POSITION_ANKLE_RIGHT], color, 2); 
   if((pointSet[NUI_SKELETON_POSITION_ANKLE_RIGHT].x!=0 || pointSet[NUI_SKELETON_POSITION_ANKLE_RIGHT].y!=0) && 
       (pointSet[NUI_SKELETON_POSITION_FOOT_RIGHT].x!=0 || pointSet[NUI_SKELETON_POSITION_FOOT_RIGHT].y!=0)) 
       line(image, pointSet[NUI_SKELETON_POSITION_ANKLE_RIGHT], pointSet[NUI_SKELETON_POSITION_FOOT_RIGHT], color, 2); 


	//std :: cout<< pointSet[NUI_SKELETON_POSITION_HEAD].x<<" "<<pointSet[NUI_SKELETON_POSITION_HEAD].y<<" "<<pointSet[NUI_SKELETON_POSITION_SHOULDER_CENTER].x<<" "<<pointSet[NUI_SKELETON_POSITION_SHOULDER_CENTER].y<<" "<<pointSet[NUI_SKELETON_POSITION_SPINE].x<<" "<<pointSet[NUI_SKELETON_POSITION_SPINE].y<<" "<<pointSet[NUI_SKELETON_POSITION_HIP_CENTER].x<<" "<<pointSet[NUI_SKELETON_POSITION_HIP_CENTER].y<<" "<<pointSet[NUI_SKELETON_POSITION_SHOULDER_LEFT].x<<" "<<pointSet[NUI_SKELETON_POSITION_SHOULDER_LEFT].y<<" "<<pointSet[NUI_SKELETON_POSITION_ELBOW_LEFT].x<<" "<<pointSet[NUI_SKELETON_POSITION_ELBOW_LEFT].y<<" "<<pointSet[NUI_SKELETON_POSITION_WRIST_LEFT].x<<" "<<pointSet[NUI_SKELETON_POSITION_WRIST_LEFT].y<<" "<<pointSet[NUI_SKELETON_POSITION_HAND_LEFT].x<<" "<<pointSet[NUI_SKELETON_POSITION_HAND_LEFT].y<<" "<<pointSet[NUI_SKELETON_POSITION_SHOULDER_RIGHT].x<<" "<<pointSet[NUI_SKELETON_POSITION_SHOULDER_RIGHT].y<<" "<<pointSet[NUI_SKELETON_POSITION_ELBOW_RIGHT].x<<" "<<pointSet[NUI_SKELETON_POSITION_ELBOW_RIGHT].y<<" "<<pointSet[NUI_SKELETON_POSITION_WRIST_RIGHT].x<<" "<<pointSet[NUI_SKELETON_POSITION_WRIST_RIGHT].y<<" "<<pointSet[NUI_SKELETON_POSITION_HAND_RIGHT].x<<" "<<pointSet[NUI_SKELETON_POSITION_HAND_RIGHT].y<<" "<<pointSet[NUI_SKELETON_POSITION_HIP_LEFT].x<<" "<<pointSet[NUI_SKELETON_POSITION_HIP_LEFT].y<<" "<<pointSet[NUI_SKELETON_POSITION_KNEE_LEFT].x<<" "<<pointSet[NUI_SKELETON_POSITION_KNEE_LEFT].y<<" "<<pointSet[NUI_SKELETON_POSITION_ANKLE_LEFT].x<<" "<<pointSet[NUI_SKELETON_POSITION_ANKLE_LEFT].y<<" "<<pointSet[NUI_SKELETON_POSITION_FOOT_LEFT].x<<" "<<pointSet[NUI_SKELETON_POSITION_FOOT_LEFT].y<<" "<<pointSet[NUI_SKELETON_POSITION_HIP_RIGHT].x<<" "<<pointSet[NUI_SKELETON_POSITION_HIP_RIGHT].y<<" "<<pointSet[NUI_SKELETON_POSITION_KNEE_RIGHT].x<<" "<<pointSet[NUI_SKELETON_POSITION_KNEE_RIGHT].y<<" "<<pointSet[NUI_SKELETON_POSITION_ANKLE_RIGHT].x<<" "<<pointSet[NUI_SKELETON_POSITION_ANKLE_RIGHT].y<<" "<<pointSet[NUI_SKELETON_POSITION_FOOT_RIGHT].x<<" "<<pointSet[NUI_SKELETON_POSITION_ANKLE_RIGHT].y<<endl; 
	//std:: cout<<pointSet[NUI_SKELETON_POSITION_HEAD].x<< endl;
           


	ofstream myfile;
	myfile.open (fnameCVS, ios::app);
	myfile << skeletonData.SkeletonPositions[NUI_SKELETON_POSITION_HEAD].x<<","<<
		skeletonData.SkeletonPositions[NUI_SKELETON_POSITION_HEAD].y<<"," <<
		skeletonData.SkeletonPositions[NUI_SKELETON_POSITION_HEAD].z<<","<<
		skeletonData.SkeletonPositions[NUI_SKELETON_POSITION_SHOULDER_CENTER].x<<","<<
		skeletonData.SkeletonPositions[NUI_SKELETON_POSITION_SHOULDER_CENTER].y<<","<<
		skeletonData.SkeletonPositions[NUI_SKELETON_POSITION_SHOULDER_CENTER].z<<","<<
		skeletonData.SkeletonPositions[NUI_SKELETON_POSITION_SPINE].x<<","<<
		skeletonData.SkeletonPositions[NUI_SKELETON_POSITION_SPINE].y<<","<<
		skeletonData.SkeletonPositions[NUI_SKELETON_POSITION_SPINE].z<<","<<
		skeletonData.SkeletonPositions[NUI_SKELETON_POSITION_HIP_CENTER].x<<","<<
		skeletonData.SkeletonPositions[NUI_SKELETON_POSITION_HIP_CENTER].y<<","<<
		skeletonData.SkeletonPositions[NUI_SKELETON_POSITION_HIP_CENTER].z<<","<<
		skeletonData.SkeletonPositions[NUI_SKELETON_POSITION_SHOULDER_LEFT].x<<","<<
		skeletonData.SkeletonPositions[NUI_SKELETON_POSITION_SHOULDER_LEFT].y<<","<<
		skeletonData.SkeletonPositions[NUI_SKELETON_POSITION_SHOULDER_LEFT].z<<","<<
		skeletonData.SkeletonPositions[NUI_SKELETON_POSITION_ELBOW_LEFT].x<<","<<
		skeletonData.SkeletonPositions[NUI_SKELETON_POSITION_ELBOW_LEFT].y<<","<<
		skeletonData.SkeletonPositions[NUI_SKELETON_POSITION_ELBOW_LEFT].z<<","<<
		skeletonData.SkeletonPositions[NUI_SKELETON_POSITION_WRIST_LEFT].x<<","<<
		skeletonData.SkeletonPositions[NUI_SKELETON_POSITION_WRIST_LEFT].y<<","<<
		skeletonData.SkeletonPositions[NUI_SKELETON_POSITION_WRIST_LEFT].z<<","<<
		skeletonData.SkeletonPositions[NUI_SKELETON_POSITION_HAND_LEFT].x<<","<<
		skeletonData.SkeletonPositions[NUI_SKELETON_POSITION_HAND_LEFT].y<<","<<
		skeletonData.SkeletonPositions[NUI_SKELETON_POSITION_HAND_LEFT].z<<","<<
		skeletonData.SkeletonPositions[NUI_SKELETON_POSITION_SHOULDER_RIGHT].x<<","<<
		skeletonData.SkeletonPositions[NUI_SKELETON_POSITION_SHOULDER_RIGHT].y<<","<<
		skeletonData.SkeletonPositions[NUI_SKELETON_POSITION_SHOULDER_RIGHT].z<<","<<
		skeletonData.SkeletonPositions[NUI_SKELETON_POSITION_ELBOW_RIGHT].x<<","<<
		skeletonData.SkeletonPositions[NUI_SKELETON_POSITION_ELBOW_RIGHT].y<<","<<
		skeletonData.SkeletonPositions[NUI_SKELETON_POSITION_ELBOW_RIGHT].z<<","<<
		skeletonData.SkeletonPositions[NUI_SKELETON_POSITION_WRIST_RIGHT].x<<","<<
		skeletonData.SkeletonPositions[NUI_SKELETON_POSITION_WRIST_RIGHT].y<<","<<
		skeletonData.SkeletonPositions[NUI_SKELETON_POSITION_WRIST_RIGHT].z<<","<<
		skeletonData.SkeletonPositions[NUI_SKELETON_POSITION_HAND_RIGHT].x<<","<<
		skeletonData.SkeletonPositions[NUI_SKELETON_POSITION_HAND_RIGHT].y<<","<<
		skeletonData.SkeletonPositions[NUI_SKELETON_POSITION_HAND_RIGHT].z<<","<<
		skeletonData.SkeletonPositions[NUI_SKELETON_POSITION_HIP_LEFT].x<<","<<
		skeletonData.SkeletonPositions[NUI_SKELETON_POSITION_HIP_LEFT].y<<","<<
		skeletonData.SkeletonPositions[NUI_SKELETON_POSITION_HIP_LEFT].z<<","<<
		skeletonData.SkeletonPositions[NUI_SKELETON_POSITION_KNEE_LEFT].x<<","<<
		skeletonData.SkeletonPositions[NUI_SKELETON_POSITION_KNEE_LEFT].y<<","<<
		skeletonData.SkeletonPositions[NUI_SKELETON_POSITION_KNEE_LEFT].z<<","<<
		skeletonData.SkeletonPositions[NUI_SKELETON_POSITION_ANKLE_LEFT].x<<","<<
		skeletonData.SkeletonPositions[NUI_SKELETON_POSITION_ANKLE_LEFT].y<<","<<
		skeletonData.SkeletonPositions[NUI_SKELETON_POSITION_ANKLE_LEFT].z<<","<<
		skeletonData.SkeletonPositions[NUI_SKELETON_POSITION_FOOT_LEFT].x<<","<<
		skeletonData.SkeletonPositions[NUI_SKELETON_POSITION_FOOT_LEFT].y<<","<<
		skeletonData.SkeletonPositions[NUI_SKELETON_POSITION_FOOT_LEFT].z<<","<<
		skeletonData.SkeletonPositions[NUI_SKELETON_POSITION_HIP_RIGHT].x<<","<<
		skeletonData.SkeletonPositions[NUI_SKELETON_POSITION_HIP_RIGHT].y<<","<<
		skeletonData.SkeletonPositions[NUI_SKELETON_POSITION_HIP_RIGHT].z<<","<<
		skeletonData.SkeletonPositions[NUI_SKELETON_POSITION_KNEE_RIGHT].x<<","<<
		skeletonData.SkeletonPositions[NUI_SKELETON_POSITION_KNEE_RIGHT].y<<","<<
		skeletonData.SkeletonPositions[NUI_SKELETON_POSITION_KNEE_RIGHT].z<<","<<
		skeletonData.SkeletonPositions[NUI_SKELETON_POSITION_ANKLE_RIGHT].x<<","<<
		skeletonData.SkeletonPositions[NUI_SKELETON_POSITION_ANKLE_RIGHT].y<<","<<
		skeletonData.SkeletonPositions[NUI_SKELETON_POSITION_ANKLE_RIGHT].z<<","<<
		skeletonData.SkeletonPositions[NUI_SKELETON_POSITION_FOOT_RIGHT].x<<","<<
		skeletonData.SkeletonPositions[NUI_SKELETON_POSITION_FOOT_RIGHT].y<<","<<
		skeletonData.SkeletonPositions[NUI_SKELETON_POSITION_FOOT_RIGHT].z<<","<<ctime.wMinute<<":" << ctime.wSecond  << ":" << ctime.wMilliseconds<< endl;
	myfile.close();
} 

void getTheContour(Mat &image, int whichone, Mat &mask)
{ 
	for (int i=0; i<image.rows; i++) 
	{ 
		uchar *ptr = image.ptr<uchar>(i); 
		uchar *ptrmask = mask.ptr<uchar>(i);  
		for (int j=0; j<image.cols; j++) 
		{ 
			if (ptr[3*j]==0 && ptr[3*j+1]==0 && ptr[3*j+2]==0) 
			{ 
				ptrmask[3*j]=ptrmask[3*j+1]=ptrmask[3*j+2]=0; 
			}
			else if(ptr[3*j]==0 && ptr[3*j+1]==0 && ptr[3*j+2]!=0)
			{ 
				ptrmask[3*j] = 0; 
				ptrmask[3*j+1] = 255; 
				ptrmask[3*j+2] = 0; 
			}
			else if (ptr[3*j]==0 && ptr[3*j+1]!=0 && ptr[3*j+2]==0)
			{ 
				ptrmask[3*j] = 0; 
				ptrmask[3*j+1] = 0; 
				ptrmask[3*j+2] = 255; 
			}
			else if (ptr[3*j]==ptr[3*j+1] && ptr[3*j]==4*ptr[3*j+2])
			{ 
				ptrmask[3*j] = 255; 
				ptrmask[3*j+1] = 255; 
				ptrmask[3*j+2] = 0; 
			}
			else if (4*ptr[3*j]==ptr[3*j+1] && ptr[3*j+1]==ptr[3*j+2]) 
			{ 
				ptrmask[3*j] = 255; 
				ptrmask[3*j+1] = 0; 
				ptrmask[3*j+2] = 255; 
			}
			else if (ptr[3*j]==4*ptr[3*j+1] && ptr[3*j]==ptr[3*j+2])
			{ 
				ptrmask[3*j] = 0; 
				ptrmask[3*j+1] = 255; 
				ptrmask[3*j+2] = 255; 
			}
			else if (ptr[3*j]==2*ptr[3*j+1] && ptr[3*j+1]==ptr[3*j+2])
			{ 
				ptrmask[3*j] = 255; 
				ptrmask[3*j+1] = 255; 
				ptrmask[3*j+2] = 255; 
			}
			else if (ptr[3*j]==ptr[3*j+1] && ptr[3*j]==ptr[3*j+2])
			{ 
				ptrmask[3*j] = 255; 
				ptrmask[3*j+1] = 0; 
				ptrmask[3*j+2] = 0; 
			}
			else 
			{ 
				std::    cout <<"Error with contour!" << endl; 
			} 
		} 
	} 
}