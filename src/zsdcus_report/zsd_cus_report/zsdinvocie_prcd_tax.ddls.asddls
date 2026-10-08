@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Invoice PRCD Tax Value Custom CDS View'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZSDINVOCIE_PRCD_TAX as select from I_BillingDocumentItem as BOI
                inner join I_BillingDocument as BOH on BOH.BillingDocument = BOI.BillingDocument
                                                                  and BOI.BillingQuantity is not initial
                left outer join I_BillingDocumentItemPrcgElmnt as ZPRO on ZPRO.BillingDocument = BOI.BillingDocument
                                                                  and ZPRO.BillingDocumentItem = BOI.BillingDocumentItem
                                                                  and ZPRO.ConditionType = 'ZPRO'
                                                                  and ZPRO.ConditionRateAmount is not initial
                left outer join I_BillingDocumentItemPrcgElmnt as ZFRI on ZFRI.BillingDocument = BOI.BillingDocument
                                                                  and ZFRI.BillingDocumentItem = BOI.BillingDocumentItem
                                                                  and ZFRI.ConditionType = 'ZFRI'
                                                                  and ZFRI.ConditionRateAmount is not initial
                left outer join I_BillingDocumentItemPrcgElmnt as ZCOM on ZCOM.BillingDocument = BOI.BillingDocument
                                                                  and ZCOM.BillingDocumentItem = BOI.BillingDocumentItem
                                                                  and ZCOM.ConditionType = 'ZCOM'
                                                                  and ZCOM.ConditionRateAmount is not initial
                left outer join I_BillingDocumentItemPrcgElmnt as ZDIS on ZDIS.BillingDocument = BOI.BillingDocument
                                                                  and ZDIS.BillingDocumentItem = BOI.BillingDocumentItem
                                                                  and ZDIS.ConditionType = 'ZDIS'
                                                                  and ZDIS.ConditionRateAmount is not initial
                left outer join I_BillingDocumentItemPrcgElmnt as ZFRE on ZFRE.BillingDocument = BOI.BillingDocument
                                                                  and ZFRE.BillingDocumentItem = BOI.BillingDocumentItem
                                                                  and ZFRE.ConditionType = 'ZFRE'
                                                                  and ZFRE.ConditionRateAmount is not initial
                left outer join I_BillingDocumentItemPrcgElmnt as ZWAR on ZWAR.BillingDocument = BOI.BillingDocument
                                                                  and ZWAR.BillingDocumentItem = BOI.BillingDocumentItem
                                                                  and ZWAR.ConditionType = 'ZWAR'
                                                                  and ZWAR.ConditionRateAmount is not initial
                left outer join I_BillingDocumentItemPrcgElmnt as IGST on IGST.BillingDocument = BOI.BillingDocument
                                                                  and IGST.BillingDocumentItem = BOI.BillingDocumentItem
                                                                  and IGST.ConditionType = 'JOIG'
                                                                  and IGST.ConditionAmount is not initial
                left outer join I_BillingDocumentItemPrcgElmnt as CGST on CGST.BillingDocument = BOI.BillingDocument
                                                                  and CGST.BillingDocumentItem = BOI.BillingDocumentItem
                                                                  and CGST.ConditionType = 'JOCG'
                                                                  and CGST.ConditionAmount is not initial
                left outer join I_BillingDocumentItemPrcgElmnt as SGST on SGST.BillingDocument = BOI.BillingDocument
                                                                  and SGST.BillingDocumentItem = BOI.BillingDocumentItem
                                                                  and SGST.ConditionType = 'JOSG'
                                                                  and SGST.ConditionAmount is not initial
                left outer join I_BillingDocumentItemPrcgElmnt as RoundOff on RoundOff.BillingDocument = BOI.BillingDocument
                                                                  and RoundOff.BillingDocumentItem = BOI.BillingDocumentItem
                                                                  and RoundOff.ConditionType = 'DRD1'
                                                                  and RoundOff.ConditionAmount is not initial
                left outer join I_BillingDocumentItemPrcgElmnt as ZTCS on ZTCS.BillingDocument = BOI.BillingDocument
                                                                  and ZTCS.BillingDocumentItem = BOI.BillingDocumentItem
                                                                  and ZTCS.ConditionType = 'JTC1'
                                                                  
                                                                  

