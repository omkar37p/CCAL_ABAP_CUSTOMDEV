@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root Entity'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
    }
define root view entity ZGSTR_RE1
  as select from    I_JournalEntry            as JEH
    inner join      I_JournalEntryItem        as JEI  on  JEI.CompanyCode        =  JEH.CompanyCode
                                                      and JEI.FiscalYear         =  JEH.FiscalYear
                                                      and JEI.AccountingDocument =  JEH.AccountingDocument
                                                      and JEI.Ledger             =  '0L'
                                                      and JEI.LedgerGLLineItem   =  '000001'
                                                      and JEI.TaxCode            <> ''

    left outer join I_OperationalAcctgDocItem as ACC  on  ACC.AccountingDocument = JEI.AccountingDocument
                                                      and ACC.FiscalYear         = JEI.FiscalYear
                                                      and ACC.CompanyCode        = JEI.CompanyCode
                                                      and ACC.AccountingDocumentItem = ACC.AccountingDocumentItem
   //                                                      and ACC.ProfitCenter       <> ''
 //                                                      and ACC.TaxCode           = JEI.TaxCode

   left outer join I_OperationalAcctgDocItem as CGST on  CGST.AccountingDocument           = ACC.AccountingDocument
                                                      and CGST.AccountingDocumentItem       = ACC.AccountingDocumentItem
                                                      and CGST.FiscalYear                   = ACC.FiscalYear
                                                      and CGST.CompanyCode                  = ACC.CompanyCode
                                                      and CGST.TaxItemGroup                 = ACC.TaxItemGroup
                                                      and CGST.AccountingDocumentItemType   = 'T'
                                                      and CGST.TransactionTypeDetermination = 'JOC' 
               //                                       or CGST.TransactionTypeDetermination = 'JIC'
    left outer join I_OperationalAcctgDocItem as SGST on  SGST.AccountingDocument           = ACC.AccountingDocument
                                                      and SGST.AccountingDocumentItem       = ACC.AccountingDocumentItem
                                                      and SGST.FiscalYear                   = ACC.FiscalYear
                                                      and SGST.CompanyCode                  = ACC.CompanyCode
                                                      and SGST.TaxItemGroup                 = ACC.TaxItemGroup
                                                      and SGST.AccountingDocumentItemType   = 'T'
                                                      and SGST.TransactionTypeDetermination = 'JOS'  
                //                                      or SGST.TransactionTypeDetermination = 'JIS'                                                 
    left outer join I_OperationalAcctgDocItem as IGST on  IGST.AccountingDocument           = ACC.AccountingDocument
                                                     and IGST.AccountingDocumentItem       = ACC.AccountingDocumentItem
                                                      and IGST.FiscalYear                   = ACC.FiscalYear
                                                      and IGST.CompanyCode                  = ACC.CompanyCode
                                                      and IGST.TaxItemGroup                 = ACC.TaxItemGroup
                                                      and IGST.AccountingDocumentItemType   = 'T'
                                                      and IGST.TransactionTypeDetermination = 'JOI'
//                                                     or IGST.TransactionTypeDetermination = 'JII'// or JIM
//    //left outer join ztaxcodetb                as TAX  on TAX.taxcode = JEI.TaxCode
////left outer join I_BillingDocument as BD on BD ON
left outer join I_Customer                     as CUS    on CUS.Customer = JEI.Customer
left outer join I_BillingDocument as BDH on BDH.AccountingDocument =  JEI.AccountingDocument 
left outer join I_BillingDocumentItem as BDI on BDI.BillingDocument = BDH.BillingDocument
left outer join I_ProductPlantBasic as HSN on HSN.Product = BDI.Product
                                    and HSN.Plant = BDI.Plant   
left outer join I_GLAccountText as GLT on GLT.GLAccount = ACC.GLAccount and  GLT.Language = 'E'  
left outer join      I_BillingDocument          as BDC    on  BDC.BillingDocument     =  ACC.BillingDocument
                                             
    
   
    
    
    

