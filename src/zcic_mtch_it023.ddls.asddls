
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Match Consumption View'
@Search.searchable: true
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZCIC_MTCH_IT023
  as projection on ZCII_MTCH_IT023
{
  key TournamentId,
  key MatchNumber,
      @Search.defaultSearchElement: true
      Team1,
      Team2,
      MatchDate,
      MatchVenue,
      Team1Score,
      Team2Score,
      Winner,
      MatchStatus,
      LocalCreatedBy,
      LocalCreatedAt,
      LocalLastChangedBy,
      LocalLastChangedAt,
 
      /* Associations */
      _Tournament : redirected to parent ZCIC_TRMT_IT023
}
