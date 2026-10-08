@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase order Reversed Amount'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZMM_PO_REVERSED 
as select from I_PurchaseOrderItemAPI01 as A
left outer join I_MaterialDocumentItem_2 as B on B.PurchaseOrder = A.PurchaseOrder
                                    and B.PurchaseOrderItem = A.PurchaseOrderItem
{
    key A.PurchaseOrder as PurchaseOrder,
    key A.PurchaseOrderItem as PurchaseOrderItem,
        A.YY1_budget_code_PDI as BudgetCode,
        A.BaseUnit,
        @Semantics.quantity.unitOfMeasure: 'BaseUnit'        
        sum(B.QuantityInEntryUnit) as QuantityInEntryUnit
}
where A.YY1_budget_code_PDI <> '0000000000000'
group by A.PurchaseOrder,
         A.PurchaseOrderItem,
    A.YY1_budget_code_PDI,
    A.BaseUnit
         
