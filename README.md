# Speech-Augmentation-and-Endpoint-Detection
This repository is developed in MATLAB. Speech Augmentation is based on Adaptive Filtering while Endpoint Detection is based on Voice Activity Detection(VAD)
# Prerequisite
Please make sure that your MATLAB has installed **Voicebox**. This toolbox contains important functions such as `enframe()`. This is their official website:http://www.ee.ic.ac.uk/hp/staff/dmb/voicebox/voicebox.html
Installation of this toolbox is everywhere on the website. Please google it yourself.

# Installation
## 1. git clone all files under the same directory.
1. `https://github.com/MorrisXu-Driving/Speech-Augmentation-and-Endpoint-Detection.git`
2. Run `SpeechDetect.m` in MATLAB.
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
## 3. Parameter Setting:
   - Parameter in `SpeechDetect.m`:
      - `wlen`: enframing window length
      - `inc`: enframing increment
      - `IS`: The time duration in second of the non-speech/background signal at the start of input audio
   - Parameter in `SpeechSegment.m`:
      - `maxsilence`: Maximum length of silence in frame number accepted in one speech segment
      - `minspeech`: Minimum length of speech signal in frame number accpeted to recognize it as a speech segment
      - `r1`: threshold coefficient for lower bound of STE gate
      - `r2`: threshold coefficient for upper bound of STE gate
      - `r3`: threshold coefficient for ZCR gate.  
     **To understand the parameters please go through the Algorithm Architecture carefully!**

   
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
Speech Waveform before denoising(SNR:-6dB)  
![Image](https://github.com/MorrisXu-Driving/Speech-Augmentation-and-Endpoint-Detection/blob/master/Readme_img/Before%20Denoising.png)  
Speech Waveform after denoising(SNR:16.2dB)  
![Image](https://github.com/MorrisXu-Driving/Speech-Augmentation-and-Endpoint-Detection/blob/master/Readme_img/After%20Denoising.png)  


## 2. Endpoint Detection based on VAD 
### a. Algorithm Flow
In this projeect the algorithm determins the speech/non-speech frame based on `Short-Time Energy(STE)` and `Zero-Crossing Rate(ZCR)` of background signal at the start of input audio, the signal between 0-IS. The judgement flowchart is shown below:
![Image](https://github.com/MorrisXu-Driving/Speech-Augmentation-and-Endpoint-Detection/blob/master/Readme_img/Endpoint%20Detection.png)  
### b. Detection Result
The result on clean speech signal:  
![Image](https://github.com/MorrisXu-Driving/Speech-Augmentation-and-Endpoint-Detection/blob/master/Readme_img/ED-chean.png)  
The result on the denoising signal:  
![Image](https://github.com/MorrisXu-Driving/Speech-Augmentation-and-Endpoint-Detection/blob/master/Readme_img/ED-noise.png)  

The endpoints detected in yellow is wrong, which means that more features need to consider when tackling with high ZCR signals.
