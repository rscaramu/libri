// frammento-17-07.ino — L'inferenza con ESP-DL, in sei righe. Il modello sta in una partizione della Flash, non in un array; il resto della struttura è la stessa di LiteRT: ingresso, esecuzione, uscita.

// ESP-DL (ESP-IDF): il nucleo dell'inferenza
#include "dl_model_base.hpp"
dl::Model modello("modello.espdl");              // dalla partizione
dl::TensorBase* in = modello.get_input();
in->assign(img, 96 * 96);                  // int8 già quantizzati
modello.run();
dl::TensorBase* out = modello.get_output();
int classe = out->argmax();
