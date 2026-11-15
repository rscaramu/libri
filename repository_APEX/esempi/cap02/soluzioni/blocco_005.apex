Integer anno = 1900;
Boolean bisestile =
    (Math.mod(anno, 4) == 0 && Math.mod(anno, 100) != 0)
    || Math.mod(anno, 400) == 0;
System.debug(bisestile);
