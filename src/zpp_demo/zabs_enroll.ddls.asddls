@EndUserText.label: 'Enroll Input'
define abstract entity ZABS_ENROLL

{
      //  BusinessPartner          : abap.char(10);
  key AlternateBusinessPartner : abap.char(10);

      ContractAccount          : abap.char(12);

      PaymentToken             : abap.char(132);

      BankAccountNumber        : abap.char(30);
      BankRoutingNumber        : abap.char(20);
      BankAccountType          : abap.char(10);
//      _items                   : composition [0..*] of ZABS_ENROLL_CHILD;

}
