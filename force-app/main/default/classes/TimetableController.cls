public class TimetableController {

    @AuraEnabled
    public static List<Timetable__c> getTimetableRecord(String scheduledDate, String slot, String subject) {
        try {
            if (scheduledDate == null && slot == null && subject == null) {
                return [SELECT Id, Subject_Name__c, Faculties__r.Name, Subject_Time_Slot__c, Scheduled_Date__c FROM Timetable__c];
            } else {
                String query = 'SELECT Id, Subject_Name__c, Faculties__r.Name, Subject_Time_Slot__c, Scheduled_Date__c FROM Timetable__c';
                query += ' WHERE';

                boolean flag = false;
                if (scheduledDate != null && scheduledDate.length() > 0) {
                    if (flag) {
                        query += ' AND';
                    }
                    query += ' Scheduled_Date__c = ' + scheduledDate;
                    flag = true;
                } 
                if (slot != null && slot.length() > 0) {
                    if (flag) {
                        query += ' AND';
                    }
                    query += ' Subject_Time_Slot__c = ' + '\'' + slot + '\'';
                    flag = true;
                } 
                if (subject != null && subject.length() > 0) {
                    if (flag) {
                        query += ' AND';
                    }
                    query += ' Faculties__r.Subject__c = ' + '\''+ subject + '\'';
                }

                List<Timetable__c> timetableList =  Database.query(query);
                return timetableList;
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void deleteTimetableRecord(Id timetableId) {
        try {
            List<Timetable__c> timetableList = [SELECT Id FROM Timetable__c WHERE Id = :timetableId];
            if (timetableList != null && timetableList.size() > 0) {
                delete timetableList;
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}