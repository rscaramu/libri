System.debug('a1b22c333'.replaceAll('[0-9]+', '#'));
System.debug('  troppi   spazi  qui '
    .trim().replaceAll('\\s+', ' '));
System.debug('02 1234-5678'.replaceAll('[^0-9]', ''));
List<String> campi = 'rosso, verde;blu'.split('[,;]\\s*');
System.debug(campi);
