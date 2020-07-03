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
 <div align=center><img src=""></div>
 The filter has an optimization object that'v<sub>2</sub>*W=v<sub>1</sub>'. Intuitively, the filter is trying to learn 
