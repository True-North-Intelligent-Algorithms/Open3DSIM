# Open3DSIM

This code was forked by Brian Northan of True North Intelligent Algorithms and James Seyforth of Howard Hughes institute. 

We have made some small change to make it easier to compare to [simrecon](https://github.com/True-North-Intelligent-Algorithms/simrecon).

This code was originall created by Ruijie Cao and Prof. Peng Xi in Peking University for 3D super-resolution structure illumination microscopy reconstruction. 
They are devoted to make the SIM community open and constructive. And we will continue to improve the platform.

# Pre-requisites

## Bioformats Matlab

Get ```bfmatlab``` from [here](https://docs.openmicroscopy.org/bio-formats/6.3.1/users/matlab/index.html)

Put the ```bfmatlab``` folder in the ```MATLAB_Open_3DSIM/lib/``` folder. 

## Diplib

Get ```diplib``` from [here](https://diplib.org/).  Put the ```diplib``` folder in the ```MATLAB_Open_3DSIM/lib/``` folder.

# Running the code

Start by running the Matlab script [Open_3DSIM](https://github.com/True-North-Intelligent-Algorithms/Open3DSIM/blob/master/MATLAB_Open_3DSIM/Open_3DSIM.m)  
First you may need to convert raw SIM data so it is organized right.  Run the [prepareforopen3DSIM notebook](https://github.com/True-North-Intelligent-Algorithms/simrecon/blob/main/notebooks/sandbox/prepareforopen3DSIM.ipynb) from the [tnia simreoon](https://github.com/True-North-Intelligent-Algorithms/simrecon/tree/main).  

You may need to change the aquisition parameters [here](https://github.com/True-North-Intelligent-Algorithms/Open3DSIM/blob/master/MATLAB_Open_3DSIM/Open_3DSIM.m#L66).

You can change notch filter parameters [here](https://github.com/True-North-Intelligent-Algorithms/Open3DSIM/blob/master/MATLAB_Open_3DSIM/Open_3DSIM.m#L98).  

You can change frequency filter parameters [here](https://github.com/True-North-Intelligent-Algorithms/Open3DSIM/blob/master/MATLAB_Open_3DSIM/Open_3DSIM.m#L142)  

# Original Open3DSIM Notes from Ruijie Cao and Prof. Peng Xi

1. We provide the pure source code of three platforms of Open-3DSIM, including MATLAB, Fiji, and Exe.
2. The whole code files of three platforms can be downloaded from tags in this resposity.
3. The test_data.zip in tags provide three input format examples of OMX, N-SIM, and home-built 3DSIM systems. 
4. For more samples, please download from Figshare: https://figshare.com/articles/dataset/Open_3DSIM_DATA/21731315.
5. Each version contains a detailed user guide.
6. We also provide a video to guide users to install the Fiji version (on the above Fishare link) in Install_Fiji_Screenshot.mp4. 

Licence

    We claim an Apache licence for Open-3DSIM.

Reference

    If you use one of the material provided within Open-3DSIM such as data or code, please cite our paper: 
    Cao R, Li Y, Chen X, et al. Open-3DSIM: an Open-source three-dimensional structured illumination microscopy reconstruction platform[J]. Nature Methods: 1-4 (2023).
    https://www.nature.com/articles/s41592-023-01958-0

Contact us:

    For any questions, please contact caoruijie@stu.pku.edu.cn or xipeng@pku.edu.cn.

Updates:

    2023.12.06 Someone reflects that Open-3DSIM(Fiji v2.2) has a bug on the step of "Process data". We have correct it.
    2023.06.28 We added the reconstruction of single-layer 3DSIM in version 2.2.

Tips:

    Recently, we proposed an accelerated 3DSIM reconstruction based on spatial method called FO-3DSIM: https://github.com/Cao-ruijie/FO-3DSIM
    Open-3DSIM is robust and multi-platform compatible. FO-3DSIM is accelerated compared with Open-3DSIM, but needs higher requirement on estimated parameters.
    Users can choose according to their requirements.
