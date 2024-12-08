trigger EnrollmentTrigger on Enrollment__c (before insert, before update) {
	EnrollmentTriggerHandler enrollmentTriggerHandler = new EnrollmentTriggerHandler();
    
    if (Trigger.isInsert) {
        if (Trigger.isBefore) {
            enrollmentTriggerHandler.handleEnrollment(Trigger.New);
        }
    }
}