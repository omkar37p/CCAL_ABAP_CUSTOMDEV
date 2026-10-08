@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root view'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZAPI_ROOTVIEW as select from I_SalesOrder as soh
left outer join I_SalesOrderItem as soi on soi.SalesOrder = soh.SalesOrder


{
  key soi.SalesOrder,
  key soi.SalesOrderItem,
  key soh.SalesOrder  as salesordernumber,
  soi.SalesOrderItemUUID,
  soi.SalesOrderItemCategory,
  soi.SalesOrderItemType,
  soi.IsReturnsItem,
  soi.CreatedByUser,
  soi.CreationDate,
  soi.CreationTime,
  soi.LastChangeDate,
  soi.Division,
  soi.Material as Product,
  
  soi.OriginallyRequestedMaterial,
  soi.MaterialByCustomer,
  soi.InternationalArticleNumber,
  soi.Batch,
  soi.ProductHierarchyNode,
  soi.ProductCatalog,
  soi.MaterialSubstitutionReason,
  soi.MaterialGroup,
  soi.ProductGroup,
  soi.MaterialPricingGroup,
  soi.AdditionalMaterialGroup1,
  soi.AdditionalMaterialGroup2,
  soi.AdditionalMaterialGroup3,
  soi.AdditionalMaterialGroup4,
  soi.AdditionalMaterialGroup5,
  soi.Plant,
  soi.BaseUnit,
 @Semantics.quantity.unitOfMeasure: 'BaseUnit'
  soi.OrderQuantity,
  soi.OrderQuantityUnit,
  soi.OrderToBaseQuantityDnmntr,
  
@Semantics.amount.currencyCode: 'TransactionCurrency'
  soi.NetAmount,
  soi.TransactionCurrency,

   soi.ProfitCenter,
  soi.WBSElement,
  soi.WBSElementInternalID,
  soi.OrderID,

  soi.SalesOrderType,
  soi.SalesOrganization,
  soi.DistributionChannel,
  soi.OrganizationDivision,

  soi.ShipToParty,
  soi.PayerParty,
  soi.BillToParty

 


  
}
