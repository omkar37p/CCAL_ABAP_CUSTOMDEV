@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Register Custom Report Root View'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZSDCUS_REPORT_RV
  as select from    ZSDINVOCIE_PRCD_TAX    as BOI
    left outer join I_DeliveryDocumentItem as DOI     on  DOI.DeliveryDocument      = BOI.ReferenceSDDocument
                                                      and DOI.DeliveryDocumentItem  = BOI.ReferenceSDDocumentItem
                                                      and DOI.ItemIsBillingRelevant = 'K'
    left outer join I_DeliveryDocument     as DOH     on DOH.DeliveryDocument = DOI.DeliveryDocument
    left outer join I_SalesOrderItem       as SOI     on  SOI.SalesOrder     = DOI.ReferenceSDDocument
                                                      and SOI.SalesOrderItem = DOI.ReferenceSDDocumentItem
    left outer join I_SalesOrder           as SOH     on SOH.SalesOrder = SOI.SalesOrder
    left outer join I_ProductDescription   as PRD_DES on  PRD_DES.Product  = BOI.Product
                                                      and PRD_DES.Language = $session.system_language
    left outer join I_Customer             as bil_cus on bil_cus.Customer = BOI.SoldToParty
    left outer join ZEWAY_EIN_CUS_VIEW     as Eway    on Eway.ElectronicDocSourceKey = BOI.BillingDocument
    left outer join I_ProductPlantBasic    as HSN     on  HSN.Product = BOI.Product
                                                      and HSN.Plant   = BOI.Plant
  
  //*****Ship to party***********
    left outer join ZSDCUS_REPORT as SHIP on SHIP.BillingDocument = BOI.BillingDocument
                                           and SHIP.BillingDocumentItem = BOI.BillingDocumentItem


  //***************Sales Return Order Invoice Details*********
    left outer join ZSD_RETURN_ORDER       as Return  on  Return.ReferenceSDDocument     = BOI.ReferenceSDDocument
                                                      and Return.ReferenceSDDocumentItem = BOI.ReferenceSDDocumentItem
  //// Gate entry screen data
    left outer join ZSDCAPP04              as cus_pak on cus_pak.delvnum = DOI.DeliveryDocument
  ///******** billing document type description****
  association [1..1] to I_BillingDocumentTypeText as _billingDesc on  $projection.BillingDocumentType = _billingDesc.BillingDocumentType
                                                                  and _billingDesc.Language           = $session.system_language






