trigger TrattativaTrigger on Opportunity (
        before insert, before update, before delete,
        after insert, after update, after delete,
        after undelete) {
    new GestoreTrattative().esegui();
}
