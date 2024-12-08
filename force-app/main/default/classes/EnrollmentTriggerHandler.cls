public class EnrollmentTriggerHandler {

    public void handleEnrollment(List<Enrollment__c> enrollmentList) {
        Map<Id, Enrollment__c> enrollmentsByStudentId = new Map<Id, Enrollment__c>();
        Map<Id, Enrollment__c> enrollmentsByCourseId = new Map<Id, Enrollment__c>();
        
        for (Enrollment__c enrollment : enrollmentList) {
            enrollmentsByStudentId.put(enrollment.Student__c, enrollment);
            enrollmentsByCourseId.put(enrollment.Course__c, enrollment);
        }
        
        // check if course is finished already
        for (Course__c course : [SELECT Id, End_Date__c FROM Course__c WHERE Id IN: enrollmentsByCourseId.keySet()]) {
            if (enrollmentsByCourseId.containsKey(course.Id) && course.End_Date__c < System.today()) {
                enrollmentsByCourseId.get(course.Id).addError('Course has been completed');
            }
        }
        
        for (Enrollment__c enrollment : [SELECT Student__r.Id, Course__r.Id, Course__r.End_Date__c FROM Enrollment__c WHERE Student__c IN :enrollmentsByStudentId.keySet()]) {                    
            if (enrollmentsByStudentId.containsKey(enrollment.Student__r.Id)) {
                
                // check for same course
                if (enrollmentsByStudentId.get(enrollment.Student__r.Id).Course__c == enrollment.Course__r.Id) {
                    enrollmentsByStudentId.get(enrollment.Student__r.Id).addError('Student already enrolled in this course');
                }
                
                // check if student is already enrolled in other course and that course is not finished
                if (enrollmentsByStudentId.get(enrollment.Student__r.Id).Course__c != enrollment.Course__r.Id && enrollment.Course__r.End_Date__c >= System.today()) {
					enrollmentsByStudentId.get(enrollment.Student__r.Id).addError('Student already enrolled in other course');     
				}
            }
        }
    }
}