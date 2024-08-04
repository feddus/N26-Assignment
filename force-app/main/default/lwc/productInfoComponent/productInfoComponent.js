import { LightningElement, api, wire, track } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import getProductInformation from '@salesforce/apex/ProductInfoService.getProductInformation';

// Define fields to fetch
const CASE_FIELDS = ['Case.ContactId'];
const CONTACT_FIELDS = ['Contact.Product__c', 'Contact.Home_Country__c'];

export default class ProductInfoComponent extends LightningElement {
    @api recordId; // Case Record Id
    @track contactData;
    @track productInfo;

    // Wire the getRecord to fetch Case record
    @wire(getRecord, { recordId: '$recordId', fields: CASE_FIELDS })
    caseRecord({ error, data }) {
        if (data) {
            // Retrieve the Contact ID from Case data
            const contactId = data.fields.ContactId.value;
            // Trigger the reactive wire for Contact data
            this.contactId = contactId;
        } else if (error) {
            console.error('Error retrieving case record:', error);
        }
    }

    // Reactive wire to fetch Contact data based on contactId
    @wire(getRecord, { recordId: '$contactId', fields: CONTACT_FIELDS })
    contactRecord({ error, data }) {
        if (data) {
            this.contactData = data.fields;
            this.fetchProductInfo();
        } else if (error) {
            console.error('Error retrieving contact data:', error);
        }
    }

    // Fetch product information based on Contact fields
    fetchProductInfo() {
        if (this.contactData) {
            const product = this.contactData.Product__c.value;
            const country = this.contactData.Home_Country__c.value;
            getProductInformation({ product, country })
                .then(result => {
                    this.productInfo = result;
                })
                .catch(error => {
                    console.error('Error fetching product information:', error);
                });
        }
    }
}