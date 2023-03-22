"""
   PGA
   Author:  Michel Santana de Deus.
   Revision:  22-07-2020

   Requires:                       
       Python 2.7, 3
       
a1 trigger
a2 va
d1 phi
d2 theta
w1 vip
w2 vin
"""
#########################################################
#################### Declarations #######################
#########################################################


from ctypes import *
import time
from dwfconstants import *
import sys
import matplotlib.pyplot as plt
import numpy
import numpy.matlib
import math
from scipy.io import savemat



try:
    #parametro
    param = sys.argv[1]
except:
    print ("Please inform theta value")
    print ("The values should be 250<=theta<=490")
    sys.exit()

if sys.platform.startswith("win"):
    dwf = cdll.dwf
elif sys.platform.startswith("darwin"):
    dwf = cdll.LoadLibrary("/Library/Frameworks/dwf.framework/dwf")
else:
    dwf = cdll.LoadLibrary("libdwf.so")

version = create_string_buffer(16)
dwf.FDwfGetVersion(version)
print("Version: "+str(version.value))


#Variables
cycles = 2501;
rc = 10; #us
rate = c_double(0.5); #Msps
sampleFreq = rate.value*1e6
PWM_sampleFreq = 1e6
Tcycle = 500; #em us
Ncycle = int(Tcycle*rate.value);
Ntotal = int(Ncycle*cycles); #tempo total  
Nphase = int(Ncycle/2); #n pts da fase 1 e 2
Ntheta = int(Nphase - 10*rate.value); #marca o tempo total de ganho
Gmax = Tcycle/2/rc; #calculado pelo Ttheta/RC+1, RC = 10 us
Gain = 25;
#Dtheta = float((Gain - 1.0)/(Gmax - 1.0)*((Ntheta)/float(Ncycle))*100.0);
#Dtheta = 75;
#Dtheta = 100-(int(param)*100/500);
Dtheta = (int(param)*100/500);

print ("Dtheta:" + str(Dtheta))

#PWM Config
phiChannel = 0
thetaChannel = 1
hzFreq = (1./Tcycle)*PWM_sampleFreq # PWM freq Hz
prcDuty = 50 # duty cycle %

#Input Voltage Config
viDC = 1.6;
viDiff = 0.1;
vin = viDC
vip = viDC + viDiff

#Number of samples acquired
nSamples = int((cycles*Tcycle*rate.value))
print("Number of Samples Acquired: "+str(nSamples))

#Declare ctype variables for recording
hdwf = c_int()
sts = c_byte()
ai1 = (c_int16*nSamples)()
ai2 = (c_int16*nSamples)()
#offset1 = c_double()
#offset2 = c_double()
#range1 = c_double()
#range2 = c_double()
cAvailable = c_int()
cLost = c_int()
cCorrupted = c_int()
fLost = 0
fCorrupted = 0


#########################################################
################### Device Setup ########################
#########################################################
cdevices = c_int()
dwf.FDwfEnum(c_int(0), byref(cdevices))
print("Number of Devices: "+str(cdevices.value))
if cdevices.value == 0:
    print("no device detected")
    quit()
print("Opening first device")
hdwf = c_int()
dwf.FDwfDeviceOpen(c_int(0), byref(hdwf))
if hdwf.value == hdwfNone.value:
    print("failed to open device")
    quit()
    #Finished Opening device	

#########################################################
################### Theta and Phi #######################
#########################################################
hzSys = c_double() #100MHz
maxDiv = c_uint() #32768
dwf.FDwfDigitalOutInternalClockInfo(hdwf, byref(hzSys))
dwf.FDwfDigitalOutCounterInfo(hdwf, c_int(0), 0, byref(maxDiv))
# for low frequencies use divider as pre-scaler to satisfy counter limitation of 32k, up to 0.003% duty resolution
cDiv = int(math.ceil(hzSys.value/hzFreq/maxDiv.value)) #frequency divider value 100MHz/cDiv
# count steps to generate the given frequency
#cPulse = cHigh + cLow
cPulse = int(round(hzSys.value/hzFreq/cDiv))

