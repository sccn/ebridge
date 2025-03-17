# eBridge EEGLAB plugin

See this page https://psychophysiology.cpmc.columbia.edu/software/eBridge/index.html
The page content is copied below for reference.

# Purpose

eBridge.m identifies channels in a continuous or epoched EEG recording that are linked by low-impedance electrical bridges, and is designed for use with the EEGLAB toolbox in MATLAB.

# Citation

The original MATLAB code was developed in 2013 at the Psychophysiology Laboratory of the New York State Psychiatric Institute, as described in the following publication:

**Manuscript in PDF format:**  
Alschuler DM, Tenke CE, Bruder GE, Kayser J. (2014). *Identifying electrode bridging from electrical distance distributions: a survey of publicly-available EEG data using a new method.* Clinical Neurophysiology, 125(3), 484-490. doi:10.1016/j.clinph.2013.08.024

If you use eBridge.m as part of your data preprocessing, processing, or analysis, please cite the above article in your publication(s).

# Use and Authorization

This software, intended for non-profit scientific research, is copyright-protected under the GNU General Public License  
(see agreement at [http://www.gnu.org/licenses/gpl.txt](http://www.gnu.org/licenses/gpl.txt)).  
It applies to all content included in the eBridge.m file. The software is provided *as is* with no warranty whatsoever,  
and all responsibilities and consequences of using this software lie with the user.  
For suggestions, bugs, or any other related issues, please contact Daniel Alschuler at [dmaadm@outlook.com](mailto:dmaadm@outlook.com).

# Download and Installation

eBridge.m consists of a single MATLAB function text file. Download this file and add it to a local folder on your hard drive that is part of the MATLAB search path.  
Please note that MATLAB is necessary for running this function, and certain options will not work without EEGLAB and the MATLAB Signal Processing Toolbox.

# Background and Overview

Electrode bridges are typically caused by electrolyte spreading between adjacent electrodes, resulting in near-identical signals in the two channels and distorting the corresponding EEG topography (Tenke and Kayser, 2001; Greischar et al., 2004). Contrary to popular belief, electrode bridges may be fairly common in EEG recordings (Alschuler et al., 2013, in press).  
eBridge.m was developed as an automated and system-independent technique for identifying electrode bridges by exploiting statistical properties of the electrical distance measure (Tenke and Kayser, 2001).

# Other Publications about Electrode Bridges

**Greischar L.L., Burghy C.A., van Reekum C.M., Jackson D.C., Pizzagalli D.A., Mueller C., Davidson R.J. (2004).**  
Effects of electrode density and electrolyte spreading in dense array electroencephalographic recording. *Clinical Neurophysiology, 115*(3), 710-720.

**Manuscript in PDF format:**  
Tenke, C.E., Kayser, J. (2001). A convenient method for detecting electrolyte bridges in multichannel electroencephalogram and event-related potential recordings. *Clinical Neurophysiology, 112*(3), 545-550.

# Tutorial

## 1. Background on Electrical Bridging

### A. Electrical bridges

An electrical bridge occurs when two EEG electrodes are joined together by a low-impedance electrical connection (Tenke and Kayser, 2001). A bridge can be caused by a fault in the EEG hardware (e.g., problem with a connector, two bare wires touching, etc.) or, more commonly, by excessive use of electrolyte, causing the gel or liquid from neighboring channels to touch (Greischar et al., 2004; Tenke and Kayser, 2001).

When EEG electrodes are electrically bridged, the information in their respective channels will be nearly identical, distorting the EEG topography. Unfortunately, electrical bridging is not readily apparent when viewing continuous, epoched, or averaged data, even for a limited number of EEG channels.

In a systematic survey of publicly available EEG datasets (Alschuler et al., 2013), channels were identified as bridged in 3 out of the 5 tested datasets. In 2 of these 3 datasets, bridged channels were found in 75% or more of sessions, with up to 50% of the electrodes in the montage bridged in some sessions.

### B. Identifying bridged channels

The only reliable methods for finding bridged electrodes rely on pairwise comparisons between channels to detect nearly identical signals. Graphically superimposing two EEG/ERP waveforms can reveal bridged electrodes, but this approach is time-consuming and may miss some bridges. Instead, a systematic numerical approach based on the temporal variance of pairwise differences between waveforms recorded at each electrode can be used.

A potential difference waveform is defined as the difference between the time-varying potentials **P** of channels *i* and *j*. Because any two channels that are electrically bridged will have near-identical waveforms, bridged channels can be identified as pairs with low-amplitude difference waveforms. The overall amplitude of a difference waveform can be quantified by its variance over time **T** (temporal variance; Tenke and Kayser, 2001; Neuroscan Inc., 1993; 1995).

eBridge.m employs the algorithm outlined in Alschuler et al. (2013) by using electrical distance (ED) frequency distributions to identify bridged channels. The continuous EEG data are first epoched into a **channels × epochs × sample points** MATLAB matrix. An ED matrix of size **channels × channels × epochs** is then computed from this epoched data, and each ED value is multiplied by a scale factor (100 / median ED value). The resulting EDs are summarized by their frequency distribution, which is interpolated to a bin size of 0.05 to improve reliability and resolution.

*Enlarge figure*  
*Annotated ED frequency distributions (0–10)*

Please note the near-zero local peak (LP) in the distribution when 6 bridged channels are present. Such local peaks, confined almost exclusively to sessions with bridging, represent the extremely low EDs of bridged channel pairs. The algorithm detects a near-zero local peak (ED ≤ 3) and, if present, automatically identifies the local minimum (LM) with an ED ≤ 5 following the peak as the ED cutoff. If 50% or more of all epochs for a given pair of channels have EDs at or below this cutoff, both channels are classified as bridged.

[Back to top](#eBridge-tutorial)

---

## 2. Using eBridge.m

This section of the tutorial was written for MATLAB v7.10.0 (R2010a) and EEGLAB v11.0.3.1b, but the instructions generally apply to other versions with slight modifications.

### A. Getting started

- **MATLAB must be installed.**  
- For additional eBridge options, the Signal Processing Toolbox is required (it can be added via the MATLAB installer).  
- **EEGLAB must be downloaded** and added to the MATLAB search path (in MATLAB, go to **File >> Set Path >> Add with Subfolders**, then select the EEGLAB folder).

To begin, download **eBridge.m** and the **eBridge.cnt** sample EEG file (ensure that **eBridge.m** is in a folder included in the MATLAB search path). Then open MATLAB and enter:

```matlab
>> eeglab
```

## B. Importing data

The NeuroScan format file **eBridge.cnt** is provided as an example of continuous EEG data. To import it using the EEGLAB GUI:
- Open the EEGLAB window and select **File >> Import data >> Using EEGLAB functions and plugins >> From Neuroscan .cnt file**.
- Select **eBridge.cnt** and click “Open”.
- In the “Load a CNT dataset” and “Dataset info” windows, click “Ok” for each prompt.

The EEG data will then be imported into MATLAB as the data structure named **EEG**.

Alternatively, you can import the file using the `pop_loadcnt` function on the command line:

```matlab
>> help pop_loadcnt
```

## C. Running eBridge

To run eBridge.m on the imported data, enter:

```matlab
>> EB = eBridge(EEG);
```

This command executes the eBridge function with the EEG data structure. Information about identified bridges will be displayed in the command window and stored in the EB structure.

```markdown
## D. eBridge screen output

During execution, the following messages may appear:

```plaintext
>> eBridge: Configuring inputs.
```

*Indicates that input variables and flags are being checked and assigned.*

```plaintext
>> eBridge: Epoch length set to XXX sample points. YYYY epochs extracted.
```

*Confirms the extraction of YYYY epochs, each with XXX sample points.*

```plaintext
>> eBridge: Computing EDs for xx/XX chans, YYYY epochs, and ZZ points/epoch.
```

*Shows that electrical distances are being computed.*

```plaintext
>> eBridge: Creating ED frequency distribution and finding bridged channels.
```

*The frequency distribution of EDs is being created and bridged channels identified.*

```plaintext
>> eBridge: Number of bridged channels: #
```

*Displays the total number of channels flagged as bridged (e.g., 6 for eBridge.cnt).*

```plaintext
>> eBridge: Bridged channel labels:   Label1 Label2 … LabelN
```

*Lists the labels of the bridged channels (e.g., PO7, PO3, IZ, I1, I2, PO9 for eBridge.cnt).*

```plaintext
>> eBridge: Bridged channel pairs:    (Pair1a,Pair1b) (Pair2a,Pair2b) … (PairNa,PairNb)
```

*If ‘Verbose’ is set to 2, displays the pairs of channels that are near-identical.*

A plot of the ED distribution will also appear.

*Enlarge figure*  
*ED distribution plot (0–500)*  
*ED distribution plot (0–5)*

To zoom in on the early local peak and local minimum, change the x-axis limits from 0–500 to 0–5 by entering:

```matlab
>> set(gca,'XLim',[0 5]);
```

For more information on output variables, additional options, and methods to improve the accuracy and speed of eBridge.m, refer to the in-function help by entering:

```matlab
>> help eBridge
```

Additional detailed help is available by entering:

```matlab
>> eBridge /?
```
or
```matlab
>> eBridge /h
```

## 3. Preventing and Addressing Electrical Bridges

Using as little electrolyte as possible for the scalp-sensor interface minimizes the risk of bridges between electrodes, provided that a sufficient (i.e., low impedance) contact with the scalp is maintained. While it is often assumed that more electrolyte (electrode gel) yields better contact, only a small amount placed directly beneath the electrode is needed. For a 72-channel Biosemi system, 10 to 20 mL of SignaGel electrolyte is optimal for subjects with little to no hair or with long, thick hair, though this may vary with different systems and electrolyte types.

Since an electrolyte bridge cannot be undone once it occurs, it is advisable to use less electrolyte at the start of the cap setup. For sites with high impedances, the scalp may be gently abraded at the electrode site (Kappenmann and Luck, 2010) and additional electrolyte applied only if necessary. Additionally, amplifier and electrode cables, plugs, and connectors should be checked to ensure there are no physical shorts.

Bridged electrodes can be addressed after recording by excluding affected channels or averages, or by interpolating the data from bridged channels if the EEG montage contains a sufficient number of artifact-free channels.

References

	•	Alschuler, D.M., Tenke, C.E., Brudge, G.E., Kayser, J. (2014).
Clinical Neurophysiology, 125(3), 484-490.
doi:10.1016/j.clinph.2013.08.024
	•	Greischar, L.L., Burghy, C.A., van Reekum, C.M., Jackson, D.C., Pizzagalli, D.A., Mueller, C., Davidson, R.J. (2004).
Effects of electrode density and electrolyte spreading in dense array electroencephalographic recording.
Clinical Neurophysiology, 115(3), 710-720.
	•	Kappenmann, E.S., Luck, S.J. (2010).
The effects of electrode impedance on data quality and statistical significance in ERP recordings.
Psychophysiology, 47, 888-904.
	•	Tenke, C.E., Kayser, J. (2001).
A convenient method for detecting electrolyte bridges in multichannel electroencephalogram and event-related potential recordings.
Clinical Neurophysiology, 112(3), 545-550.

# version

0.1.01 - intitial version copied from https://psychophysiology.cpmc.columbia.edu/software/eBridge/index.html
