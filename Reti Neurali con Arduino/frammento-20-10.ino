// frammento-20-10.ino — La riga da mettere in ogni sketch, dopo la prima inferenza. Con la libreria di Edge Impulse il valore compare nel report di build in Studio.

Serial.printf("arena: %u usati su %u\n",
              interprete->arena_used_bytes(), kArena);
