@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'DSC - Domestic Invoices Value Help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_BILLDOC_VH
  as select from I_BillingDocumentBasic
{
  key BillingDocument,
      BillingDocumentType,
      CreatedByUser,
      CreationDate,
      SalesOrganization,
      DistributionChannel,
      Division,
      BillingDocumentDate,
      BillingDocumentIsCancelled,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      TotalNetAmount,
      TransactionCurrency,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      TotalTaxAmount,
      PayerParty,
      CustomerPaymentTerms,
      CompanyCode,
      AccountingDocument,
      SoldToParty,
      PurchaseOrderByCustomer,
      Country,
      Region,
      YY1_BILL_PAN_BDH,
      YY1_SD_PONO_BDH,
      YY1_Place_BDH,
      YY1_Division_BDH,
      //      YY1_CustRefDate_BDH,
      YY1_Branch_BDH
}
where
     BillingDocumentType = 'F2'
  or BillingDocumentType = 'G2'
  or BillingDocumentType = 'L2'
//  and DistributionChannel =  '10'
//  and Division            <> '08'
//  and Division            <> '10'
//  and Division            <> '11'
//  and Division            <> '12'
//  and Division            <> '13'
