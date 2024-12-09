public class SubjectsController {
    @AuraEnabled
    public static List<Subjects__c> getSubjectRecord() {
        try {
            return [SELECT Id, Name FROM Subjects__c];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}