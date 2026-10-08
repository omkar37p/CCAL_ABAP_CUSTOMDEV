@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'FI GSTR 3B Report View'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZGSTR_3B_VIEW as select from I_JournalEntry as JEH
inner join I_JournalEntryItem as JEI on JEI.AccountingDocument = JEH.AccountingDocument
                                        and JEI.CompanyCode = JEH.CompanyCode
                                        and JEI.FiscalYear = JEH.FiscalYear
                                        and JEI.Ledger = '0L'
                                        and JEI.TaxCode is not initial
                                        and ( ( JEH.AccountingDocumentType = 'RE' and ( JEI.TransactionTypeDetermination = 'WRX' or JEI.TransactionTypeDetermination = 'FR1'
                                                                                        or JEI.TransactionTypeDetermination = 'FR3' ) ) or 
                                              ( JEH.AccountingDocumentType = 'KR' and ( JEI.TransactionTypeDetermination = 'KBS' or JEI.TransactionTypeDetermination is initial ) ) or
                                              ( JEH.AccountingDocumentType = 'KG' and ( JEI.TransactionTypeDetermination = 'KBS' or JEI.TransactionTypeDetermination is initial 
                                                                                        or JEI.TransactionTypeDetermination = 'BSX' ) ) )
//                                              ( JEH.AccountingDocumentType = 'KZ' and ( JEI.TransactionTypeDetermination is initial ) ) or
//                                              ( JEH.AccountingDocumentType = 'KA' and ( JEI.TransactionTypeDetermination is initial ) ) )
inner join I_OperationalAcctgDocItem as joi on joi.AccountingDocument = JEI.AccountingDocument
                                        and joi.AccountingDocumentItem = JEI.AccountingDocumentItem
                                        and joi.CompanyCode = JEI.CompanyCode
                                        and joi.FiscalYear = JEI.FiscalYear 

left outer join I_Supplier as SUP on SUP.Supplier = JEI.Supplier      

left outer join I_Supplier as SUP2 on SUP2.Supplier = JEI.OffsettingAccount                  
left outer join I_ProductText as PRT on PRT.Product = JEI.Product and PRT.Language = $session.system_language
left outer join I_GLAccountText as GLT on GLT.GLAccount = JEI.GLAccount and  GLT.Language = $session.system_language
left outer join I_PurchaseOrderItemAPI01 as POI on POI.PurchaseOrder =  JEI.PurchasingDocument
                                               and POI.PurchaseOrderItem = JEI.PurchasingDocumentItem
left outer join I_PurchaseOrderAPI01 as POH on POH.PurchaseOrder = POI.PurchaseOrder 

left outer join I_OperationalAcctgDocItem as IGST on IGST.AccountingDocument = joi.AccountingDocument
                                               and IGST.FiscalYear = joi.FiscalYear 
                                               and IGST.CompanyCode = joi.CompanyCode
                                               and IGST.TaxItemGroup = joi.TaxItemGroup
                                               and ( IGST.TransactionTypeDetermination = 'JII' or IGST.TransactionTypeDetermination = 'JIN' 
                                                    or IGST.TransactionTypeDetermination = 'JIM')    
left outer join I_OperationalAcctgDocItem as CGST on CGST.AccountingDocument = joi.AccountingDocument
                                               and CGST.FiscalYear = joi.FiscalYear 
                                               and CGST.CompanyCode = joi.CompanyCode
                                               and CGST.TaxItemGroup = joi.TaxItemGroup
                                               and ( CGST.TransactionTypeDetermination = 'JIC' or CGST.TransactionTypeDetermination = 'JCN')
