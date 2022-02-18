#!/bin/python3
import sys
import matplotlib.pyplot as plt
plt.style.use('dark_background')

path = sys.argv[len(sys.argv) - 1]
f = open(path, "r")
txt = f.read().split("\n")
f.close()

if txt[-1] == "":
    txt.pop()

if len(txt) == 1 and "," in txt[0]:
    txt = txt[0].split(",")

data = [ float(s) for s in txt ]

if sys.argv[1] == "-f":
    from scipy import fftpack
    import numpy as np

    Fs = 1000000
    X = fftpack.fft(data)
    freqs = fftpack.fftfreq(len(data)) * Fs

    plt.plot(freqs, np.abs(X), color='g', marker='')
else:
    plt.plot(data, color='g', marker='')

plt.show()
