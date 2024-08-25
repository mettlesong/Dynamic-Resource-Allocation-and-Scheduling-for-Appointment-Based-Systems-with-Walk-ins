%------------------------------------------------------------------------------------------------
% Simulation of "Appointment Scheduling and Resource Allocation for Multiple
%Diagnostic Facilities"
% VS vs. HS
% Generate the Arrival Processes of Two Types of Patients for N service
% slots
% 1: inpatient, 0: emergency patient
%------------------------------------------------------------------------------------------------

function [InNumPerI,EmNumPerI] =GenerateArri()



% Generate Arrival Time of the Two Types of Patients (1:inpatient, 0:emergency patient)

% ---------------- homogeneous arrival rate of different patient types %
InArriNum=[0 1 2 3 4 5];
InArriRate=[0.1 0.2 0.4 0.25 0.04 0.01];
EmArriNum=[0 1 2 3];
EmArriRate=[0.72 0.2 0.06 0.02];


%to generate number of arrivals per slot by distribution

%out = randsrc(m,n,[alphabet; prob]) generates an m-by-n matrix, with each entry independently chosen from 
%the entries in the row vector alphabet. Duplicate values in alphabet are ignored. 
%The row vector prob lists corresponding probabilities, so that the symbol alphabet(k) occurs with probability prob(k), 
%where k is any integer between one and the number of columns of alphabet. The elements of prob must add up to 1.

InNumPerI=randsrc(19,1,[InArriNum; InArriRate]);

EmNumPerI=randsrc(19,1,[EmArriNum; EmArriRate]);

% -------------------------------------------------------------------------------------------------------------- %
 
end

 