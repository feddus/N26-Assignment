@IsTest
private class ProductInfoServiceTest {
    @IsTest
    static void testGetProductInformation() {

        Test.startTest();
        // Call the method
        Map<String, Object> productInfo = ProductInfoService.getProductInformation('Standard', 'DE');
        Test.stopTest();

        // Verify the results
        Assert.areEqual(0, (Decimal)productInfo.get('ProductCost'), 'The product cost should be 0.');
        Assert.areEqual('EUR', (String)productInfo.get('ProductCostCurrency'), 'The currency for product cost should be EUR.');
        Assert.areEqual(1.70, (Decimal)productInfo.get('ATMFee'), 'The ATM fee should be 1.70.');
        Assert.areEqual(6, (Decimal)productInfo.get('CardReplacementCost'), 'The card replacement cost should be 6.');
        Assert.areEqual('EUR', (String)productInfo.get('CardReplacementCostCurrency'), 'The currency for card replacement cost should be EUR.');
    }
}
