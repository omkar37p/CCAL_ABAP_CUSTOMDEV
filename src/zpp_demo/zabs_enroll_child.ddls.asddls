@EndUserText.label: 'Child enrollment'
define abstract entity ZABS_ENROLL_CHILD
  // association to parent ZABS_ENROLL as _PARENT
  //    on $self = _PARENT
{

  key AlternateBusinessPartner : abap.char(10);

  key ContractAccount          : abap.char(12);

      ActionType               : abap.char(1);

      //_PARENT


}