{
key BOI.BillingDocument,
key BOI.BillingDocumentItem,
    BOI.ReferenceSDDocument,
    BOI.ReferenceSDDocumentItem,
    BOH.BillingDocumentDate as CreationDate ,
    BOH.CreationTime,
    BOH.DocumentReferenceID ,
    BOH.BillingDocumentType,
    BOH.AccountingDocument ,
    cast(BOH.AccountingExchangeRate as abap.dec( 14, 3 )) as AccountingExchangeRate,
    BOH.FiscalYear,
    BOH.SoldToParty,
    BOI.Product,
    BOI.Plant, // OK
    BOH.CustomerPaymentTerms, //OK
    BOH.DistributionChannel,  // OK
    BOH.AccountingPostingStatus as BillingStatus,
    BOI.TransactionCurrency,
    BOI.BillingQuantityUnit as BaseUnit, // OK
    BOH.SalesOrganization,  // OK
    BOH.Division,  //OK
    BOH.IncotermsClassification, //OK
    BOH.IncotermsLocation1,  // OK
    BOH.CompanyCode,  // OK
    cast(BOI.BillingQuantity as abap.dec( 9, 3 )) as BillingQuantity,
    cast(ZPRO.ConditionRateAmount as abap.dec( 14, 2 )) as BasicPrice,    
    cast(ZFRI.ConditionRateAmount as abap.dec( 14, 2 )) as FreightPrice, 
    cast(ZFRI.ConditionAmount as abap.dec( 14, 2 )) as Freight_UOM,   
    cast(ZCOM.ConditionRateAmount as abap.dec( 14, 2 )) as Commission,    
    cast(ZDIS.ConditionRateAmount as abap.dec( 14, 2 )) as Discount,    
    cast(ZFRE.ConditionRateAmount as abap.dec( 14, 2 )) as ProFreight,
    cast(ZWAR.ConditionRateAmount as abap.dec( 14, 2 )) as Warranty,
    cast(ZTCS.ConditionAmount as abap.dec( 14, 2 )) as TCS,
    cast(ZPRO.ConditionRateAmount * BOI.BillingQuantity as abap.dec( 14, 2 )) as NetValue,
    case
            when BOI.DistributionChannel = '30' then ( cast(ZPRO.ConditionRateAmount as abap.dec( 14, 2 )) * cast(BOI.BillingQuantity as abap.dec( 9, 3 ) ))
            else null end as ValueinUSD,
    case
            when BOI.DistributionChannel = '30' then ( cast(ZPRO.ConditionRateAmount as abap.dec( 14, 2 )) )
            else null end as ZPROUSD,

    case 
            when ZPRO.ConditionAmount is not initial and ZFRI.ConditionAmount is not initial and ZDIS.ConditionAmount is not initial then 
                        (cast(ZPRO.ConditionAmount as abap.dec( 14, 2 )) + cast(ZFRI.ConditionAmount as abap.dec( 14, 2 )) + cast(ZDIS.ConditionAmount as abap.dec( 14, 2 )))
            when ZPRO.ConditionAmount is not initial and ZFRI.ConditionAmount is not initial then 
                        (cast(ZPRO.ConditionAmount as abap.dec( 14, 2 )) + cast(ZFRI.ConditionAmount as abap.dec( 14, 2 )))
            when ZPRO.ConditionAmount is not initial and ZDIS.ConditionAmount is not initial then
                        (cast(ZPRO.ConditionAmount as abap.dec( 14, 2 )) + cast(ZDIS.ConditionAmount as abap.dec( 14, 2 )))
            when ZPRO.ConditionAmount is not initial then 
                        cast(ZPRO.ConditionAmount as abap.dec( 14, 2 ))
            else null end as TaxableValue,                       
            
//    cast(ZPRO.ConditionAmount + ZFRI.ConditionAmount + ZDIS.ConditionAmount as abap.dec( 9, 3 )) as TaxableValue,
    cast(IGST.ConditionAmount as abap.dec( 14, 2 )) as IGSTamt, 
    cast(CGST.ConditionAmount as abap.dec( 14, 2 )) as CGSTamt, 
    cast(SGST.ConditionAmount as abap.dec( 14, 2 )) as SGSTamt,
    
    case
            when ZPRO.ConditionAmount is not initial and ZFRI.ConditionAmount is not initial
                 and ZDIS.ConditionAmount is not initial and IGST.ConditionAmount is not initial then
                          cast(ZPRO.ConditionAmount + ZFRI.ConditionAmount + ZDIS.ConditionAmount + IGST.ConditionAmount as abap.dec( 14, 2 ))
                          
            when ZPRO.ConditionAmount is not initial and ZFRI.ConditionAmount is not initial
                 and ZDIS.ConditionAmount is not initial and CGST.ConditionAmount is not initial then
                          cast(ZPRO.ConditionAmount + ZFRI.ConditionAmount + ZDIS.ConditionAmount + CGST.ConditionAmount + SGST.ConditionAmount as abap.dec( 14, 2 ))
                          
            when ZPRO.ConditionAmount is not initial and ZFRI.ConditionAmount is not initial and IGST.ConditionAmount is not initial then
                          cast(ZPRO.ConditionAmount + ZFRI.ConditionAmount + IGST.ConditionAmount as abap.dec( 14, 2 ))
            when ZPRO.ConditionAmount is not initial and ZFRI.ConditionAmount is not initial and CGST.ConditionAmount is not initial then
                          cast(ZPRO.ConditionAmount + ZFRI.ConditionAmount + CGST.ConditionAmount + SGST.ConditionAmount as abap.dec( 14, 2 ))
                          
            when ZPRO.ConditionAmount is not initial and ZDIS.ConditionAmount is not initial and IGST.ConditionAmount is not initial then
                          cast(ZPRO.ConditionAmount + ZDIS.ConditionAmount + IGST.ConditionAmount as abap.dec( 14, 2 ))
            when ZPRO.ConditionAmount is not initial and ZDIS.ConditionAmount is not initial and CGST.ConditionAmount is not initial then
                          cast(ZPRO.ConditionAmount + ZDIS.ConditionAmount + CGST.ConditionAmount + SGST.ConditionAmount as abap.dec( 14, 2 ))
                  
            when ZPRO.ConditionAmount is not initial  and IGST.ConditionAmount is not initial then
                          cast(ZPRO.ConditionAmount  + IGST.ConditionAmount as abap.dec( 14, 2 ))
            when ZPRO.ConditionAmount is not initial  and CGST.ConditionAmount is not initial then
                          cast(ZPRO.ConditionAmount  + CGST.ConditionAmount + SGST.ConditionAmount as abap.dec( 14, 2 ))

            when ZPRO.ConditionAmount is not initial and ZFRI.ConditionAmount is not initial then
                          cast(ZPRO.ConditionAmount + ZFRI.ConditionAmount as abap.dec( 14, 2 ))
            when ZPRO.ConditionAmount is not initial then
                          cast(ZPRO.ConditionAmount  as abap.dec( 14, 2 ))
                          
            else null end as GrossValue,

//    cast(ZPRO.ConditionAmount + ZFRI.ConditionAmount + ZDIS.ConditionAmount + IGST.ConditionAmount + CGST.ConditionAmount + SGST.ConditionAmount as abap.dec( 9, 3 )) as GrossValue,
    case
            when IGST.ConditionAmount is not initial then cast(IGST.ConditionAmount as abap.dec( 14, 2 )) 
            when CGST.ConditionAmount is not initial then (cast(CGST.ConditionAmount as abap.dec( 14, 2 )) + cast(SGST.ConditionAmount as abap.dec( 14, 2 )))
            else null end as TotalTaxValue,
   
   RoundOff.ConditionCurrency as Curr,
   @Semantics.amount.currencyCode: 'Curr'        
   RoundOff.ConditionAmount as Roundoff,
   case
   when BOH.YY1_CreationTime_BDH = '000000' then BOH.CreationTime
   else BOH.YY1_CreationTime_BDH end as InvoiceTime
    
}
