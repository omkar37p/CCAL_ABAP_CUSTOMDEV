@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection view'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZAPI_PROJECTIONVIEW as select from ZAPI_ROOTVIEW

{
    key SalesOrder,
    key SalesOrderItem,
    key salesordernumber,
    SalesOrderItemUUID,
    SalesOrderItemCategory,
    SalesOrderItemType,
    IsReturnsItem,
    CreatedByUser,
    CreationDate,
    CreationTime,
    LastChangeDate,
    Division,
    Product,
  
    MaterialByCustomer,
    InternationalArticleNumber,
    Batch,
    
    ProductGroup,
    MaterialPricingGroup,
  
    Plant,
    BaseUnit,
     @Semantics.quantity.unitOfMeasure: 'BaseUnit'
    OrderQuantity,
    OrderQuantityUnit,
    OrderToBaseQuantityDnmntr,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    NetAmount,
    TransactionCurrency,
    ProfitCenter,
   
    OrderID,
    SalesOrderType,
    SalesOrganization,
    DistributionChannel,
    OrganizationDivision,
    ShipToParty,
    PayerParty,
    BillToParty
   
}
