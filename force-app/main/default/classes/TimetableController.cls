public class TimetableController {

    @AuraEnabled
    public static List<Timetable__c> getTimetableRecord() {
        try {
            return [SELECT Id, Subject_Name__c, Faculties__r.Name, Subject_Time_Slot__c, Scheduled_Date__c FROM Timetable__c];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}