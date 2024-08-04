public with sharing class ProductInfoService {

    @AuraEnabled(cacheable=true)
    public static Map<String, Object> getProductInformation(String product, String country) {
        Map<String, Object> productInfo = new Map<String, Object>();
        
        // Fetch product cost
        List<ProductCost__mdt> productCosts = [
            SELECT Cost__c, Currency__c 
            FROM ProductCost__mdt 
            WHERE Product__c = :product AND Country__c = :country 
            LIMIT 1
        ];
        if (!productCosts.isEmpty()) {
            productInfo.put('ProductCost', productCosts[0].Cost__c);
            productInfo.put('ProductCostCurrency', productCosts[0].Currency__c);
        }
        
        // Fetch ATM fee
        List<ATMFee__mdt> atmFees = [
            SELECT Fee__c 
            FROM ATMFee__mdt 
            WHERE Product__c = :product AND Country__c = :country 
            LIMIT 1
        ];
        if (!atmFees.isEmpty()) {
            productInfo.put('ATMFee', atmFees[0].Fee__c);
        }
        
        // Fetch card replacement cost
        List<CardReplacementCost__mdt> replacementCosts = [
            SELECT Cost__c, Currency__c 
            FROM CardReplacementCost__mdt 
            WHERE Product__c = :product AND Country__c = :country 
            LIMIT 1
        ];
        if (!replacementCosts.isEmpty()) {
            productInfo.put('CardReplacementCost', replacementCosts[0].Cost__c);
            productInfo.put('CardReplacementCostCurrency', replacementCosts[0].Currency__c);
        }
        
        return productInfo;
    }
    
}