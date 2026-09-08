// frammento-07-03.ino — L'header prodotto da xxd, con const e allineamento aggiunti. I primi byte, "TFL3" in ASCII a partire dal quinto, sono la firma del formato.

#include <cstdint>
alignas(16) const unsigned char modello_tflite[] = {
  0x1c, 0x00, 0x00, 0x00, 0x54, 0x46, 0x4c, 0x33, 0x14, 0x00,
  /* ... circa 15.000 byte ... */
};
const unsigned int modello_tflite_len = 15224;
