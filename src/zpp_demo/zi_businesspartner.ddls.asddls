@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Business Partner'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_BUSINESSPARTNER
  as select from I_BusinessPartner
{
  key BusinessPartner,
      BusinessPartnerCategory,
      AuthorizationGroup,
      BusinessPartnerUUID,
      PersonNumber,
      ETag,
      BusinessPartnerName,
      BusinessPartnerFullName,
      CreatedByUser,
      CreationDate,
      CreationTime,
      LastChangedByUser,
      LastChangeDate,
      LastChangeTime,
      BusinessPartnerIsBlocked,
      IsBusinessPurposeCompleted,
      FirstName,
      LastName,
      PersonFullName,
      OrganizationBPName1,
      OrganizationBPName2,
      OrganizationBPName3,
      OrganizationBPName4,
      OrganizationFoundationDate,
      OrganizationLiquidationDate,
      Industry,
      IsNaturalPerson,
      IsFemale,
      IsMale,
      IsSexUnknown,
      NameCountry,
      BusinessPartnerGrouping,
      BusinessPartnerType,
      MiddleName,
      AdditionalLastName,
      GroupBusinessPartnerName1,
      GroupBusinessPartnerName2,
      CorrespondenceLanguage,
      Language,
      SearchTerm1,
      SearchTerm2,
      BPLastNameSearchHelp,
      BPFirstNameSearchHelp,
      BusinessPartnerNicknameLabel,
      IndependentAddressID

}
