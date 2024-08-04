@RestResource(urlMapping='/v1/ContactProductInfo/*')
global with sharing class ContactProductInfoService {

    @HttpGet
    global static void getProductInfo() {
        RestRequest request = RestContext.request;
        String contactExternalId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        
        Contact contact = [
            SELECT Id, Product__c, Home_Country__c 
            FROM Contact 
            WHERE ExternalId__c = :contactExternalId
            LIMIT 1
        ];
        
        if (contact != null) {
            Map<String, Object> result = new Map<String, Object> {
                'Product' => contact.Product__c,
                'Home Country' => contact.Home_Country__c
            };

            // Retrieve ATM Fees
            ATMFee__mdt atmFee = [
                SELECT Fee__c 
                FROM ATMFee__mdt 
                WHERE Product__c = :contact.Product__c AND Country__c = :contact.Home_Country__c
                LIMIT 1
            ];
            if (atmFee != null) {
               result.put('ATM Fee', atmFee.Fee__c);
            }
            // Retrieve Card Replacement Costs
            CardReplacementCost__mdt cardReplacementCost = [
                SELECT Cost__c, Currency__c 
                FROM CardReplacementCost__mdt 
                WHERE Product__c = :contact.Product__c AND Country__c = :contact.Home_Country__c
                LIMIT 1
            ];
            if (cardReplacementCost != null) {
                result.put('Card Replacement Cost', cardReplacementCost.Cost__c);
                result.put('Card Replacement Currency', cardReplacementCost.Currency__c);
            }

            // Retrieve Product Costs
            ProductCost__mdt productCost = [
                SELECT Cost__c, Currency__c 
                FROM ProductCost__mdt 
                WHERE Product__c = :contact.Product__c AND Country__c = :contact.Home_Country__c
                LIMIT 1
            ];
            if (productCost != null) {
                result.put('Product Cost', productCost.Cost__c);
                result.put('Product Currency', productCost.Currency__c);
            }

            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(result));
            RestContext.response.statusCode = 200;
        } else {
            RestContext.response.responseBody = Blob.valueOf('Contact not found');
            RestContext.response.statusCode = 404;
        }
    }
}