def theta_phi():
	# duty
        cHigh = int(cPulse*prcDuty/100)
        cLow = int(cPulse-cHigh)
        '''
	print ("\nPHI DEBUG")
	print ("Generated: "+str(hzSys.value/cPulse/cDiv)+" Hz "+str(100.0*cHigh/cPulse)+"% divider: "+str(cDiv))
	print ("cPulse:" + str(cPulse))
	print ("cDiv:" + str(cDiv))
	print ("cHigh:" + str(cHigh))
	print ("cLow:" + str(cLow))
	print ("hzSys" + str(hzSys.value))
	print ("\n")
        '''
        dwf.FDwfDigitalOutEnableSet(hdwf, c_int(phiChannel), c_int(1))
        dwf.FDwfDigitalOutTypeSet(hdwf, c_int(phiChannel), c_int(0)) # DwfDigitalOutTypePulse
        dwf.FDwfDigitalOutDividerSet(hdwf, c_int(phiChannel), c_int(cDiv)) # max 2147483649, for counter limitation or custom sample rate
        dwf.FDwfDigitalOutCounterSet(hdwf, c_int(phiChannel), c_int(cLow), c_int(cHigh)) # max 32768
        dwf.FDwfDigitalOutCounterInitSet(hdwf, phiChannel, False, cDiv) 
        
        
        cHigh = int(cPulse*(Dtheta)/100)
        cLow = int(cPulse-cHigh)
        '''
        print ("\nTHETA DEBUG")
        print ("Generated: "+str(hzSys.value/cPulse/cDiv)+" Hz "+str(100.0*cHigh/cPulse)+"% divider: "+str(cDiv))
        print ("cPulse:" + str(cPulse))
        print ("cDiv:" + str(cDiv))
        print ("cHigh:" + str(cHigh))
        print ("cLow:" + str(cLow))
        print ("hzSys" + str(hzSys.value))
        print ("\n")
        '''
        dwf.FDwfDigitalOutEnableSet(hdwf, c_int(thetaChannel), c_int(1))
        dwf.FDwfDigitalOutTypeSet(hdwf, c_int(thetaChannel), c_int(0)) # DwfDigitalOutTypePulse
        dwf.FDwfDigitalOutDividerSet(hdwf, c_int(thetaChannel), c_int(cDiv)) # max 2147483649, for counter limitation or custom sample rate
        dwf.FDwfDigitalOutCounterSet(hdwf, c_int(thetaChannel), c_int(cLow), c_int(cHigh)) # max 32768
        dwf.FDwfDigitalOutCounterInitSet(hdwf, thetaChannel, False, cDiv) 
theta_phi()
#########################################################
################### Analog Output #######################
#########################################################
#Configure Analog Channels
print("Configure and start first analog out channel")
dwf.FDwfAnalogOutEnableSet(hdwf, c_int(0), c_int(1)) 
dwf.FDwfAnalogOutFunctionSet(hdwf, c_int(0), funcDC)
dwf.FDwfAnalogOutConfigure(hdwf, c_int(0), c_int(1))
dwf.FDwfAnalogOutOffsetSet(hdwf, c_int(0), c_double(vip))

print("Configure and start second analog out channel\n")
dwf.FDwfAnalogOutEnableSet(hdwf, c_int(1), c_int(1)) 
dwf.FDwfAnalogOutFunctionSet(hdwf, c_int(1), funcDC)
dwf.FDwfAnalogOutConfigure(hdwf, c_int(1), c_int(1))
dwf.FDwfAnalogOutOffsetSet(hdwf, c_int(1), c_double(vin))

#########################################################
##################### Analog In #########################
#########################################################
#set up acquisition
dwf.FDwfAnalogInChannelEnableSet(hdwf, c_int(0), c_bool(True))
dwf.FDwfAnalogInChannelEnableSet(hdwf, c_int(1), c_bool(True))
dwf.FDwfAnalogInChannelRangeSet(hdwf, c_int(0), c_double(5))
dwf.FDwfAnalogInChannelRangeSet(hdwf, c_int(1), c_double(5))
pnSize = c_int()
dwf.FDwfAnalogInBufferSizeSet(hdwf, c_int(8192))
dwf.FDwfAnalogInBufferSizeGet(hdwf, byref(pnSize))
#print("buffer size %d" % pnSize.value)
    
dwf.FDwfAnalogInAcquisitionModeSet(hdwf, acqmodeRecord)
dwf.FDwfAnalogInFrequencySet(hdwf, c_double(sampleFreq))
dwf.FDwfAnalogInRecordLengthSet(hdwf, c_double(nSamples/sampleFreq)) # -1 infinite record length
dwf.FDwfAnalogInTriggerSourceSet(hdwf, trigsrcDigitalOut) #Set the digital out as the trigger source

