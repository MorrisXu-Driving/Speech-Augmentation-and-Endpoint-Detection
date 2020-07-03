# Speech-Augmentation-and-Endpoint-Detection
This repository is developed in MATLAB. Speech Augmentation is based on Adaptive Filtering while Endpoint Detection is based on Voice Activity Detection(VAD))

# Installation
## 1. git clone all files under the same directory.
`https://github.com/MorrisXu-Driving/Speech-Augmentation-and-Endpoint-Detection.git`
## 2. File Introduction
   - SpeechDetect.m: The main program.
   - SpeechSegment.m: The endpoint detection algorithm based on VAD. It returns:
      - `zcr`: zero-crossing rate(ZCR),
      - `amp`:Short-time Energy(STE),
      - `voiceseg`: a class containing start,end,duration of each speech signal:,
      - `vsl`: total number of speech segments,
      - `SF`: An array with speech frame labeled 1,
      - `NF`: An array with non-speech frame labeled 1
   - SegmentInfo: A depend function in SpeechSegment.m
   - frame2time: Calculate the corresponding time step of each frame after enframing the signal
   - zc2.m: Calculate the ZCR of each frame
   
 # Algorithm Architecture
 ## 1. Speech Augmentation based on Adaptive Filtering
 The technique used in this algorithm is MMSE filter, also called Wiener filter. It is an LTI system that was shown below
 <div align=center><img src="https://github.com/MorrisXu-Driving/Speech-Augmentation-and-Endpoint-Detection/blob/master/Readme_img/MMSE_1.JPG"></div>   

### a. Optimization Objective
The filter has an optimization object that **'V<sub>2</sub>*W=V<sub>1</sub>'**. Intuitively, the filter is trying to learn the __impulse response__ for the noise propogating from noise source to the wanted signal source.
### b. Optimization Method
After determing the optimization objective, we need to determine the optimization approach. Since the MSE is a typical **convex optimization** problem, using Gradient Descent or Random Gradient Descent(SGD) is simple and efficient. The following equation shows the optimization approach in this project.
 <div align=center><img src="https://github.com/MorrisXu-Driving/Speech-Augmentation-and-Endpoint-Detection/blob/master/Readme_img/image.png"></div>   

### c. Denoising Result
![Image](https://github.com/MorrisXu-Driving/Speech-Augmentation-and-Endpoint-Detection/blob/master/Readme_img/Before%20Denoising.png)  
Speech Waveform before denoising(SNR:-6dB)
![Image](https://github.com/MorrisXu-Driving/Speech-Augmentation-and-Endpoint-Detection/blob/master/Readme_img/After%20Denoising.png)  
Speech Waveform after denoising(SNR:16.2dB)
