public with sharing class CancellazioneProtetta {

    public static Boolean contatto(Id contatto) {
        List<UserRecordAccess> accessi = [
            SELECT RecordId, HasDeleteAccess
            FROM UserRecordAccess
            WHERE UserId = :UserInfo.getUserId()
                AND RecordId = :contatto];
        if (accessi.isEmpty()
                || !accessi[0].HasDeleteAccess) {
            return false;
        }
        delete as user new Contact(Id = contatto);
        return true;
    }
}
