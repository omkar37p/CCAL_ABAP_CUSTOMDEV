@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'TEST'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Z_TEST as select from I_JournalEntryItem

{

    key CompanyCode,
    key AccountingDocument,
    key FiscalYear as Fiscal_Year,
    key SourceLedger,
    key Ledger,
    key LedgerGLLineItem,
//    key AccountingDocumentItem,
        PostingDate,
        BaseUnit,
        DebitCreditCode,
        FiscalPeriod as Fiscal_Period,
//     substring( PostingDate, 1, 4 ) as Fiscal_Year,
        Product,
        GLAccount,
        TransactionCurrency,
 
        case
        
             /* Other Income    */
             
           when GLAccount = '0000400004'
             or GLAccount = '0000410300'
             or GLAccount = '0000410501'
             or GLAccount = '0000410000'
             or GLAccount = '0000410003'
             or GLAccount = '0000410100'
             or GLAccount = '0000410101'
             or GLAccount = '0000410102'
             or GLAccount = '0000410105'
             or GLAccount = '0000410200'
             or GLAccount = '0000410201'
             or GLAccount = '0000410202'
             or GLAccount = '0000410401'
             or GLAccount = '0000606003'
             or GLAccount = '0000651000'
             
           then cast( AmountInCompanyCodeCurrency as abap.dec( 15, 2 ) )
         else cast( 0 as abap.dec( 15, 2 ) )
         end as OTHER_INCOME
             
//              then
//        case
//            when DebitCreditCode = 'S'
//                then cast( AmountInCompanyCodeCurrency as abap.dec( 15, 2 ) )
//            when DebitCreditCode = 'H'
//                then cast( AmountInCompanyCodeCurrency * -1 as abap.dec( 15, 2 ) )
//            else
//                cast( 0 as abap.dec( 15, 2 ) )
//        end
//    else
//        cast( 0 as abap.dec( 15, 2 ) )
//end as OTHER_INCOME
}

where Ledger = '0L'
