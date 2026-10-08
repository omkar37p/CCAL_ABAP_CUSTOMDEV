@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Invoice APIs Root View Entity'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZAPI_APP01_RV
  as select from    I_BillingDocument              as BDH
    inner join      I_BillingDocumentItem          as BDI  on  BDI.BillingDocument = BDH.BillingDocument
                                                           and BDI.NetAmount       is not initial
    left outer join I_Customer                     as cus  on cus.Customer = BDI.BillToParty
    left outer join I_BillingDocumentItemPrcgElmnt as ZPRO on  ZPRO.BillingDocument     = BDI.BillingDocument
                                                           and ZPRO.BillingDocumentItem = BDI.BillingDocumentItem
                                                           and ZPRO.ConditionType       = 'ZPRO'
                                                           and ZPRO.ConditionControl    = 'C'
    left outer join I_BillingDocumentItemPrcgElmnt as ZFRI on  ZFRI.BillingDocument     = BDI.BillingDocument
                                                           and ZFRI.BillingDocumentItem = BDI.BillingDocumentItem
                                                           and ZFRI.ConditionType       = 'ZFRI'
                                                           and ZFRI.ConditionAmount     is not initial
    left outer join I_BillingDocumentItemPrcgElmnt as IGST on  IGST.BillingDocument     = BDI.BillingDocument
                                                           and IGST.BillingDocumentItem = BDI.BillingDocumentItem
                                                           and IGST.ConditionType       = 'JOIG'
    left outer join I_BillingDocumentItemPrcgElmnt as CGST on  CGST.BillingDocument     = BDI.BillingDocument
                                                           and CGST.BillingDocumentItem = BDI.BillingDocumentItem
                                                           and CGST.ConditionType       = 'JOCG'
    left outer join I_BillingDocumentItemPrcgElmnt as SGST on  SGST.BillingDocument     = BDI.BillingDocument
                                                           and SGST.BillingDocumentItem = BDI.BillingDocumentItem
                                                           and SGST.ConditionType       = 'JOSG'
    left outer join I_BillingDocumentItemPrcgElmnt as ZTCS on  ZTCS.BillingDocument     = BDI.BillingDocument
                                                           and ZTCS.BillingDocumentItem = BDI.BillingDocumentItem
                                                           and ZTCS.ConditionType       = 'JTC1'
{
  key BDI.BillingDocument,
  key BDI.BillingDocumentItem,
      BDH.BillingDocumentDate                         as BillDate,
      BDH.BillingDocumentType,
      BDH.DistributionChannel                         as VoucherType,
      BDH.DocumentReferenceID                         as ODNNumber,
      BDI.Product,
      BDI.BillingDocumentItemText,
      BDI.Plant,
      BDI.BaseUnit,
      BDH.TransactionCurrency                         as curr,
      @Semantics.amount.currencyCode: 'curr'
      BDI.NetAmount                                   as TaxbleValue,
      @Semantics.amount.currencyCode: 'curr'
      BDI.TaxAmount,
      @Semantics.amount.currencyCode: 'curr'
      BDI.NetAmount + BDI.TaxAmount                   as totalvalue,
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      BDI.BillingQuantity                             as Quantity,
      cus.CustomerName,
      cast(ZPRO.ConditionAmount as abap.dec( 15, 2 )) as BaseValue,
      cast(ZFRI.ConditionAmount as abap.dec( 15, 2 )) as Freight,
      cast(IGST.ConditionAmount as abap.dec( 15, 2 )) as igstvalue,
      cast(CGST.ConditionAmount as abap.dec( 15, 2 )) as cgstvalue,
      cast(SGST.ConditionAmount as abap.dec( 15, 2 )) as sgstvalue,
      cast(ZTCS.ConditionAmount as abap.dec( 15, 2 )) as tcsvalue,
      bdh.CreationDate,
      bdh.CreationTime


}