{
  key ACC.CompanyCode,
  key ACC.FiscalYear,
  key ACC.AccountingDocument,
  key ACC.AccountingDocumentItem,
  key JEH.TaxReportingDate,
      //GLT.GLAccountName as ItemDescription,
     ACC.TaxCode,
      ACC.GLAccount,
      JEI.Material,
      JEI.Plant,
      JEH.DocumentDate,
      JEH.PostingDate,
     HSN.ConsumptionTaxCtrlCode as HSNCode,
      BDI.BillingDocumentItemText as ITEMDescription,
          BDI.BaseUnit as UOM,
          @Semantics.quantity.unitOfMeasure: 'UOM'
          @Aggregation.default: #SUM @Aggregation.exception: #LAST
          BDI.BillingQuantity  as QUANTITY,
      ////ACC.ProfitCenter,
      ACC.IN_GSTPlaceOfSupply as PlaceOfSupply1,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      ACC.AmountInTransactionCurrency,
      ACC.TransactionCurrency,
      JEH.AccountingDocumentType,
      
      JEH.DocumentReferenceID,
      JEH.AccountingDocumentHeaderText,
     //// JEH.IsReversal,
     //// JEH.IsReversed,
      ////TAX.taxtype,
      ////TAX.zprocedure,
      ////TAX.taxate,
      CGST.TransactionCurrency         as PriceUnit,
      SGST.TransactionCurrency         as CurrencyCode1,
      IGST.TransactionCurrency         as PriceUnit1,
      
      
      @Semantics.amount.currencyCode: 'PriceUnit'
      CGST.AmountInTransactionCurrency as cgstamount,
      
     @Semantics.amount.currencyCode: 'CurrencyCode1'
     SGST.AmountInTransactionCurrency as sgstamount,
      
     
      @Semantics.amount.currencyCode: 'PriceUnit1'
      IGST.AmountInTransactionCurrency as igstamount,
      
       BDC.Division                                                                                                                                              as Divisionb,
      //     BDI.ProfitCenter             as ProfitCenter,

      case when BDC.BillingDocumentType = 'F2' then 'Tax Invoice'
            when BDC.BillingDocumentType = 'G2' then 'CDNR'
      else null end                                                                                                                                             as BillingType,

      BDC.AccountingDocument                                                                                                                                    as Accdoc,
      BDC.OverallBillingStatus                                                                                                                                  as InStus,
      case BDC.BillingDocumentType when 'F2'
      then
      BDC.DocumentReferenceID  else null end                                                                                                                    as refdoc,
      //Bsc.YY1_ShippingBillNo_SD_BDH                                                                                                                             as ShippingBillNumber,
      //Bsc.YY1_ShippingBillDateSD_BDH                                                                                                                            as ShippingBillDate,
      //      abap.char' ' as supplytype,
      
      case 
          when BDH.DistributionChannel =  '10' and  CUS.TaxNumber3 = ''  then 'B2C'
          when BDH.DistributionChannel =  '10' and  CUS.TaxNumber3 <> ''  then 'B2B'
         when BDH.DistributionChannel = '20'then 'EXP'
          else null 
          end as SALESTYPE,
          
     
      
      
      
       case
          when ACC.IN_GSTPlaceOfSupply = 'AN' then '35' -- ANDAMAN AND NICOBAR ISLANDS
         when ACC.IN_GSTPlaceOfSupply = 'AP' then '37' -- ANDHRA PRADESH
          when ACC.IN_GSTPlaceOfSupply = 'AR' then '12' -- ARUNACHAL PRADESH
          when ACC.IN_GSTPlaceOfSupply = 'AS' then '18' -- ASSAM
          when ACC.IN_GSTPlaceOfSupply = 'BR' then '10' -- BIHAR
          when ACC.IN_GSTPlaceOfSupply = 'CG' then '22' -- CHHATTISGARH
       when ACC.IN_GSTPlaceOfSupply = 'CH' then '04' -- CHANDIGARH
          when ACC.IN_GSTPlaceOfSupply = 'DD' then '26' -- DADRA AND NAGAR HAVELI AND DAMAN AND DIU
          when ACC.IN_GSTPlaceOfSupply = 'DL' then '07' -- DELHI
          when ACC.IN_GSTPlaceOfSupply = 'DH' then '26' -- DADRA AND NAGAR HAVELI AND DAMAN AND DIU (DUPLICATE OF DD)
         when ACC.IN_GSTPlaceOfSupply = 'GA' then '30' -- GOA
          when ACC.IN_GSTPlaceOfSupply = 'GJ' then '24' -- GUJARAT
          when ACC.IN_GSTPlaceOfSupply = 'HP' then '02' -- HIMACHAL PRADESH
          when ACC.IN_GSTPlaceOfSupply = 'HR' then '06' -- HARYANA
          when ACC.IN_GSTPlaceOfSupply = 'JH' then '20' -- JHARKHAND
          when ACC.IN_GSTPlaceOfSupply = 'JK' then '01' -- JAMMU AND KASHMIR
          when ACC.IN_GSTPlaceOfSupply = 'KA' then '29' -- KARNATAKA
          when ACC.IN_GSTPlaceOfSupply = 'KL' then '32' -- KERALA
          when ACC.IN_GSTPlaceOfSupply = 'LA' then '38' -- LADAKH
          when ACC.IN_GSTPlaceOfSupply = 'LD' then '31' -- LAKSHADWEEP
          when ACC.IN_GSTPlaceOfSupply = 'MH' then '27' -- MAHARASHTRA
          when ACC.IN_GSTPlaceOfSupply = 'ML' then '17' -- MEGHALAYA
          when ACC.IN_GSTPlaceOfSupply = 'MN' then '14' -- MANIPUR
          when ACC.IN_GSTPlaceOfSupply = 'MP' then '23' -- MADHYA PRADESH
          when ACC.IN_GSTPlaceOfSupply = 'MZ' then '15' -- MIZORAM
          when ACC.IN_GSTPlaceOfSupply = 'NL' then '13' -- NAGALAND
          when ACC.IN_GSTPlaceOfSupply = 'OD' then '21' -- ODISHA
         when ACC.IN_GSTPlaceOfSupply = 'PB' then '03' -- PUNJAB
         when ACC.IN_GSTPlaceOfSupply = 'PY' then '34' -- PUDUCHERRY
          when ACC.IN_GSTPlaceOfSupply = 'RJ' then '08' -- RAJASTHAN
          when ACC.IN_GSTPlaceOfSupply = 'SK' then '11' -- SIKKIM
          when ACC.IN_GSTPlaceOfSupply = 'TS' then '36' -- TELANGANA
         when ACC.IN_GSTPlaceOfSupply = 'TN' then '33' -- TAMIL NADU
          when ACC.IN_GSTPlaceOfSupply = 'TR' then '16' -- TRIPURA
          when ACC.IN_GSTPlaceOfSupply = 'UK' then '05' -- UTTARAKHAND
          when ACC.IN_GSTPlaceOfSupply = 'UP' then '09' -- UTTAR PRADESH
           when ACC.IN_GSTPlaceOfSupply = 'WB' then '19' -- WEST BENGAL
      //    //when BDH.DistributionChannel = '20'then '97'
      else null
        end as PlaceOfSupply //placeofsupply (Statecode)
      
}
where
//    //-- Filter out INR with a 0 value in IGST
//  //  (IGST.TaxAmount <> 0 or IGST.TaxAmount is not null)
////
//    //-- Add other conditions for JEH (grouped correctly)
//    //and (
        JEH.AccountingDocumentType = 'DR' 
        or JEH.AccountingDocumentType = 'DG' 
        or JEH.AccountingDocumentType = 'RV' 
        or JEH.AccountingDocumentType = 'D1'
        or JEH.AccountingDocumentType = 'D2'
        or JEH.AccountingDocumentType = 'D3'
        or JEH.AccountingDocumentType = 'D4'
        or JEH.AccountingDocumentType = 'DZ'
       or JEH.AccountingDocumentType = 'DA'
       or JEH.AccountingDocumentType = '1Z';
       // //or JEH.AccountingDocumentType = '2Z'
       // //or JEH.AccountingDocumentType = '2Z';
       // //or JEH.IsReversal = '' 
       // //or JEH.IsReversed = ''
