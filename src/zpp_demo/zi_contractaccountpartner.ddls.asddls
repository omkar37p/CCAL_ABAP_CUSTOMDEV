@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CONTRACT ACCOUNT PARTNER'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_CONTRACTACCOUNTPARTNER as select from I_ContractAccountPartner
{
    key ContractAccount,
    key BusinessPartner,
    ContractAccountName,
    CreationDate,
    CreationTime,
    CreatedByUser,
    IsMarkedForDeletion,
    LastChangeDate,
    LastChangeTime,
    LastChangedByUser,
    CABankIDForIncomingPayments,
    CABankIDForOutgoingPayments,
    CAIncomingPaymentMethod,
    CACnctntdOutgPaymentMethods,
    CAFirstOutgoingPaymentMethod,
    CASecondOutgoingPaymentMethod,
    CAThirdOutgoingPaymentMethod,
    CAFourthOutgoingPaymentMethod,
    CAFifthOutgoingPaymentMethod,
    CAHouseBankReference,
    CAPaymentCardIDForIncomingPayt,
    CAPaymentCardIDForOutgoingPayt,
    SEPAMandate,
    CADunningProcedure,
    CADunningNoticeGroup,
    CACorrespondenceDunningProced,
    CACollectionsClerk,
    CACollectionsMasterDataGroup,
    CACollectionStrategy,
    CACollectionsContactPerson

}
