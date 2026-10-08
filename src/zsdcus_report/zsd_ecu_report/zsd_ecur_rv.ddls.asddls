@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Register ECU Report Root View'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #L,
    dataClass: #TRANSACTIONAL
}
//@Search.searchable: true
define root view entity ZSD_ECUR_RV as select from I_BillingDocument as BDH
                            inner join I_BillingDocumentItem as BDI on BDI.BillingDocument = BDH.BillingDocument
                                                                       and BDI.NetAmount is not initial
                            left outer join I_Customer as cus on cus.Customer = BDI.BillToParty
                            left outer join I_BillingDocumentItemPrcgElmnt as ZPRO on ZPRO.BillingDocument = BDI.BillingDocument
                                                                           and ZPRO.BillingDocumentItem = BDI.BillingDocumentItem
                                                                           and ZPRO.ConditionType = 'ZPRO'
                                                                           and ZPRO.ConditionControl = 'C'
                            left outer join I_BillingDocumentItemPrcgElmnt as ZFRI on ZFRI.BillingDocument = BDI.BillingDocument
                                                                           and ZFRI.BillingDocumentItem = BDI.BillingDocumentItem
                                                                           and ZFRI.ConditionType = 'ZFRI' and
                                                                               ZFRI.ConditionAmount is not initial
                            left outer join I_BillingDocumentItemPrcgElmnt as IGST on IGST.BillingDocument = BDI.BillingDocument
                                                                           and IGST.BillingDocumentItem = BDI.BillingDocumentItem
                                                                           and IGST.ConditionType = 'JOIG'
                            left outer join I_BillingDocumentItemPrcgElmnt as CGST on CGST.BillingDocument = BDI.BillingDocument
                                                                           and CGST.BillingDocumentItem = BDI.BillingDocumentItem
                                                                           and CGST.ConditionType = 'JOCG'
                            left outer join I_BillingDocumentItemPrcgElmnt as SGST on SGST.BillingDocument = BDI.BillingDocument
                                                                           and SGST.BillingDocumentItem = BDI.BillingDocumentItem
                                                                           and SGST.ConditionType = 'JOSG'
                            left outer join I_BillingDocumentItemPrcgElmnt as ZTCS on ZTCS.BillingDocument = BDI.BillingDocument
                                                                           and ZTCS.BillingDocumentItem = BDI.BillingDocumentItem
                                                                           and ZTCS.ConditionType = 'JTC1'
                            left outer join I_DeliveryDocumentItem as DOI on DOI.DeliveryDocument = BDI.ReferenceSDDocument
                                                                           and DOI.DeliveryDocumentItem = BDI.ReferenceSDDocumentItem
                                                                           and DOI.ItemIsBillingRelevant = 'K'
                            left outer join I_DeliveryDocument as DOH on DOH.DeliveryDocument = DOI.DeliveryDocument                                                                                              
                            left outer join I_Customer as ship on ship.Customer = DOH.ShipToParty

{
    key BDH.BillingDocument as VoucherNo,
    key BDI.BillingDocumentItem,
    key cus.Customer as customerCode,
    key DOI.DeliveryDocument,
    key DOI.DeliveryDocumentItem,
        BDH.BillingDocumentDate as BillDate,
        BDH.BillingDocumentType,
        BDH.DistributionChannel as VoucherType,
        BDH.DocumentReferenceID as ODNNumber,
        BDI.Product,
        BDI.BillingDocumentItemText,
        BDI.Plant,
        BDI.BaseUnit,
        BDH.TransactionCurrency as curr,
        @Semantics.amount.currencyCode: 'curr'
        cast(BDI.NetAmount as abap.dec( 15, 2 )) as TaxbleValue,
//        cast(get_numeric_value(BDI.NetAmount)as abap.dec( 9, 3 )) as TaxbleValue, 
        cast(BDI.BillingQuantity as abap.dec( 9, 3 )) as Quantity,
        cus.CustomerName,
        cast(ZPRO.ConditionAmount as abap.dec( 15, 2 )) as BaseValue,
        cast(ZFRI.ConditionAmount as abap.dec( 15, 2 )) as Freight,
        cast(IGST.ConditionAmount as abap.dec( 15, 2 )) as igstvalue,
        cast(CGST.ConditionAmount as abap.dec( 15, 2 )) as cgstvalue,
        cast(SGST.ConditionAmount as abap.dec( 15, 2 )) as sgstvalue,
        cast(ZTCS.ConditionAmount as abap.dec( 15, 2 )) as tcsvalue,
        case
        
            when IGST.ConditionType = 'JOIG' then cast(BDI.NetAmount + IGST.ConditionAmount as abap.dec( 15, 2 ))
            
            when CGST.ConditionType = 'JOCG' then cast(BDI.NetAmount + CGST.ConditionAmount + SGST.ConditionAmount as abap.dec( 15, 2 ))
                                                       
            when ZTCS.ConditionType = 'JTC1' then cast(BDI.NetAmount + ZTCS.ConditionAmount as abap.dec( 15, 2 ))
            
            when ZPRO.ConditionType = 'ZPRO' then cast(BDI.NetAmount as abap.dec( 15, 2 ))
            
            when ZFRI.ConditionType = 'ZFRI' then cast( BDI.NetAmount + ZTCS.ConditionAmount as abap.dec( 15, 2 ))
            
            when ZTCS.ConditionType = 'JTC1' and IGST.ConditionType = 'JOIG'
                                                        then cast( BDI.NetAmount + IGST.ConditionAmount + ZTCS.ConditionAmount as abap.dec( 15, 2 ))

            when ZTCS.ConditionType = 'JTC1' and CGST.ConditionType = 'JOCG'
                                                        then cast( BDI.NetAmount +  CGST.ConditionAmount + SGST.ConditionAmount + ZTCS.ConditionAmount as abap.dec( 15, 2 ))

            else null end as InvoiceValue,
            
          DOH.ShipToParty,
          ship.CustomerName as shipcustomername,
          case
          
            when BDH.YY1_CreationTime_BDH = '000000' then BDH.CreationTime
            else BDH.YY1_CreationTime_BDH end as CreationTime
}
