#!/bin/sh
python3 -B -c "from calc import somma; import sys
sys.exit(0 if somma(2, 3) == 5 else 1)"
