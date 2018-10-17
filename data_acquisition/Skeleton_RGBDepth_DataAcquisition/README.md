Skeleton_RGBDepth_DataAcquisition
=================================

Languages Used: C++
Concepts Used: Image Processing, Multi-threading, Object-oriented programming, File I/O

Written By: Adam Li C2014

Collects Skeleton Data and Saves Color and Depth Image Streams. Collects all 20 skeleton joints and saves x,y,z coordinate data into a csv file that is saved into the local folder. Will also save color and depth images into local 'Color' and 'Depth' Image folders, for post digital-processing. 

A slight filter/smoothing algorithm is applied for the skeleton joints.

Uses OpenCV to create Mat objects for each image frame, and then saves the Mat as a .bmp image, instead of .png to save processing time (compression of png images). 

To setup:
1) Have Kinect
2) Have Visual Studio 2010, 2013
3) Fork/Download files
4) Run executable & setup saving directories in the code to output rgb images, greyscale depth and excel file with skeletal coords.

------------------------------------------------------------------------------------------------------------------------------

*This will require an i7 processor with a decent amount of RAM and SSD preferred to handle the image saving at 30fps...


Standard Operating Procedure To Setup:
Downloads and Setup:
•	Requires Windows and i7 and preferred SSD, or 5400 RPM HDD (uses heavy computation)
•	Download VS 2010 C#, C++, or entire package. Download VS 2013 entire package for Windows Desktop.
o	VS2010 is easier to use w/ older programs
o	VS2013 is very user friendly, but requires a lot of memory (restart required after installation)
•	Next download Microsoft Windows SDK, Kinect for Microsoft Toolkit, Coding4Fun Toolkit, OpenCV, and OpenNI
o	Coding4Fun Toolkit:
	Go to tools menus -> extensions and updates
	Go to update tab -> visual studio gallery

For VS2010 C++ Directories Setup (Refer to http://docs.opencv.org/doc/tutorials/introduction/windows_visual_studio_Opencv/windows_visual_studio_Opencv.html) :
Under VC++ Diretories -> Include Directories: 
•	C:\Program Files\Microsoft SDKs\Kinect\Developer Toolkit v1.8.0\inc;
•	C:\Program Files\Microsoft SDKs\Kinect\v1.8\inc;
•	C:\OpenCV2.4.9\opencv\build\include;
•	C:\OpenCV2.4.9\opencv\build\include\opencv;
•	C:\OpenCV2.4.9\opencv\build\include\opencv2;$(IncludePath)
•	*Basically include Kinect Toolkit, Microsoft SDK, OpenCV Include
Under Libarary Directories:
•	C:\Program Files\Microsoft SDKs\Kinect\Developer Toolkit v1.8.0\Lib;
•	C:\Program Files\Microsoft SDKs\Kinect\v1.8\lib\x86;$(LibraryPath)
•	*Basically include Kinect developer toolkit lib and Kinect sdk lib
Under C/C++ -> Additional Include Directories:
•	C:\OpenCV2.4.9\opencv\build\include\opencv;
•	\OpenCV2.4.9\opencv\build\include;
•	$(OPENNI2_INCLUDE);
•	$(NITE2_INCLUDE);
•	%(AdditionalIncludeDirectories)
Under Linker -> General -> Additional Include Directories:
•	C:\OpenCV2.4.9opencv\build\x86\vc10\lib;
•	$(OPENNI2_LIB);
•	$(NITE2_LIB);
•	%(AdditionalLibraryDirectories)
Under Linker-> Input -> Additional Dependencies:
•	Include the rest of the opencv lib.dll you want:
•	opencv_core249d.lib;
•	opencv_imgproc249d.lib;
•	opencv_highgui249d.lib;
•	opencv_ml249d.lib;
•	opencv_video249d.lib;
•	opencv_features2d249d.lib;
•	opencv_calib3d249d.lib;
•	opencv_objdetect249d.lib;
•	opencv_contrib249d.lib;
•	opencv_legacy249d.lib;
•	opencv_flann249d.lib;
•	OpenNI2.lib;NiTE2.lib;
•	Kinect10.lib;
•	%(AdditionalDependencies)

Problems Archive of Kinect:
1. Solved Problem for Referencing ExampleKinectExplorerWPF:
-unset read only in properties of the folder
-rebuild
-restart vs

2. Referencing OpenCV
-Properties of Projects
-C/C++ under General/Additional Include, add path to the OpenCV Include (e.g. C:\OpenCV2.4.5\opencv\include) to include all the hpp files and such
-Linker under General add path to OpenCV library for VS10, or whichever vs you are using and under 'Input' add libraries that you want.
-copy all dll files from opencv to 'Debug' folder of your project




