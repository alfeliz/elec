###########################################################################################
#
#
#  OCTAVE SCRIPT TO:
#       - READ VOLTAGE AND CURRENT ALEX DATA FROM *.CSV FILES
#		- TRANSFORM THESE DATA INTO ELECTRICAL ENERGY AND POWER DATA TO COMPARE THEM.  
#    Made by Gonzalo Rodríguez Prieto
#       (gonzalo#rprietoATuclm#es)
#       (Mail: change "#" by "." and "AT" by "@")
#              Version 1.0
#
#
#########################################################
#
#  It uses the function: 
#          display_rounded_matrix
#  It must be in the same directory.
#
###########################################################################################

# It works by standing in the folder with all the shot *.CVS data, and obtains the energy and power as output.




clear;



files = dir("*.csv"); #Find the files with CSV extension and introduce data about them in a structure with lots of information.

j = 0;

for i=1 : numel(files) #numel gives the number of elements in a structure.
  #This IF loop store the data in the adequate variables for transformation of current and voltage into energy and power(of the tiger):
  if ~isempty( regexp(files(i).name,"2Resi") ) #2-resistive divider file
   #disp(files(i).name)
   resi02 = dlmread(files(i).name,"\t");
  elseif ~isempty( regexp(files(i).name,"3Resi") ) #3-resistive divider file
   #disp(files(i).name)
   resi03 = dlmread(files(i).name,"\t");
  elseif ~isempty( regexp(files(i).name,"Current") ) #Current file
   #disp(files(i).name)
   curr =  dlmread(files(i).name);
  endif; 
j = j + 1;  
  #Now I make the calculations and save the data, after a full loop on the shot data, three files:
if j == 3  
  volt = resi02(:,2) - resi03(:,2); #V
  power = volt.*curr(:,2); #J/s
  energy = cumtrapz(curr(:,1),volt.*curr(:,2)); #J
  shotname = strtok(files(i).name,"-"); #Taking tha name from datafile.
  #Saving data:
  data = [curr(:,1).*1e6 power energy];
  redond = [4 4 4];
  name = horzcat(shotname,"_elec.csv"); #Adding the right sufix.
  output = fopen(name,"w"); #Opening the file.
  fdisp(output,"time(us)	Power(J/s) Energy(J)"); #First line.
  display_rounded_matrix(data, redond, output); 
  fclose(output);
  j = 0;
endif;
  
endfor;


#Tha, tha... that's all folks!
