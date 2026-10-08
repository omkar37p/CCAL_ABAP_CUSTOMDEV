@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Company Code Address'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_CCODE_ADDR2
  as select from I_CompanyCode as Company
  association [0..1] to I_Address_2 as Address on Address.AddressID = Company.AddressID
{
  key Company.CompanyCode,
      Company.CompanyCodeName,
      Company.CityName,
      Company.Country,
      Company.Currency,
      Company.Language,
      Company.ChartOfAccounts,
      Company.FiscalYearVariant,
      Company.Company,
      Company.CreditControlArea,
      Company.CountryChartOfAccounts,
      Company.FinancialManagementArea,
      Company.AddressID,
      Company.TaxableEntity,
      Company.VATRegistration,
      Company.ExtendedWhldgTaxIsActive,
      Company.ControllingArea,
      Company.FieldStatusVariant,
      Company.NonTaxableTransactionTaxCode,
      Company.DocDateIsUsedForTaxDetn,
      Company.TaxRptgDateIsActive,
      Company.CashDiscountBaseAmtIsNetAmt,

      /* Associations */
      Company._Address,
      Company._ChartOfAccounts,
      Company._ChartOfAccountsText,
      Company._CompanyCodeHierNode,
      Company._ControllingArea,
      Company._ControllingAreaText,
      Company._Country,
      Company._CountryChartOfAccounts,
      Company._CountryChartOfAccountsText,
      Company._CreditControlArea,
      Company._CreditControlAreaText,
      Company._Currency,
      Company._FieldStatusVariant,
      Company._FiscalYearVariant,
      Company._GlobalCompany,
      Company._Language,
      Company._OrgAddressDefaultRprstn
}
