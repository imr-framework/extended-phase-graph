# extended-phase-graph
Extended Phase Graph


How to run the EPG code:

Wrapper: ex. : TSE_EPG (echo intensities can be verified with figure 12 in Weigel, JMR 2014)

1.	Initiate magnetization values in omega which is typically [0 0 1]’
2.	Define the event: rf pulse through rf_rotation and gradient through shift_grad
3.	Define the sequence of events chronologically in terms of pulses, gradients, relaxation and so on.
4.	Store output at each stage omega in om_store to enable visualization
5.	Define the following inputs to the display function - seq:
		a.   seq.rf = [phi; alpha]
		b.   seq.grad = [units of shift –> delk]
		c.   seq.events = [character input in chronological order in terms of ‘rf’, ‘grad’]

rf_rotation.m
	Inputs: phi –> azimuthal angle, alpha –> rotation angle; in degrees
	Outputs: T_phi_alpha (Transform operator for rotation) 

shift_grad.m
	Inputs: delk –> shift units, omega –> current magnetization vector before gradient application
	Outputs: shifted magnetization vector after gradient application

get_relaxation.m
	Inputs: T1, T2, t
	Outputs: E matrix which captures information about relaxation


This code works on Matlab version 7.10.0(R2010a) and version 7.10.0(R2013a)



