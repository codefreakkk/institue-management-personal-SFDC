public class FacultyController {
    @AuraEnabled
    public static List<Faculties__c> getFaculties(){
        try {
            return [SELECT Id, Name FROM Faculties__c];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}