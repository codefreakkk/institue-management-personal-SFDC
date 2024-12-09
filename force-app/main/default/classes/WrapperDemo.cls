public with sharing class WrapperDemo {
 
    @AuraEnabled(cacheable=true)
    public static AccountWrapper getRelatedRecords(Id accountId) {
        AccountWrapper wrapper = new AccountWrapper();
       
        wrapper.contacts = [SELECT Id, Name, Email FROM Contact WHERE AccountId = :accountId];
        wrapper.opportunities = [SELECT Id, Name, StageName FROM Opportunity WHERE AccountId = :accountId];
        wrapper.cases = [SELECT Id, CaseNumber, Status FROM Case WHERE AccountId = :accountId];
       
        return wrapper;
    }
 
    public class AccountWrapper {
        @AuraEnabled
        public List<Contact> contacts { get; set; }
        @AuraEnabled
        public List<Opportunity> opportunities { get; set; }
        @AuraEnabled
        public List<Case> cases { get; set; }
 
        public AccountWrapper() {
            this.contacts = new List<Contact>();
            this.opportunities = new List<Opportunity>();
            this.cases = new List<Case>();
        }
    }
}