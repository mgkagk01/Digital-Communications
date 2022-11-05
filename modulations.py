#'QPSK', '16QAM', '64QAM', or '256QAM'
import numpy as np

def BPSK(bits):
    return 1.0 - 2.0 * bits

def QPSK(bits):
    # Reshape data
    bits = np.reshape(bits, (2, -1))
    symbols = 1.0 - 2.0 * bits

    return np.sqrt(0.5) * (symbols[0, :] + 1j * symbols[1, :])


def QAM16(data):
    pass