import os
import subprocess
from os.path import basename

# directory containing noise files
noiseDir = "noise/"
# directory containing signal files
signalDir = "voice/"
# destination directory for mixed files
outputDir = "mixed/"
# destination directory for clean files
cleanDir = "clean/"

pathsToNoise = [os.path.join(noiseDir,fn) for fn in next(os.walk(noiseDir))[2]]
pathsToSignal = [os.path.join(signalDir,fn) for fn in next(os.walk(signalDir))[2]]
pathsToOutput = []

for noisePath in pathsToNoise:
  for signalPath in pathsToSignal:
	outFileName = os.path.splitext(basename(noisePath))[0] + "_" + os.path.splitext(basename(signalPath))[0] + ".wav"
	outFilePath = os.path.join(outputDir, outFileName)
	if "DS_Store" not in noisePath and "DS_Store" not in signalPath:
		print "==============================================================================="
		#mix audio
		subprocess.call(["sox", "-m", noisePath, signalPath, outFilePath])
		pathsToOutput.append(outFilePath)

		#print stats of mixed
		proc = subprocess.Popen(["sox", outFilePath, "-n", "stats"], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
		out, err = proc.communicate()
		
		lines = err.splitlines()

		print outFilePath
		for i in lines:
			if "RMS Pk dB" in i:
				print i
			if "RMS Tr dB" in i:
				print i

		#clean audio
		cleanFileName = os.path.splitext(basename(outFilePath))[0] + "_cleaned.wav"
		cleanFilePath = os.path.join(cleanDir, cleanFileName)

		subprocess.call(["sox", outFilePath, "-n", "noiseprof", "noise.prof"])
		subprocess.call(["sox", outFilePath, cleanFilePath, "noisered", "noise.prof", "0.19"])

		#print stats of clean
		proc = subprocess.Popen(["sox", cleanFilePath, "-n", "stats"], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
		out, err = proc.communicate()
		print cleanFilePath
		lines = err.splitlines()
		for i in lines:
			if "RMS Pk dB" in i:
				print i
			if "RMS Tr dB" in i:
				print i