range1 = c_double()
range2 = c_double()
offset1 = c_double()
offset2 = c_double()
dwf.FDwfAnalogInChannelRangeGet(hdwf, c_int(0), byref(range1))
dwf.FDwfAnalogInChannelRangeGet(hdwf, c_int(1), byref(range2))
dwf.FDwfAnalogInChannelOffsetGet(hdwf, c_int(0), byref(offset1))
dwf.FDwfAnalogInChannelOffsetGet(hdwf, c_int(1), byref(offset2))
'''
print("Scope 1 Range: "+str(range1.value)+"V Offset: "+str(offset1.value)+"V")
print("Scope 2 Range: "+str(range2.value)+"V Offset: "+str(offset2.value)+"V")
print("\n")
print("Wait after first device opening the analog in offset to stabilize")
'''
time.sleep(2)
       
#########################################################
#################### Acquisition ########################
#########################################################
for k in range(255, int(param)+5, 5):
        
        ai1 = (c_int16*nSamples)()
        ai2 = (c_int16*nSamples)()
        
        Dtheta = (k*100/500);
        
        theta_phi()
        
        print("Theta="+str(k))
        #print("Starting acquisition...")
        dwf.FDwfAnalogInConfigure(hdwf, c_bool(0), c_bool(1))
        
        #print("Waiting for acquisition...")
        dwf.FDwfDigitalOutConfigure(hdwf, c_int(1))
        
        iSample = 0
        
        while True:
            dwf.FDwfAnalogInStatus(hdwf, c_int(1), byref(sts))
        
            dwf.FDwfAnalogInStatusRecord(hdwf, byref(cAvailable), byref(cLost), byref(cCorrupted))
            
            iSample += cLost.value
            iSample %= nSamples
        
            if cLost.value :
                fLost = 1
            if cCorrupted.value :
                fCorrupted = 1
        
            iBuffer = 0
            while cAvailable.value>0:
                cSamples = cAvailable.value
                # we are using circular sample buffer, make sure to not overflow
                if iSample+cAvailable.value > nSamples:
                    cSamples = nSamples-iSample
                dwf.FDwfAnalogInStatusData16(hdwf, c_int(0), byref(ai1, sizeof(c_int16)*iSample), c_int(iBuffer), c_int(cSamples)) # get channel 1 data
                dwf.FDwfAnalogInStatusData16(hdwf, c_int(1), byref(ai2, sizeof(c_int16)*iSample), c_int(iBuffer), c_int(cSamples)) # get channel 2 data
                iBuffer += cSamples
                cAvailable.value -= cSamples
                iSample += cSamples
                iSample %= nSamples
                '''
                print("iSample ",iSample)
                print("cSamples ",cSamples)
                print("iBuffer ",iBuffer)
                print("nSamples ",nSamples)
                print("phi ",len(ai1))
                print("\n")
                '''
            if sts.value == 2 : # done
                break
        
        
        
        # align recorded data
        if iSample != 0 :
            ai1 = ai1[iSample:]+ai1[:iSample]
            ai2 = ai2[iSample:]+ai2[:iSample]
        
        #print("Recording done")
        if fLost:
            print("Samples were lost! Reduce frequency")
            fLost = 0
        if fCorrupted:
            print("Samples could be corrupted! Reduce frequency")
            fCorrupted = 0
        
        #Create a list to convert sample numbers into microseconds
        x=[]
        Va=[]
        Vo=[]
        for i in range(nSamples):
            x.append(float(sampleFreq*i/sampleFreq)/rate.value)
            Va.append(float(ai1[i]*range1.value/65536+offset1.value))
            Vo.append(float(ai2[i]*range2.value/65536+offset2.value))
        if k>=255:
            mdic = {"Vo": Vo, "Vi": Va, "time": x}
            savemat("exp0/%d.mat" % int(k), mdic)
        '''
        plt.plot(x,numpy.fromiter(Vo, dtype = numpy.float),label = "Vo")
        plt.plot(x,numpy.fromiter(Va, dtype = numpy.float),label = "Va")
        plt.legend(loc='best')
        plt.xlabel("Time (µs)")
        plt.ylabel("Analog Voltage (V)")
        plt.show()
        '''

dwf.FDwfAnalogOutReset(hdwf, c_int(0))
dwf.FDwfDeviceCloseAll()
#Stop the pattern generator
dwf.FDwfDigitalOutConfigure(hdwf, c_int(0))

#This function closes devices opened by the calling process
dwf.FDwfDeviceCloseAll()
