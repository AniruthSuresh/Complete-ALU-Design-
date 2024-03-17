import os
import subprocess
import re

# This clears the output file
fp3 = open("output_comp.txt",'w')
fp3.close()

#this is the command this helps to choose which file to run
command = "ngspice destination_comp.ckt"
delay = []


#start of script
for j in range(0,8): #j represents the iteration of input. since we have 8 inputs we have kept it as 0,8
    if j<4:
        s1 = "a"+str(j)   #for input sequence 0000 1111 output = 1111 s1 indicates string1
    else:
        s1 = "b"+str(j-4) #for input sequence 1111 0000 output = 1111

    for k in range(0,2):  #i is for output sequence
    
        if(k==0):
            if(j<4):
                fp1 = open("Comp_file_1_delay.cir",'r')  # greater and equal 
                s2 = "greater"
            else:
                fp1 = open("Comp_file_3_delay.cir",'r')  # lesser and equal 
                s2 = "lesser"

        elif(k==1):
            if(j<4):
                fp1 = open("Comp_file_2_delay.cir",'r') #  lesser 
                s2 = "lesser"
            else:
                fp1 = open("Comp_file_4_delay.cir",'r')# greater 
                s2 = "greater"

        else:
            print("Invalid index !!")
    

        fp2 =open("destination_comp.ckt",'w') #destination file for running
        fp3 = open("output_comp.txt",'a') #final output file

        data = fp1.read() #reading data from file to a string

        s3 = "equal" # standard always 

        search_text = "*target text"

        mode1 = "RISE"
        mode2 = "RISE"
        mode3 = "FALL"
        mode4 = "FALL"

        mode5 = "RISE"
        mode6 = "FALL"
        mode7 = "FALL"
        mode8 = "RISE"
       
       
        if(k==1):
            replace_text = f'''
    .measure tran trise_lesser 
    + TRIG v({s1}) VAL = 'SUPPLY/2' {mode5} =1
    + TARG v({s2}) VAL = 'SUPPLY/2' {mode6} =1 

    .measure tran tfall_lesser
    + TRIG v({s1}) VAL = 'SUPPLY/2' {mode7} =1 
    + TARG v({s2}) VAL = 'SUPPLY/2' {mode8}=1

    .measure tran tpd_{s2} param = '(trise_lesser + tfall_lesser)/2' goal = 0
            '''


        else:
            replace_text = f'''
    .measure tran tfrise_greater 
    + TRIG v({s1}) VAL = 'SUPPLY/2' {mode1} =1
    + TARG v({s2}) VAL = 'SUPPLY/2' {mode2} =1 

    .measure tran tfall_greater
    + TRIG v({s1}) VAL = 'SUPPLY/2' {mode3} =1 
    + TARG v({s2}) VAL = 'SUPPLY/2' {mode4}=1

    .measure tran tpd_{s2} param = '(tfrise_greater + tfall_greater)/2' goal = 0

    

    .measure tran trise_equal
    + TRIG v({s1}) VAL = 'SUPPLY/2' {mode5} =1
    + TARG v({s3}) VAL = 'SUPPLY/2' {mode6} =1 

    .measure tran tfall_equal
    + TRIG v({s1}) VAL = 'SUPPLY/2' {mode7} =1 
    + TARG v({s3}) VAL = 'SUPPLY/2' {mode8}=1

    .measure tran tpd_eq param = '(trise_equal + tfall_equal)/2' goal = 0
            '''

        #now we replace search text with replace text in the file
        data = data.replace(search_text,replace_text)
        fp2.write(data) #this writes the modified text into a new file called temp2.ckt
        fp1.close()
        fp2.close()

        #just use this block as it is so that your command is run in the terminal and output is stored into the string named as output
        completed_process = subprocess.run(command, shell=True, text=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        if completed_process.returncode == 0:
            # Capture the standard output into a string
            output = completed_process.stdout
        else:
            output = ("Command execution failed. at",str(k),str(j))

        output = output.split('\n') #helps to seperate the string based on the new line characters


        if(k==0):
            additional_text = f"{output[-7]} input = {s1} output = {s2}\n{output[-4]} input = {s1} output = equals\n"
            fp3.write(additional_text)
            

        elif(k==1):
            output = output[-4] 
            additional_text = f" input = {s1} output = {s2}\n"
            fp3.write(output+additional_text)
