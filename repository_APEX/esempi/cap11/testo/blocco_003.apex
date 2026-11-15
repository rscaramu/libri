try {
    List<Integer> vuota = new List<Integer>();
    Integer primo = vuota[0];
} catch (ListException e) {
    System.debug(e.getTypeName());
    System.debug(e.getMessage());
    System.debug(e.getLineNumber());
}
