@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Tournament Consumption View'
@Search.searchable: true
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZCIC_TRMT_IT023
  provider contract transactional_query
  as projection on ZCII_TRMT_IT023
{
  key TournamentId,
      TournamentName,
      Sport,
      StartDate,
      EndDate,
      Venue,
      Organizer,
      @Search.defaultSearchElement: true
      Status,
      MaxTeams,
      @Semantics.amount.currencyCode: 'Currency'
      PrizePoolAmount,
      Currency,
      LocalCreatedBy,
      LocalCreatedAt,
      LocalLastChangedBy,
      LocalLastChangedAt,
 
      /* Associations */
      _Match : redirected to composition child ZCIC_MTCH_IT023
}