left outer join I_OperationalAcctgDocItem as SGST on SGST.AccountingDocument = joi.AccountingDocument
                                               and SGST.FiscalYear = joi.FiscalYear 
                                               and SGST.CompanyCode = joi.CompanyCode
                                               and SGST.TaxItemGroup = joi.TaxItemGroup
                                               and ( SGST.TransactionTypeDetermination = 'JIS' or SGST.TransactionTypeDetermination = 'JSN')                                                                                           
{
    key JEH.CompanyCode,
    key JEH.FiscalYear,
    key JEH.AccountingDocument,
    key JEI.SourceLedger,
    key JEI.LedgerGLLineItem,
    key JEI.Ledger,
        JEH.DocumentReferenceID,
        JEH.DocumentDate,
        JEH.AccountingDocumentType,
        JEI.ProfitCenter,
        JEI.TransactionTypeDetermination,
        JEI.GLAccount,
        joi.BusinessPlace as BusinessPlace,
        JEI.FiscalPeriod,
         case
         when joi.BusinessPlace = '1100' then '34AADCT1820F1ZT'
         when  joi.BusinessPlace = '1200' then '33AADCT1820F3ZT'
         when  joi.BusinessPlace = '1500' then '33AADCT1820F4ZS' 
         when  joi.BusinessPlace = '3100' then '37AADCT1820F1ZN'
         when  joi.BusinessPlace = '2100' then '34AAICC5330L1ZN' 
        else null    //GST HOLD DOCUMENT 
            end as buyergstin,
//         JEI.Supplier,
         case
                when JEI.Supplier is not initial then JEI.Supplier
                when SUP2.Supplier is not initial then SUP2.Supplier
                else null end as Supplier,
          case 
                when JEI.Supplier is not initial then SUP.TaxNumber3 
                when JEI.Supplier is initial then SUP2.TaxNumber3 
                else null end as suppliergstin,
          case 
                when JEI.Supplier is not initial then SUP.SupplierName
                when JEI.Supplier is initial then SUP2.SupplierName 
                else null end as suppliername,
          abap.string'New' as invoicestatus,
          abap.string'B2B' as supplytype,
          JEH.DocumentReferenceID as invoiceno,
          JEH.DocumentDate as invoicedate,
          JEI.TaxCode as TaxCode,
          case JEI.TaxCode
          when '1A' then 'Exempt' 
          when '1H' then 'Exempt' 
          when '1I' then 'Exempt'  
          when '1O' then 'Capital Goods'
          when '1P' then 'Capital Goods'
          when '1Q' then 'Capital Goods'
          when '1R' then 'Capital Goods'      
          when '1S' then 'Tax invoice Not Eligible'
          when '1W' then 'Tax invoice Not Eligible'
          when '1T' then 'Tax invoice Not Eligible'
          when '1U' then 'Tax invoice Not Eligible'
          when '1X' then 'Tax invoice Not Eligible'
          when '1V' then 'Tax invoice Not Eligible'           
          when '5A' then 'Import'
          when '5B' then 'Import'
          when '5C' then 'Import'
          when '5D' then 'Import'     
          when '5E' then 'import capital goods'
          when '5F' then 'import capital goods'
          when '3A' then 'RCM'
          when '3B' then 'RCM'
          when '3C' then 'RCM'
          when '3D' then 'RCM'        
          else 'Tax invoice' 
          end as invoicetype,
          abap.string' ' as notenumber, 
          abap.string' ' as notedate,
          joi.IN_HSNOrSACCode  as hsn_sac,
          JEI.BaseUnit as uom,                    
          case
          when PRT.ProductName is not initial
          then PRT.ProductName
          else GLT.GLAccountName end as itemdescription,

        case JEI.TaxCode
          when '10' then '0.00'
          when '1A' then '5.00'
          when '1B' then '12.00'
          when '1C' then '18.00'
          when '1D' then '28.00'
          when '1E' then '0.00'
          when '1F' then '5.00'
          when '1G' then '12.00'
          when '1H' then '18.00'
          when '1I' then '28.00'
          
          when '20' then '0.00'
          when '2A' then '5.00'
          when '2B' then '12.00'
          when '2C' then '18.00'
          when '2D' then '28.00'
          when '2E' then '0.00'
          when '2F' then '5.00'
          when '2G' then '12.00'
          when '2H' then '18.00'
          when '2I' then '28.00'
          
          when '30' then '0.00'
          when '3A' then '5.00'
          when '3B' then '12.00'
          when '3C' then '18.00'
          when '3D' then '28.00'
          when '3E' then '0.00'
          when '3F' then '5.00'
          when '3G' then '12.00'
          when '3H' then '18.00'
          when '3I' then '28.00'
          
          when '40' then '0.00'
          when '4A' then '5.00'
          when '4B' then '12.00'
          when '4C' then '18.00'
          when '4D' then '28.00'
          when '4E' then '0.00'
          when '4F' then '5.00'
          when '4G' then '12.00'
          when '4H' then '18.00'
          when '4I' then '28.00'
          
          when '5A' then '18.00'
          when '5B' then '10.00'
          when '5C' then '12.00'
          when '5D' then '28.00'

          when '60' then '0.00' 
          when '6A' then '5.00'
          when '6B' then '12.00'
          when '6C' then '18.00'
          when '6D' then '28.00'
          when '6E' then '0.00'
          when '6F' then '5.00'
          when '6G' then '12.00'
          when '6H' then '18.00'
          when '6I' then '28.00'
                    
          else null end as GST_Rate,
          case 
          when JEI.TaxCode = '1S' then 'N'
          when JEI.TaxCode = '1W' then 'N'
          when JEI.TaxCode = '1T' then 'N'
          when JEI.TaxCode = '1U' then 'N'
          when JEI.TaxCode = '1X' then 'N'
          when JEI.TaxCode = '1V' then 'N'
          when substring(JEI.TaxCode, 1, 1) = '2' then 'N'
          when substring(JEI.TaxCode, 1, 1) = '4' then 'N'
          when substring(JEI.TaxCode, 1, 1) = '6' then 'N'          
          else 'Y' 
          end as itceligibility,                   
          case 
          when POH.PurchaseOrderType = 'ZCGP' then 'Capital Goods'
          when POH.PurchaseOrderType = 'ZSER' or substring(joi.IN_HSNOrSACCode, 1, 2) = '99' then 'Input Services'
          else 'Input Goods' 
          end as eligibilitycategory,
          case 
          when JEI.TaxCode = '3A' then 'Y'
          when JEI.TaxCode = '3B' then 'Y'
          when JEI.TaxCode = '3C' then 'Y'
          when JEI.TaxCode = '3D' then 'Y' 
          when substring(JEI.TaxCode, 1, 1) = '4' then 'Y'
          when substring(JEI.TaxCode, 1, 1) = '3' then 'Y'
          else 'N' 
          end as reversecharge,
          case 
          when POH.PurchaseOrderType = 'ZSER' or substring(joi.IN_HSNOrSACCode, 1, 2) = '99' then ' '                
          when POH.PurchaseOrderType = 'ZIMP' and POI.ProductType = '1' then 'Goods Import'
          when POH.PurchaseOrderType = 'ZIMP' and POI.ProductType = '2' then 'Service Import'
          //when eligibilitycategory = 'Input Services' then 'Domestic Service' 
          else null end as importtype,
          JEI.FiscalYearPeriod as gstr2returnperiod, 
          JEI.FiscalYearPeriod as b3auto_fillperiod,
          JEI.PostingDate,                                                          
          JEI.CompanyCodeCurrency as CCURR,
          joi.TaxItemGroup,
//          cast(JEI.CreditAmountInCoCodeCrcy as abap.dec( 15, 2 ) ) * -1 as TaxableValue                      
          
          case
                when JEH.AccountingDocumentType = 'KR' and(joi.TaxCode = '40' or joi.TaxCode = '4A' or joi.TaxCode = '4B' or 
                                                            joi.TaxCode = '4C' or joi.TaxCode = '4D' or joi.TaxCode = '4E' or 
                                                            joi.TaxCode = '4F' or joi.TaxCode = '4G' or joi.TaxCode = '4H' or 
                                                            joi.TaxCode = '4I') then cast(joi.OriginalTaxAbsoluteBaseAmount as abap.dec( 15, 2 ) )          
                when JEH.AccountingDocumentType = 'RE' and JEI.DebitAmountInTransCrcy is initial
                        then cast(JEI.CreditAmountInTransCrcy as abap.dec( 15, 2 ) ) * -1 
                when JEH.AccountingDocumentType = 'RE' and JEI.CreditAmountInTransCrcy is initial
                        then cast(JEI.DebitAmountInTransCrcy as abap.dec( 15, 2 ) )  
                when JEH.AccountingDocumentType = 'KR' and JEI.DebitAmountInTransCrcy is initial
                        then cast(JEI.CreditAmountInTransCrcy as abap.dec( 15, 2 ) ) * -1 
                when JEH.AccountingDocumentType = 'KR' and JEI.CreditAmountInTransCrcy is initial
                        then cast(JEI.DebitAmountInTransCrcy as abap.dec( 15, 2 ) )  
                when JEH.AccountingDocumentType = 'KG' and JEI.DebitAmountInTransCrcy is initial
                        then cast(JEI.CreditAmountInTransCrcy as abap.dec( 15, 2 ) ) * -1 
                when JEH.AccountingDocumentType = 'KG' and JEI.CreditAmountInTransCrcy is initial
                        then cast(JEI.DebitAmountInTransCrcy as abap.dec( 15, 2 ) )  
//                when JEH.AccountingDocumentType = 'KZ' and JEI.DebitAmountInTransCrcy is initial
//                        then cast(JEI.CreditAmountInTransCrcy as abap.dec( 15, 2 ) ) * -1 
//                when JEH.AccountingDocumentType = 'KZ' and JEI.CreditAmountInTransCrcy is initial
//                        then cast(JEI.DebitAmountInTransCrcy as abap.dec( 15, 2 ) )  
//                when JEH.AccountingDocumentType = 'KA' and JEI.DebitAmountInTransCrcy is initial
//                        then cast(JEI.CreditAmountInTransCrcy as abap.dec( 15, 2 ) ) * -1 
//                when JEH.AccountingDocumentType = 'KA' and JEI.CreditAmountInTransCrcy is initial
//                        then cast(JEI.DebitAmountInTransCrcy as abap.dec( 15, 2 ) )  

                                                
                        else null end as TaxableValue,
          IGST.TransactionTypeDetermination as igstkey,
          CGST.TransactionTypeDetermination as cgstkey,
          SGST.TransactionTypeDetermination as sgstkey,
          case
                when joi.IsNegativePosting = 'X' then cast(IGST.AbsltAmtInAdditionalCurrency1 as abap.dec( 15, 2 ) ) * -1
                    else cast(IGST.AbsltAmtInAdditionalCurrency1 as abap.dec( 15, 2 )) end as IGSTAmount,
//          cast(IGST.AbsltAmtInAdditionalCurrency1 as abap.dec( 15, 2 ) ) as IGSTAmount,
          case
                when joi.IsNegativePosting = 'X' then cast(CGST.AbsltAmtInAdditionalCurrency1 as abap.dec( 15, 2 ) ) * -1
                    else cast(CGST.AbsltAmtInAdditionalCurrency1 as abap.dec( 15, 2 )) end as CGSTAmount,
                    
//          cast(CGST.AbsltAmtInAdditionalCurrency1 as abap.dec( 15, 2 ) ) as CGSTAmount,
          case
                when joi.IsNegativePosting = 'X' then cast(SGST.AbsltAmtInAdditionalCurrency1 as abap.dec( 15, 2 ) ) * -1
                    else cast(SGST.AbsltAmtInAdditionalCurrency1 as abap.dec( 15, 2 )) end as SGSTAmount,
//          cast(SGST.AbsltAmtInAdditionalCurrency1 as abap.dec( 15, 2 ) ) as SGSTAmount,

          abap.string' ' as notevalue,
          @Semantics.amount.currencyCode: 'Ccurr' 
          abap.curr'0.00' as cessamount,
          JEI.ReversalReferenceDocument                                                  
} where JEI.GLAccount != '0000238000' and
        JEI.GLAccount != '0000649007' and
        JEI.GLAccount != '0000649005'

