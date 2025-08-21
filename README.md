# Automatic-Modulation-Classification-using-Deep-Learning
This project is made by me during my Masters Dissertation, where I designed an CNN model which automatically classify modulated signal using Convolutional Neural Networks and USRP Hardware. 

This project implements an **SDR-based Automatic Modulation Classification (AMC)** system using **USRP B210** hardware and **MATLAB Deep Learning Toolbox**.  
The system classifies modulated signals (ASK, BPSK, QPSK, etc.) using a **CNN model** trained on both synthetic and over-the-air datasets.

##  Features
- Dual-USRP B210 setup for real-time TX/RX.
- CNN-based classifier trained in MATLAB.
- Compact UHF RFID reader antenna integrated for ASK testing.
- Achieved high accuracy in simulation and hardware-in-the-loop validation.

##  Tools & Technologies
- **Hardware**: USRP B210, UHF RFID Antenna
- **Software**: MATLAB, GNU Radio, Deep Learning Toolbox
- **Modulations**: ASK, BPSK, QPSK, QAM, etc.

## Deep Learning Approach
**Method Used**

This project uses a **Convolutional Neural Network (CNN)** architecture for Automatic Modulation Classification (AMC). 
CNNs are highly effective in recognizing spatial and temporal patterns in IQ signal data, making them suitable for modulation recognition tasks.

Input Representation: IQ samples (real and imaginary parts of received signals) were reshaped into 2D matrices.

**Architecture**:

Convolutional layers extract low-level modulation features such as amplitude/phase variations.

Pooling layers reduce dimensionality while preserving key features.

Fully connected layers perform final classification across modulation types (ASK, BPSK, QPSK, QAM, etc.).

Output: Softmax layer producing class probabilities for each modulation scheme.

**Implementation**

- Data Generation:

Synthetic dataset generated in MATLAB using impaired signals (AWGN, fading, frequency offsets).

Over-the-air dataset captured using dual-USRP B210 setup and UHF RFID antenna.

- Training:

MATLAB Deep Learning Toolbox used to train CNN.

Training performed with mini-batch gradient descent and data augmentation for robustness.

- Testing:

Trained model validated both in simulation and in real-time SDR environment with USRP hardware.

**Impact of AI/ML in This Project**

- Automation: Traditional AMC requires handcrafted features (cyclostationary analysis, likelihood tests, etc.), but deep learning automatically learns optimal features from raw IQ data.

- Accuracy: CNN-based AMC achieves higher classification accuracy under noisy and fading conditions compared to classical methods.

- Scalability: The framework can be extended to classify more complex modulations or integrated into IoT/RFID communication systems.

- Real-Time Capability: By leveraging SDR hardware and CNN inference, the system demonstrates practical deployment feasibility in wireless communication and RFID environments.

 ## Retraining for ASK Modulation
 **Motivation**

Most open-source modulation classification datasets and pretrained models focus on PSK, QAM, and FSK families, while ASK (Amplitude Shift Keying) is often ignored. 
Since ASK is the dominant modulation in RFID systems, we extended the modulation classifier to include ASK for RFID-specific applications.

 **Implementation**

- Data Generation

Created ASK datasets synthetically in MATLAB, adding channel impairments (AWGN, fading, frequency/phase offsets).

Captured over-the-air ASK signals using a dual-USRP B210 setup for real-world validation.

- Model Training (From Scratch)

Built a CNN architecture from scratch, trained with randomly initialized weights (no transfer learning).

Combined ASK + other modulation types (BPSK, QPSK, QAM, etc.) to form a new dataset tailored for RFID environments.

Training optimized using mini-batch gradient descent and early stopping to avoid overfitting.

- Testing & Validation

Evaluated on both synthetic datasets and real-time USRP experiments.

Achieved high classification accuracy for ASK detection, proving model robustness in SDR-based RFID use cases.

 **Impact of This Work**

Custom Dataset Contribution – First inclusion of ASK into the CNN-based AMC framework for RFID-like environments.

From-Scratch Training – Fully retrained model, independent of existing pretrained networks.

RFID Relevance – Bridges deep learning-based AMC with RFID communication systems, making the solution practical.

Future Scalability – Framework can be extended to other IoT and RFID-specific modulation schemes.
  
  ##  Repository Structure
- `source/` : MATLAB scripts for signal generation, training, testing
- `ASK/` : ASK-specific dataset generation & detection code

  
