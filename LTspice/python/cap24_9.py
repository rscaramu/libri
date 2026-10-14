import re, subprocess
LTSPICE = r"C:\Program Files\ADI\LTspice\LTspice.exe"
subprocess.run([LTSPICE, "-netlist", "rc.asc"], check=True)
base = open("rc.net", errors="ignore").read()
for c in ["100n", "220n", "470n"]:
    net = re.sub(r"^(C1 \S+ \S+) \S+", rf"\g<1> {c}",
                 base, flags=re.M)
    net = net.replace(".backanno",
                      ".meas TRAN v1m FIND V(out) AT 1m")
    open(f"rc_{c}.net", "w").write(net)
    subprocess.run([LTSPICE, "-b", f"rc_{c}.net"], check=True)
    log = open(f"rc_{c}.log", errors="ignore").read()
    m = re.search(r"^v1m: .*=([-+0-9.eE]+) at", log, re.M)
    print(c, m.group(1))
