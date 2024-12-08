trigger TimetableTrigger on Timetable__c (before insert, before update) {
	TimetableTriggerHandler timetableTriggerHandler = new TimetableTriggerHandler();
    
    if (Trigger.isInsert) {
        if (Trigger.isBefore) {
            // handle duplicate timetable
			timetableTriggerHandler.handleTimetableBeforeInsert(Trigger.New);  
            
            // handle subjects for the course in timetable
            timetableTriggerHandler.handleSubjectsForCourse(Trigger.New);
        }
    } 
    
    if (Trigger.isUpdate) {
        if (Trigger.isBefore) {
                 // handle duplicate timetable
			timetableTriggerHandler.handleTimetableBeforeInsert(Trigger.New);
            
            // handle valid subject for course while setting 
            timetableTriggerHandler.handleSubjectsForCourse(Trigger.New);
        }
    }

}