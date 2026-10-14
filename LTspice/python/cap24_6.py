from spicelib import RawRead

r = RawRead("rca.raw")
print(r.get_trace_names())
print(r.get_steps())
v = r.get_trace("V(out)")
print(abs(v.get_wave(1)[0]))
