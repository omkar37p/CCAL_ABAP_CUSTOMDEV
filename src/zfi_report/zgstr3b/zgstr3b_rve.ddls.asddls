@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root Entity View for GSTR3B'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZGSTR3B_RVE as select from ZGSTR_3B_VIEW
{
    key CompanyCode,
    key FiscalYear,
    key AccountingDocument,
    key SourceLedger,
    key LedgerGLLineItem,
    key Ledger,
    DocumentReferenceID,
    DocumentDate,
    AccountingDocumentType,
    ProfitCenter,
    TransactionTypeDetermination,
    FiscalPeriod,
    GLAccount,
    BusinessPlace,
    buyergstin,
    Supplier,
    suppliergstin,
    suppliername,
    invoicestatus,
    supplytype,
    invoiceno,
    invoicedate,
    TaxCode,
    invoicetype,
    notenumber,
//    notedate,
    hsn_sac,
    uom,
    itemdescription,
    GST_Rate,
    itceligibility,
    eligibilitycategory,
    reversecharge,
    importtype,
    gstr2returnperiod,
    b3auto_fillperiod,
    PostingDate,
    CCURR,
    TaxItemGroup,
    TaxableValue,
    IGSTAmount,
    CGSTAmount,
    SGSTAmount,
//    notevalue,
          @Semantics.amount.currencyCode: 'Ccurr'     
    cessamount,
    ReversalReferenceDocument,
    case
        when AccountingDocumentType = 'RE' and (TaxCode = '40' or TaxCode = '4A' or TaxCode = '4B' or TaxCode = '4C' or
                                                TaxCode = '4D' or TaxCode = '4E' or TaxCode = '4F' or TaxCode = '4G' or
                                                TaxCode = '4H' or TaxCode = '4I' ) then TaxableValue

        when TaxableValue is not initial and IGSTAmount is not initial then(TaxableValue + IGSTAmount)
        when TaxableValue is not initial and CGSTAmount is not initial then(TaxableValue + CGSTAmount + SGSTAmount)
                                                
        when TaxableValue is not initial then TaxableValue
        else null end as InvoiceValue
}
