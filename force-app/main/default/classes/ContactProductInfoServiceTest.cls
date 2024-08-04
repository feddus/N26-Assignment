@IsTest
private class ContactProductInfoServiceTest {
    @IsTest
    static void testGetProductInfo() {
        // Setup test data for Contact
        Contact testContact = new Contact(
            LastName = 'Doe',
            ExternalId__c = '12345',
            Product__c = 'Standard',
            Home_Country__c = 'DE'
        );
        insert testContact;

        // Mock the HTTP request and response
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = 'https://dummyendpoint.com/v1/ContactProductInfo/' + testContact.ExternalId__c;
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;

        // Invoke the method
        Test.startTest();
        ContactProductInfoService.getProductInfo();
        Test.stopTest();

        // Assert results
        Assert.areEqual(200, res.statusCode, 'Expected HTTP status code 200.');
        Assert.areNotEqual(null, JSON.deserializeUntyped(res.responseBody.toString()), 'Response body should not be null.');

        Map<String, Object> responseData = (Map<String, Object>) JSON.deserializeUntyped(res.responseBody.toString());
        Assert.areEqual('Standard', responseData.get('Product'), 'Expected Product to be Standard.');
        Assert.areEqual('DE', responseData.get('Home Country'), 'Expected Home Country to be DE.');
        Assert.areEqual(1.7, Double.valueOf(responseData.get('ATM Fee')), 'Expected ATM Fee to be 1.7%.');
        Assert.areEqual(6, Double.valueOf(responseData.get('Card Replacement Cost')), 'Expected Card Replacement Cost to be 6.');
        Assert.areEqual('EUR', responseData.get('Card Replacement Currency'), 'Expected Card Replacement Currency to be EUR.');
        Assert.areEqual(0, Double.valueOf(responseData.get('Product Cost')), 'Expected Product Cost to be 0.');
        Assert.areEqual('EUR', responseData.get('Product Currency'), 'Expected Product Currency to be EUR.');
    }
}
