int main(int argc, char** argv)
{
    if (argc < 2) {
        fprintf(stderr, "uso: %s img1.pgm [img2.pgm ...]\n",
                argv[0]);
        return 1;
    }
    const int radius = 7;
    const int nslots = 3;
    setup_gaussian(radius, 2.5f);
    Image first;
    if (!read_pgm(argv[1], first)) {
        fprintf(stderr, "impossibile leggere %s\n", argv[1]);
        return 1;
    }
    int w = first.w, h = first.h;
    size_t npx = (size_t)w * h;
    Slot slots[3];
    for (int i = 0; i < nslots; ++i)
        slot_create(slots[i], npx);
    int pending[3] = { -1, -1, -1 };  // indice immagine
    cudaEvent_t t0, t1;
    CUDA_CHECK(cudaEventCreate(&t0));
    CUDA_CHECK(cudaEventCreate(&t1));
    CUDA_CHECK(cudaEventRecord(t0));
    int done = 0;
    for (int i = 1; i < argc; ++i) {
        Slot& s = slots[(i - 1) % nslots];
        int& p = pending[(i - 1) % nslots];
        if (p >= 0) {
            CUDA_CHECK(cudaStreamSynchronize(s.stream));
            Image out; out.w = w; out.h = h;
            out.px.assign(s.h_out, s.h_out + npx);
            char name[256];
            snprintf(name, sizeof name, "out_%03d.pgm", p);
            write_pgm(name, out);
            ++done;
        }
        Image img;
        if (!read_pgm(argv[i], img) || img.w != w
            || img.h != h) {
            fprintf(stderr, "salto %s\n", argv[i]);
            p = -1;
            continue;
        }
        memcpy(s.h_in, img.px.data(), npx);
        process_async(s, w, h, radius);
        p = i;
    }
    for (int k = 0; k < nslots; ++k) {
        if (pending[k] < 0) continue;
        CUDA_CHECK(cudaStreamSynchronize(slots[k].stream));
        Image out; out.w = w; out.h = h;
        out.px.assign(slots[k].h_out, slots[k].h_out + npx);
        char name[256];
        snprintf(name, sizeof name, "out_%03d.pgm",
                 pending[k]);
        write_pgm(name, out);
        ++done;
    }
    CUDA_CHECK(cudaEventRecord(t1));
    CUDA_CHECK(cudaEventSynchronize(t1));
    CUDA_CHECK(cudaGetLastError());
    float ms = 0.f;
    CUDA_CHECK(cudaEventElapsedTime(&ms, t0, t1));
    printf("%d immagini %dx%d in %.1f ms "
           "(%.2f ms/immagine)\n",
           done, w, h, ms, ms / done);
    for (int i = 0; i < nslots; ++i) slot_destroy(slots[i]);
    CUDA_CHECK(cudaEventDestroy(t0));
    CUDA_CHECK(cudaEventDestroy(t1));
    return 0;
}
