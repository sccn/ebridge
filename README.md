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

# version

0.1.01 - intitial version copied from https://psychophysiology.cpmc.columbia.edu/software/eBridge/index.html
