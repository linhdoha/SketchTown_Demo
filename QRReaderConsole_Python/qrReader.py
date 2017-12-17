import qrtools
import argparse

parser = argparse.ArgumentParser()
parser.add_argument('filepath', help="path to image file.", type=str)
args = parser.parse_args()

qr = qrtools.QR()
qr.decode(args.filepath)
print qr.data
