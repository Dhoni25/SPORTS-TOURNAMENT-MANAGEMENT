@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Tournament Root Interface View'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZCII_TRMT_IT023
  as select from zcit_trmt_it023 as TournamentHeader
  composition [0..*] of ZCII_MTCH_IT023 as _Match
{
  key tournamentid      as TournamentId,
      tournamentname    as TournamentName,
      sport             as Sport,
      startdate         as StartDate,
      enddate           as EndDate,
      venue             as Venue,
      organizer         as Organizer,
      status            as Status,
      maxteams          as MaxTeams,
      @Semantics.amount.currencyCode: 'Currency'
      prizepoolamount   as PrizePoolAmount,
      currency          as Currency,
      @Semantics.user.createdBy: true
      local_created_by  as LocalCreatedBy,
      @Semantics.systemDateTime.createdAt: true
      local_created_at  as LocalCreatedAt,
      @Semantics.user.lastChangedBy: true
      local_last_changed_by as LocalLastChangedBy,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,
 
      /* Associations */
      _Match
}
