# EPG (MATLAB version)
Implementation of the Extended Phase Graph (EPG) simulation algorithm for multi-echo MRI.
For the theory, see https://www.ncbi.nlm.nih.gov/pubmed/24737382 (Weigel, 2015) or read [this powerpoint presentation](https://github.com/imr-framework/epg-matlab/blob/master/epg/EPG-notes-presentation.pptx).

A Python version can be find within the same project as https://github.com/imr-framework/epg.

## Introduction

This document describes how to use the EPG scripts for multi-echo MR pulse sequence simulation. The inputs and outputs of functions are specified, and a detailed demo is included for the Turbo Spin Echo sequence. 
The scripts have been developed by Gehua Tong and Sairam Geethanath based on Weigel's paper (2015).

The extended phase graph algorithm is an alternative to time-domain Bloch simulations. Operating in the Fourier domain, it enables straightforward echo detection and is valuable for multi-echo sequences such as Turbo Spin Echo. The current scripts are capable of simulating the response to regularly spaced RF pulses with arbitrary phase and flip angle with linear gradients and T1, T2 relaxation effects. By “regularly spaced”, we mean that the intervals between pulses are integer multiples of the same Δt. Arbitrary spacing can be approximated with a small Δt and a large number of intervals, but the simulation will take a longer time. 

## Using the EPG functions 

EPG simulation can be accomplished by simply installing MATLAB (R2018a) and running the functions. A list of core functions is provided below:

* `rf_rotation.m`
* `shift_grad.m`
* `relax.m`
* `EPG_custom.m`
* `findEchoes.m`
* `display_epg.m`

Other scripts named `EPGsim_X.m` are predefined pulse sequences that take inputs of parameters and use these core functions to simulate EPGs. 

## Operators

EPG represents the magnetization in terms of configuration states. At any time, the configuration matrix Ω looks like this:

<p align="center"> <a>
    <img title="eqn1" src="https://github.com/imr-framework/epg-matlab/blob/master/EPG_guide_equations/e1.PNG" width="225">
  </a></p>
	
There are three basic operators in EPG simulation: RF pulse, gradient shift, and T1 & T2 relaxation, represented by the functions rf_rotation, shift_grad, and relax.

* `rf_rotation(phi,alpha)` returns a 3 x 3 matrix 
* `shift_grad(dk,omega)` takes the configuration states and shifts it by an integer dk 
* `relax(tau,T1,T2,omega)` returns the new omega after relaxation over interval tau

### RF Rotation

The rotation operator exchanges the F+, F-, and Z populations within each k. 
The operator is equivalent to a matrix multiplication, Ω=T(Φ,α)Ω, where:

<p align="center"> <a>
    <img title="eqn2" src="https://github.com/imr-framework/epg-matlab/blob/master/EPG_guide_equations/e2.PNG" width="400">
  </a></p>

### Gradient shift
A positive unit gradient (dk = 1) moves all the F populations to a higher k but keeps the Z populations in place. For example:

<p align="center"> <a>
    <img title="eqn3" src="https://github.com/imr-framework/epg-matlab/blob/master/EPG_guide_equations/e3.PNG" width="500">
  </a></p>

With a negative gradient, the populations move in the opposite direction, and as gradients are applied, the matrix grows more columns.

### T1 & T2 Relaxation
T1 and T2 relaxation are represented together in the following operator. Over a time interval τ, the relaxation factors are E1=exp(-τ/T1) and E2=exp(-τ/T2).

For k = 0:

<p align="center"> <a>
    <img title="eqn4" src="https://github.com/imr-framework/epg-matlab/blob/master/EPG_guide_equations/e4.PNG" width="350">
  </a></p>	
  
And for k ≠0,

<p align="center"> <a>
    <img title="eqn5" src="https://github.com/imr-framework/epg-matlab/blob/master/EPG_guide_equations/e5.PNG" width="270">
  </a></p>	


##  Custom EPG
Use EPG_custom.m to simulate your own pulse sequence. The struct seq needs to have the appropriate fields defined. Here is an example:

```MATLAB
# Simulate double spin echoes with EPG

seq.rf = [  0     0      0
           90   180    180];
               
seq.grad =[1,1,1,1];

seq.events = {'rf','grad','relax','rf','grad','relax','grad','relax','rf','grad','relax'};

seq.time = [0,10,10,10,20,20,30,30,30,40,40];

seq.T1 = 1000; seq.T2 = 100;

[om_store,echoes] = EPG_custom(seq); 
 ```
 You can view the configuration matrices with `om_store{n}`, which corresponds to the n-th event in seq.events and the n-th time in seq.time.

## Pre-defined pulse sequences
Pre-defined pulse sequence simulation functions are titled `EPGsim_X.m` and their usage can be easily accessed using the help function in MATLAB. Here are some common arguments.

* alpha / alphas : flip angle

* rlx : relaxation mode, in a 1 x 2 vector [T1,T2] (unit: ms)

* TR/esp : repetition time / echo spacing (unit: ms) – related to the spacing between RF pulses

* N – number of repeats


All of them share the outputs `[om_store, echoes]` where om_store is a cell array of Ω matrices recorded in time and echoes are nonzero F(0) absolute values and their timings found usually by the function findEchoes. The dimension of echoes is (U x 2) with timing in the 1st column and intensities in the 2nd column. 

##  Displaying EPGs and echoes
`display_epg(om_store, seq, annot)` can be used to visualize simple EPGs (using it to display simulations with too many repeats is not recommended). 

To plot echoes, simply plot the output `echoes` with the 2nd column on the y-axis and the 1st column on the x-axis. For an intermediate number of echoes, the `stem()` function can be useful too.

<p align="center"> <a>
    <img title="figure1" src="https://github.com/imr-framework/epg-matlab/blob/master/EPG_guide_equations/fig1.png" width="500">
  </a></p>	


<p align='center'> Figure 1: A simple spin echo EPG </p>

## References

*Weigel, Matthias. "Extended phase graphs: dephasing, RF pulses, and echoes ‐ pure and simple." Journal of Magnetic Resonance Imaging 41.2 (2015): 266-295.*

*Hennig J, Scheffler K. Hyperechoes. Magnetic Resonance in Medicine: An Official Journal of the International Society for Magnetic Resonance in Medicine. 2001 Jul;46(1):6-12.*

