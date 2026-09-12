import sys
import numpy as np
import matplotlib
import pandas as pd
import sklearn
import torch
import torchvision

print("Python      ", sys.version.split()[0])
print("NumPy       ", np.__version__)
print("Matplotlib  ", matplotlib.__version__)
print("pandas      ", pd.__version__)
print("scikit-learn", sklearn.__version__)
print("PyTorch     ", torch.__version__)
print("torchvision ", torchvision.__version__)
print("GPU disponibile:", torch.cuda.is_available())

x = torch.tensor([[1.0, 2.0], [3.0, 4.0]])
print(x @ x)
