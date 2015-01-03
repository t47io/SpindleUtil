SpindleUtil
===========

SpindleUtil is a set of MATLAB scripts to facilitate the process of spindle line-scan quantitation. It is aimed to improve the productivity by replacing the “traditional” way of manually draw lines in MetaMorph and process data by hand using Excel. SpindleUtil makes it much easier in rotating the image to position poles vertically. It also introduces box-scan, as well as the line-scan as a comparison. SpindleUtil automates the quantitation, data visualization, comparison, and data management, making it all done in MATLAB. 

SpindleUtil aims to take over the whole process using MATLAB, eliminating the complicated and time-consuming data transfer. SpindleUtil takes advantage of an interactive interface for spindle rotation and boundary setup, which is faster than in MetaMorph or ImageJ. SpindleUtil quantitates the intensity from the original TIFF, and overlays them to each other using normalized inter-pole distance. This is much faster than Excel. SpindleUtil automatically saves all figures, log, and workspace data to an “analysis” folder in an organized way.

One advantage of using SpindleUtil is its box-scan quantitation, especially when comes to deformed spindle geometry, e.g. splayed poles. Line-scan quantitation only takes account for the center line (pole-pole line) and 2 side-lines. This is representative in regular spindles, but may be inaccurate and losing information. Box-scan draws as many lines as possible in the spindle (including the 3 lines in line-scan), and thus averaging the whole spindle. This is useful in e.g. splayed pole case where the pole is not focused.

Complete manual:
<strong>Scripts/SpindleQuantify/README.pdf</strong>