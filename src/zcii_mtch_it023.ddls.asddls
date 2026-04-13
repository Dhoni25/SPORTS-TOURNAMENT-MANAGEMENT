@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Match Child Interface View'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{ serviceQuality: #X, sizeCategory: #S, dataClass: #MIXED }
define view entity ZCII_MTCH_IT023
  as select from zcit_mtch_it023
  association to parent ZCII_TRMT_IT023 as _Tournament
    on $projection.TournamentId = _Tournament.TournamentId
{
  key tournamentid      as TournamentId,
  key matchnumber       as MatchNumber,
      team1             as Team1,
      team2             as Team2,
      matchdate         as MatchDate,
      matchvenue        as MatchVenue,
      team1score        as Team1Score,
      team2score        as Team2Score,
      winner            as Winner,
      matchstatus       as MatchStatus,
      @Semantics.user.createdBy: true
      local_created_by  as LocalCreatedBy,
      @Semantics.systemDateTime.createdAt: true
      local_created_at  as LocalCreatedAt,
      @Semantics.user.lastChangedBy: true
      local_last_changed_by as LocalLastChangedBy,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,
 
      /* Associations */
      _Tournament
}
