String categoria = 'B';
Integer giorniConsegna;
switch on categoria {
    when 'A' {
        giorniConsegna = 1;
    }
    when 'B', 'C' {
        giorniConsegna = 3;
    }
    when else {
        giorniConsegna = 7;
    }
}
System.debug(giorniConsegna);