{
  key BOI.BillingDocument,
  key BOI.BillingDocumentItem,
  key DOI.DeliveryDocument,
  key DOI.DeliveryDocumentItem,
  key SOH.SalesOrder,
  key SOI.SalesOrderItem,
  key bil_cus.Customer                                     as bill_customer,
      BOI.SoldToParty,
      BOI.DocumentReferenceID                              as ODNNumber,
      BOI.Product,
      PRD_DES.ProductDescription,
      case substring(BOI.CreationDate, 5, 2)
           when '01' then 'January'
           when '02' then 'February'
           when '03' then 'March'
           when '04' then 'April'
           when '05' then 'May'
           when '06' then 'June'
           when '07' then 'July'
           when '08' then 'August'
           when '09' then 'September'
           when '10' then 'October'
           when '11' then 'November'
           when '12' then 'December'
           else null end                                   as CreateMonth,
      BOI.CreationDate                                     as InvoiceDate,
      BOI.CreationTime,
      bil_cus.AddressSearchTerm2                           as EndusCMR,
      bil_cus.TaxNumber3                                   as GSTNo,
      bil_cus.BusinessPartnerName1                         as BillPartyName1,
      bil_cus.BusinessPartnerName2                         as BillPartyName2,
      bil_cus.StreetName                                   as billcusStreetName,
      bil_cus.CityName                                     as billcusCityName,
      bil_cus.Region                                       as billtoState,
      BOI.BillingDocumentType,
      BOI.BaseUnit,
      cast(DOI.ActualDeliveryQuantity as abap.dec( 9, 3 )) as DeliveryQuantity,
      _billingDesc.BillingDocumentTypeName,
      case
          when (BOI.BillingDocumentType = 'G2' or BOI.BillingDocumentType = 'S1') then (-1 * BOI.BillingQuantity)
          else BOI.BillingQuantity end                     as BillingQuantity,
      case
          when (BOI.BillingDocumentType = 'G2' or BOI.BillingDocumentType = 'S1') then (-1 * BOI.BasicPrice)
          else BOI.BasicPrice end                          as BasicPrice,
      case
          when (BOI.BillingDocumentType = 'G2' or BOI.BillingDocumentType = 'S1') then (-1 * BOI.FreightPrice)
          else BOI.FreightPrice end                        as FreightPrice,
      //        BOI.FreightPrice,
      //        BOI.Commission,
      case
          when (BOI.BillingDocumentType = 'G2' or BOI.BillingDocumentType = 'S1') then (-1 * BOI.Commission)
          else BOI.Commission end                          as Commission,
      BOI.Discount,
      case
          when (BOI.BillingDocumentType = 'G2' or BOI.BillingDocumentType = 'S1') then (-1 * BOI.ProFreight)
          else BOI.ProFreight end                          as ProFreight,
      //        BOI.ProFreight,
      BOI.Warranty,
      //        BOI.NetValue,
      case
          when (BOI.BillingDocumentType = 'G2' or BOI.BillingDocumentType = 'S1') then (-1 * BOI.NetValue)
          else BOI.NetValue end                            as NetValue,
      //        BOI.TaxableValue,
      case
          when (BOI.BillingDocumentType = 'G2' or BOI.BillingDocumentType = 'S1') then (-1 * BOI.TaxableValue)
          else BOI.TaxableValue end                        as TaxableValue,
      case
          when (BOI.BillingDocumentType = 'G2' or BOI.BillingDocumentType = 'S1') then (-1 * BOI.IGSTamt)
          else BOI.IGSTamt end                             as IGSTamt,
      case
          when (BOI.BillingDocumentType = 'G2' or BOI.BillingDocumentType = 'S1') then (-1 * BOI.CGSTamt)
          else BOI.CGSTamt end                             as CGSTamt,
      case
          when (BOI.BillingDocumentType = 'G2' or BOI.BillingDocumentType = 'S1') then (-1 * BOI.SGSTamt)
          else BOI.SGSTamt end                             as SGSTamt,
      //        BOI.TotalTaxValue,
      case
          when (BOI.BillingDocumentType = 'G2' or BOI.BillingDocumentType = 'S1') then (-1 * BOI.TotalTaxValue)
          else BOI.TotalTaxValue end                       as TotalTaxValue,
      BOI.Curr,
      @Semantics.amount.currencyCode: 'Curr'
      BOI.Roundoff,
      case
          when (BOI.BillingDocumentType = 'G2' or BOI.BillingDocumentType = 'S1') then (-1 * BOI.TCS)
          else BOI.TCS end                                 as TCS,
      case
          when (BOI.BillingDocumentType = 'G2' or BOI.BillingDocumentType = 'S1') then (-1 * BOI.Freight_UOM)
          else BOI.Freight_UOM end                         as Freight_UOM,
      BOI.BillingStatus,
      BOI.TransactionCurrency,
      case
          when BOI.DistributionChannel = '40' then (BOI.GrossValue + BOI.TCS)
          when (BOI.BillingDocumentType = 'G2' or BOI.BillingDocumentType = 'S1') then (-1 * BOI.GrossValue)
      //            when BOI.DistributionChannel != '40' then BOI.GrossValue
          else BOI.GrossValue end                          as GrossValue, // case fields
      case
          when BOI.DistributionChannel = '30' then (BOI.GrossValue * BOI.AccountingExchangeRate )
          when BOI.DistributionChannel != '30' then (BOI.GrossValue * 0)
          else null end                                    as PortInvoiceValue, // case fields for this one export releated fields
      BOI.ValueinUSD,
      BOI.ZPROUSD,
      //        BOI.GrossValue,       original fields
      Eway.IN_ElectronicDocEWbillNmbr                      as EwayBillNo,
      Eway.IN_EDocEWbillCreateDate                         as Ewaybilldate,
      Eway.IN_ElectronicDocAcknNmbr                        as EinvoiceNo,
      Eway.IN_ElectronicDocAcknNmbr                        as AckNoEinvoiceNo,
      BOI.SalesOrganization,
      BOI.DistributionChannel,
      BOI.Division,
      BOI.AccountingDocument                               as JournalEntryNo,
      BOI.AccountingExchangeRate                           as ExchangeRate,
      HSN.ConsumptionTaxCtrlCode                           as HSN,
      SOH.PurchaseOrderByCustomer                          as cussoref,
      BOI.CompanyCode,
      BOI.Plant,
      cast(SOI.OrderQuantity as abap.dec( 9, 3 ) )         as OrderQuantity,
      DOH.YY1_Transporter_DLH                              as TransporterName,
      DOH.YY1_VehicleNumber_DLH                            as Vehiclenumber,
      cus_pak.Drivername                                   as Drivername,
      SOH.PurchaseOrderByCustomer                          as CustomerRef,
      BOI.InvoiceTime,
      
      //****Ship to party
      SHIP.shipcusCityName,
      SHIP.shiptostate


}
