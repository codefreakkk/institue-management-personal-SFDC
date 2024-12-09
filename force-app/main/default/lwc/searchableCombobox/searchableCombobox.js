import { api, LightningElement, track } from 'lwc';
import TIMETABLE_OBJECT from "@salesforce/schema/Timetable__c";
import COURSE_FIELD from "@salesforce/schema/Timetable__c.Course__c";
import FACULTY_FIELD from "@salesforce/schema/Timetable__c.Faculties__c";
import SCHEDULED_DATE_FIELD from "@salesforce/schema/Timetable__c.Scheduled_Date__c";
import SUBJECT_TIMESLOT_FIELD from "@salesforce/schema/Timetable__c.Subject_Time_Slot__c";




export default class SearchableComboBox extends LightningElement {

    @api objectApiName = TIMETABLE_OBJECT;
    fields = [COURSE_FIELD, FACULTY_FIELD, SCHEDULED_DATE_FIELD, SUBJECT_TIMESLOT_FIELD];

    handleSubmit() {
        const event = CustomEvent('closemodal', {});
        this.dispatchEvent(event);
    }

    // @track searchTerm = '';
    // @track filteredOptions = [];
    
    // facultyOptions = [];
 
    // connectedCallback() {
    //     this.fetchFaculties();
    // }

    // async fetchFaculties() {
    //     try {
    //         const result = await getFaculties();
    //         console.log("Faculties", result);
    //         if (result) {
    //             this.facultyOptions = result.map(result => ({label: result.Name, value: result.Id}))
    //         }
    //     } catch(e) {
    //         console.log(e);
    //     }
    // }

    // // handlers
    // handleSearchChange(event) {
    //     this.searchTerm = event.target.value.toLowerCase();
 
    //     // Filter options
    //     this.filteredOptions = this.facultyOptions.filter(facultyOptions =>
    //         facultyOptions.label.toLowerCase().includes(this.searchTerm)
    //     );
    // }
 
    // handleOptionSelect(event) {
    //     const selectedValue = event.target.dataset.value;
    //     console.log(selectedValue);
    //     this.searchTerm = '';
    //     this.filteredOptions = [];
    // }
}