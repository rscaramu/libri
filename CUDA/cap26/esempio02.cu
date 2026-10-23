int main(int argc, char** argv) {
    const int n = 1 << 26;
    int nchunk = (argc > 1) ? atoi(argv[1]) : 16;
    if (nchunk < 1) nchunk = 1;
    const int chunk = (n + nchunk - 1) / nchunk;
