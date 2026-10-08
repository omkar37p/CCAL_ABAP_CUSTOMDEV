@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Port Master Root Entity'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZGSTR_PORTMASTER_RE as select from zgstr_portmaster

{
    key portname as Portname,
    key countryname as Countryname,
    portno as Portno,
    portofloading as Portofloading,
    portofclearance as Portofclearance
    
}
