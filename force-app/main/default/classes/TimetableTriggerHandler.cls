public class TimetableTriggerHandler {
    public void handleTimetableBeforeInsert(List<Timetable__c> timetableList) {
        Map<Id, Timetable__c> timetableWithCourseId = new Map<Id, Timetable__c>();
        Map<Id, Timetable__c> timetableWithFactultyId = new Map<Id, Timetable__c>();
        List<Date> scheduledDate = new List<Date>();
        List<String> timeSlotList = new List<String>();
        
        for (Timetable__c timetable : timetableList) {
            timetableWithCourseId.put(timetable.Course__c, timetable);
			timetableWithFactultyId.put(timetable.Faculties__c, timetable);
        	scheduledDate.add(timetable.Scheduled_Date__c);
        	timeSlotList.add(timetable.Subject_Time_Slot__c);
        }
        
        // check if faculty is already assined to this timetable
        for (Timetable__c timetable : [SELECT Id, Course__c FROM Timetable__c WHERE Course__c IN :timetableWithCourseId.keySet()
                                   		AND Scheduled_Date__c IN :scheduledDate 
                                    	AND Subject_Time_Slot__c IN :timeSlotList]) 
        {
            timetableWithCourseId.get(timetable.Course__c).addError('Timetable for this course is already set');
        }
        
        // check if faculty is been allocated to other course with same time
        for (Timetable__c timetable : [SELECT Id, Faculties__c FROM Timetable__c WHERE Faculties__c IN :timetableWithFactultyId.keySet()
                                   		AND Scheduled_Date__c IN :scheduledDate 
                                    	AND Subject_Time_Slot__c IN :timeSlotList]) 
        {
            timetableWithFactultyId.get(timetable.Faculties__c).addError('Timetable for this faculty is already set');
        }        
    }
    
    public void handleSubjectsForCourse(List<Timetable__c> timetableList) {
        List<Id> timetableWithCourseId = new List<Id>();
        List<Id> timetableWithFacultyId = new List<Id>();
        
        for (Timetable__c timetable : timetableList) {
            timetableWithCourseId.add(timetable.Course__c);
            timetableWithFacultyId.add(timetable.Faculties__c);
        }
        
        Map<Id, String> subjectWithFacultyId = new Map<Id, String>();
        for (Faculties__c faculty : [SELECT Id, Subject__c FROM Faculties__c WHERE Id IN :timetableWithFacultyId]) {
            subjectWithFacultyId.put(faculty.Id, faculty.Subject__c);
        }

        System.debug('subjectWithFacultyId : ' + subjectWithFacultyId);
        
        Map<Id, Set<Id>> subjectsWithCourseId = new Map<Id, Set<Id>>();
        for (Subject_Course__c subject : [SELECT Course__c, Subject__c FROM Subject_Course__c WHERE Course__c IN :timetableWithCourseId]) {
            if (subjectsWithCourseId.containsKey(subject.Course__c) && subjectsWithCourseId.get(subject.Course__c) != null) {
                subjectsWithCourseId.get(subject.Course__c).add(subject.Subject__c);
            } 
            else {
                subjectsWithCourseId.put(subject.Course__c, new Set<Id>{subject.Subject__c});
            }
        }
        
        System.debug('subjectsWithCourseId : ' + subjectsWithCourseId);
        
        for (Timetable__c timetable : timetableList) {
            String subjectId = subjectWithFacultyId.get(timetable.Faculties__c);
            if (!subjectsWithCourseId.containsKey(timetable.Course__c) || !subjectsWithCourseId.get(timetable.Course__c).contains(subjectId)) {
                timetable.addError('Subject is not listed in course');
            }
        }
    }
}