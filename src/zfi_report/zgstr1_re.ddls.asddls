@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root Entity'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
    }
define root view entity ZGSTR1_RE
  as select from    I_JournalEntry            as JEH
    inner join      I_JournalEntryItem        as JEI  on  JEI.CompanyCode        =  JEH.CompanyCode
                                                      and JEI.FiscalYear         =  JEH.FiscalYear
                                                      and JEI.AccountingDocument =  JEH.AccountingDocument
                                                      and JEI.Ledger             =  '0L'
                                                      and JEI.LedgerGLLineItem   =  '000001'
//                                                      and JEI.TaxCode            <> ''

    left outer join I_OperationalAcctgDocItem as ACC  on  ACC.AccountingDocument = JEI.AccountingDocument
                                                      and ACC.FiscalYear         = JEI.FiscalYear
                                                      and ACC.CompanyCode        = JEI.CompanyCode
  //                                                      and ACC.ProfitCenter       <> ''
//                                                      and ACC.TaxCode           = JEI.TaxCode

    left outer join I_OperationalAcctgDocItem as CGST on  CGST.AccountingDocument           = ACC.AccountingDocument
                                                      and CGST.AccountingDocumentItem       = ACC.AccountingDocumentItem
                                                      and CGST.FiscalYear                   = ACC.FiscalYear
                                                      and CGST.CompanyCode                  = ACC.CompanyCode
                                                      and CGST.TaxItemGroup                 = ACC.TaxItemGroup
                                                      and CGST.AccountingDocumentItemType   = 'T'
                                                      and CGST.TransactionTypeDetermination = 'JOC' 
//                                                      or CGST.TransactionTypeDetermination = 'JIC'
    left outer join I_OperationalAcctgDocItem as SGST on  SGST.AccountingDocument           = ACC.AccountingDocument
                                                      and SGST.AccountingDocumentItem       = ACC.AccountingDocumentItem
                                                      and SGST.FiscalYear                   = ACC.FiscalYear
                                                      and SGST.CompanyCode                  = ACC.CompanyCode
                                                      and SGST.TaxItemGroup                 = ACC.TaxItemGroup
                                                      and SGST.AccountingDocumentItemType   = 'T'
                                                      and SGST.TransactionTypeDetermination = 'JOS'  
//                                                      or SGST.TransactionTypeDetermination = 'JIS'                                                 
    left outer join I_OperationalAcctgDocItem as IGST on  IGST.AccountingDocument           = ACC.AccountingDocument
                                                      and IGST.AccountingDocumentItem       = ACC.AccountingDocumentItem
                                                      and IGST.FiscalYear                   = ACC.FiscalYear
                                                      and IGST.CompanyCode                  = ACC.CompanyCode
                                                      and IGST.TaxItemGroup                 = ACC.TaxItemGroup
                                                      and IGST.AccountingDocumentItemType   = 'T'
                                                      and IGST.TransactionTypeDetermination = 'JOI'
//                                                      or IGST.TransactionTypeDetermination = 'JII'// or JIM
//    left outer join ztaxcodetb                as TAX  on TAX.taxcode = JEI.TaxCode
    
   
    
    
    

{
  key ACC.CompanyCode,
  key ACC.FiscalYear,
  key ACC.AccountingDocument,
  key ACC.AccountingDocumentItem,
      ACC.TaxCode,
      ACC.GLAccount,
      JEI.Material,
      JEI.Plant,
      ACC.ProfitCenter,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      ACC.AmountInTransactionCurrency,
      ACC.TransactionCurrency,
      JEH.AccountingDocumentType,
      JEH.DocumentDate,
      JEH.PostingDate,
      JEH.TaxReportingDate,
      JEH.DocumentReferenceID,
      JEH.AccountingDocumentHeaderText,
      JEH.IsReversal,
      JEH.IsReversed,
      //TAX.taxtype,
      //TAX.zprocedure,
      //TAX.taxate,
      CGST.TransactionCurrency         as PriceUnit,
      SGST.TransactionCurrency         as CurrencyCode1,
      IGST.TransactionCurrency         as PriceUnit1,
      
      @Semantics.amount.currencyCode: 'PriceUnit'
      CGST.AmountInTransactionCurrency as cgstamount,
      
     @Semantics.amount.currencyCode: 'CurrencyCode1'
     SGST.AmountInTransactionCurrency as sgstamount,
      
     
      @Semantics.amount.currencyCode: 'PriceUnit1'
      IGST.AmountInTransactionCurrency as igstamount
      
}
where
//    -- Filter out INR with a 0 value in IGST
//    (IGST.TaxAmount <> 0 or IGST.TaxAmount is not null)
//
//    -- Add other conditions for JEH (grouped correctly)
//    and (
        JEH.AccountingDocumentType = 'DR' 
        or JEH.AccountingDocumentType = 'DG' 
        or JEH.AccountingDocumentType = 'RV' 
        or JEH.AccountingDocumentType = 'D1'
        or JEH.AccountingDocumentType = 'D2'
        or JEH.AccountingDocumentType = 'D3'
        or JEH.AccountingDocumentType = 'D4'
        or JEH.AccountingDocumentType = 'DZ'
        or JEH.AccountingDocumentType = 'DA'
        or JEH.AccountingDocumentType = '1Z'
        or JEH.AccountingDocumentType = '2Z'
        or JEH.AccountingDocumentType = '2Z'
        or JEH.IsReversal = '' 
        or JEH.IsReversed = ''
